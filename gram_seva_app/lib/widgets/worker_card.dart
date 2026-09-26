import 'package:flutter/material.dart';
import '../models/worker.dart';
import '../theme/app_theme.dart';
import 'app_badges.dart';

class WorkerCard extends StatelessWidget {
  final Worker worker;
  final String societyName; // resolved by the parent screen from societies lookup
  final VoidCallback onBook;

  const WorkerCard({
    super.key,
    required this.worker,
    required this.societyName,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.teal100,
                  child: Text(
                    _initials(worker.name),
                    style: const TextStyle(color: AppColors.deepTeal, fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              worker.name,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (worker.verified) ...[
                            const SizedBox(width: 5),
                            const VerifiedBadge(showLabel: false, iconSize: 16),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      // Society name - kept visible here, not buried in a
                      // profile page, since it's the platform's core
                      // differentiator.
                      Text(societyName, style: const TextStyle(fontSize: 12.5, color: AppColors.slate)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 15, color: AppColors.saffron),
                          const SizedBox(width: 3),
                          Text(
                            worker.ratingAvg.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.ink),
                          ),
                          Text(' (${worker.ratingCount})', style: const TextStyle(fontSize: 11.5, color: AppColors.slate)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (worker.skills.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: worker.skills.take(3).map((s) => _SkillChip(label: s)).toList(),
              ),
            ],
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                  minimumSize: Size.zero,
                  textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                onPressed: onBook,
                child: const Text('Book'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  const _SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: AppColors.mist, borderRadius: BorderRadius.circular(AppRadius.pill)),
      child: Text(label, style: const TextStyle(fontSize: 11, color: AppColors.ink, fontWeight: FontWeight.w500)),
    );
  }
}
