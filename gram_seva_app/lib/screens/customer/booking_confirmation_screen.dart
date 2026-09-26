import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/worker.dart';
import '../../services/api_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_badges.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final Worker worker;
  final String societyName;
  final String serviceSlug;

  const BookingConfirmationScreen({
    super.key,
    required this.worker,
    required this.societyName,
    required this.serviceSlug,
  });

  @override
  State<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  final _api = ApiService();
  final _addressController = TextEditingController();

  DateTime _scheduledAt = DateTime.now().add(const Duration(days: 1, hours: 1));
  bool _isEmergency = false;
  bool _submitting = false;

  // Mock pricing — matches the "co-op approved pricing" concept from the
  // design: rates are set by the cooperative society, not the individual
  // worker. Not wired to a real pricing engine yet — see backend README.
  static const double _baseFee = 350;
  static const double _emergencyPremium = 150;

  double get _total => _baseFee + (_isEmergency ? _emergencyPremium : 0);

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledAt,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_scheduledAt),
    );
    if (time == null) return;

    setState(() {
      _scheduledAt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _confirmBooking() async {
    setState(() => _submitting = true);
    try {
      // TODO: replace with the real logged-in customer's Firebase UID
      await _api.createBooking(
        customerUid: 'demo-customer-uid',
        workerId: widget.worker.id,
        serviceSlug: widget.serviceSlug,
        isEmergency: _isEmergency,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking requested with ${widget.worker.name}')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not create booking. Try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('EEE, d MMM · h:mm a').format(_scheduledAt);

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm booking')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _workerCard(),
          const SizedBox(height: 20),

          _label('PREFERRED DATE & TIME'),
          const SizedBox(height: 8),
          _tappableRow(icon: Icons.calendar_today_outlined, text: dateLabel, onTap: _pickDateTime),
          const SizedBox(height: 16),

          _label('SERVICE ADDRESS'),
          const SizedBox(height: 8),
          TextField(
            controller: _addressController,
            decoration: InputDecoration(
              hintText: 'Sector 4, Kalyan Puram, House 24B',
              prefixIcon: const Icon(Icons.location_on_outlined, size: 20, color: AppColors.slate),
              suffixIcon: IconButton(
                icon: const Icon(Icons.my_location, size: 18, color: AppColors.deepTeal),
                tooltip: 'Use current location',
                onPressed: () {
                  // TODO: wire geolocator package here to fill in the
                  // address/coordinates automatically.
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _isEmergency ? const Color(0xFFFDEEEC) : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: _isEmergency ? AppColors.urgentCoral.withValues(alpha: 0.4) : AppColors.cardBorder, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(color: AppColors.urgentCoral.withValues(alpha: 0.15), shape: BoxShape.circle),
                  child: const Icon(Icons.bolt_rounded, size: 18, color: AppColors.urgentCoral),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('Emergency booking',
                              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.ink)),
                          if (_isEmergency) ...[
                            const SizedBox(width: 8),
                            Text('+₹${_emergencyPremium.toStringAsFixed(0)} premium',
                                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.urgentCoral)),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Dispatch within 2 hours. Local co-op members are prioritized.',
                        style: TextStyle(fontSize: 11, color: AppColors.secondaryGrey),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isEmergency,
                  activeThumbColor: Colors.white,
                  activeTrackColor: AppColors.urgentCoral,
                  onChanged: (v) => setState(() => _isEmergency = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          _pricingCard(),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _submitting ? null : _confirmBooking,
            child: _submitting
                ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Confirm booking'),
          ),
        ],
      ),
    );
  }

  Widget _workerCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.teal100,
            child: Text(_initials(widget.worker.name),
                style: const TextStyle(color: AppColors.deepTeal, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(widget.worker.name,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink),
                          overflow: TextOverflow.ellipsis),
                    ),
                    if (widget.worker.verified) ...[
                      const SizedBox(width: 6),
                      const VerifiedBadge(iconSize: 14),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(widget.societyName, style: const TextStyle(fontSize: 12, color: AppColors.slate)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 14, color: AppColors.saffron),
                    const SizedBox(width: 3),
                    Text(
                      '${widget.worker.ratingAvg.toStringAsFixed(1)} · ${widget.serviceSlug.replaceAll('-', ' ')}',
                      style: const TextStyle(fontSize: 11.5, color: AppColors.slate),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pricingCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('CO-OP APPROVED PRICING',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.secondaryGrey, letterSpacing: 0.3)),
          const SizedBox(height: 10),
          _priceRow('Standard base fee (first 2 hrs)', _baseFee),
          if (_isEmergency) _priceRow('Emergency premium', _emergencyPremium),
          const Divider(height: 20),
          _priceRow('Total', _total, bold: true),
          const SizedBox(height: 8),
          const Text(
            'All base rates are decided directly by the Labour Cooperative Societies to prevent individual worker exploitation. Final billing depends on actual hours worked.',
            style: TextStyle(fontSize: 10, color: AppColors.mutedGrey),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, double amount, {bool bold = false}) {
    final style = TextStyle(
      fontSize: bold ? 15 : 12,
      fontWeight: bold ? FontWeight.w800 : FontWeight.w400,
      color: bold ? AppColors.ink : AppColors.secondaryGrey,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text('₹${amount.toStringAsFixed(0)}', style: style),
        ],
      ),
    );
  }

  Widget _tappableRow({required IconData icon, required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.control),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: AppColors.deepTeal),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: AppColors.ink))),
            const Icon(Icons.edit_outlined, size: 14, color: AppColors.mutedGrey),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.secondaryGrey, letterSpacing: 0.3),
      );

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }
}
