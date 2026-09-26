import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/booking.dart';
import '../../services/api_service.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_badges.dart';

class WorkerRequestsScreen extends StatefulWidget {
  const WorkerRequestsScreen({super.key});

  @override
  State<WorkerRequestsScreen> createState() => _WorkerRequestsScreenState();
}

class _WorkerRequestsScreenState extends State<WorkerRequestsScreen> {
  final _api = ApiService();
  List<Booking> _bookings = [];
  bool _loading = true;

  // TODO: replace with the logged-in worker's real _id once
  // registration/login is tied to a persisted session.
  static const demoWorkerId = 'demo-worker-id';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final bookings = await _api.getWorkerBookings(demoWorkerId);
      setState(() => _bookings = bookings);
    } catch (_) {
      // swallow for prototype - add a real error state before demo day
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _respond(Booking booking, String status) async {
    try {
      await _api.updateBookingStatus(booking.id, status);
      _load();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not update booking. Try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    final requested = _bookings.where((b) => b.status == 'requested').toList();

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const _WorkerHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.notifications_none_rounded, size: 20, color: AppColors.deepTeal),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text('New requests',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.ink)),
                    ),
                    if (requested.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.teal100, borderRadius: BorderRadius.circular(AppRadius.pill)),
                        child: Text('${requested.length}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.deepTeal)),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                if (requested.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text('No new requests right now.', style: TextStyle(color: AppColors.slate)),
                  )
                else
                  ...requested.map((b) => _JobRequestCard(
                        booking: b,
                        onAccept: () => _respond(b, 'accepted'),
                        onReject: () => _respond(b, 'rejected'),
                      )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkerHeader extends StatelessWidget {
  const _WorkerHeader();

  @override
  Widget build(BuildContext context) {
    final phone = context.watch<AppState>().mobileNumber ?? '';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 22),
      decoration: const BoxDecoration(
        color: AppColors.deepTeal,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Flexible(
                      child: Text('Good day',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                          overflow: TextOverflow.ellipsis),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.verified_rounded, size: 18, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 2),
                Text(phone.isEmpty ? 'Cooperative worker' : phone,
                    style: const TextStyle(fontSize: 12.5, color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _JobRequestCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _JobRequestCard({required this.booking, required this.onAccept, required this.onReject});

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
                  child: Text(
                    booking.serviceSlug.replaceAll('-', ' '),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink),
                  ),
                ),
                if (booking.isEmergency) const EmergencyBadge(),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                    ),
                    onPressed: onReject,
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.deepTeal),
                    onPressed: onAccept,
                    child: const Text('Accept'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
