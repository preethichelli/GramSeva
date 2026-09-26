import 'package:flutter/material.dart';
import '../../models/booking.dart';
import '../../services/api_service.dart';
import '../../theme/app_theme.dart';

class WorkerEarningsScreen extends StatefulWidget {
  const WorkerEarningsScreen({super.key});

  @override
  State<WorkerEarningsScreen> createState() => _WorkerEarningsScreenState();
}

class _WorkerEarningsScreenState extends State<WorkerEarningsScreen> {
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

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    final completed = _bookings.where((b) => b.status == 'completed').toList();
    final ratedJobs = completed.where((b) => b.rating != null).toList();
    final avgRating =
        ratedJobs.isEmpty ? null : ratedJobs.map((b) => b.rating!).reduce((a, b) => a + b) / ratedJobs.length;

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(child: _StatCard(label: 'Jobs completed', value: '${completed.length}', icon: Icons.task_alt_rounded)),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  label: 'Average rating',
                  value: avgRating == null ? '—' : avgRating.toStringAsFixed(1),
                  icon: Icons.star_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.sand, borderRadius: BorderRadius.circular(AppRadius.card)),
            child: const Row(
              children: [
                Icon(Icons.volunteer_activism_rounded, color: AppColors.saffron700),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Your society sets fair, transparent rates - your earnings reflect your skill, not a platform commission.',
                    style: TextStyle(fontSize: 12.5, color: AppColors.ink),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payout details', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink)),
                SizedBox(height: 6),
                Text(
                  'Per-job invoicing and payout history will appear here once digital payments are wired up on the backend.',
                  style: TextStyle(fontSize: 12, color: AppColors.slate),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.deepTeal, size: 20),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.ink)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11.5, color: AppColors.slate)),
        ],
      ),
    );
  }
}
