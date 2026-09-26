import 'package:flutter/material.dart';
import '../../models/booking.dart';
import '../../services/api_service.dart';
import '../../theme/app_theme.dart';

class WorkerActiveJobsScreen extends StatefulWidget {
  const WorkerActiveJobsScreen({super.key});

  @override
  State<WorkerActiveJobsScreen> createState() => _WorkerActiveJobsScreenState();
}

class _WorkerActiveJobsScreenState extends State<WorkerActiveJobsScreen> {
  final _api = ApiService();
  List<Booking> _bookings = [];
  bool _loading = true;

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
      // swallow for prototype
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _complete(Booking b) async {
    try {
      await _api.updateBookingStatus(b.id, 'completed');
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
    final active = _bookings.where((b) => b.status == 'accepted').toList();

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (active.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text('No active jobs.', style: TextStyle(color: AppColors.slate)),
            )
          else
            ...active.map((b) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(b.serviceSlug.replaceAll('-', ' '),
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink)),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                                decoration:
                                    BoxDecoration(color: AppColors.teal100, borderRadius: BorderRadius.circular(AppRadius.pill)),
                                child: const Text('Accepted',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.deepTeal)),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.deepTeal,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            minimumSize: Size.zero,
                          ),
                          onPressed: () => _complete(b),
                          child: const Text('Mark complete', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}
