import 'package:flutter/material.dart';
import '../../models/booking.dart';
import '../../services/api_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_badges.dart';
import 'rating_screen.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  final _api = ApiService();
  List<Booking> _bookings = [];
  bool _loading = true;

  // Matches the same placeholder customer identity used when creating a
  // booking (see booking_confirmation_screen.dart) - swap both for the
  // real logged-in customer's Firebase UID once auth is wired up.
  static const demoCustomerUid = 'demo-customer-uid';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final bookings = await _api.getCustomerBookings(demoCustomerUid);
      setState(() => _bookings = bookings);
    } catch (_) {
      // swallow for prototype
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    if (_bookings.isEmpty) {
      return RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Text(
                "You haven't booked any services yet.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.slate),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: _bookings.map((b) => _BookingTile(booking: b, onRefresh: _load)).toList(),
      ),
    );
  }
}

class _BookingTile extends StatelessWidget {
  final Booking booking;
  final VoidCallback onRefresh;
  const _BookingTile({required this.booking, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(booking.serviceSlug.replaceAll('-', ' '),
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink)),
                ),
                if (booking.isEmergency)
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: EmergencyBadge(label: 'URGENT'),
                  ),
                BookingStatusChip(status: booking.status),
              ],
            ),
            if (booking.status == 'completed') ...[
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: booking.rating != null
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, size: 16, color: AppColors.saffron),
                          const SizedBox(width: 3),
                          Text('${booking.rating}/5 rated', style: const TextStyle(fontSize: 12, color: AppColors.slate)),
                        ],
                      )
                    : OutlinedButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => RatingScreen(booking: booking)),
                          );
                          onRefresh();
                        },
                        child: const Text('Rate this job'),
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
