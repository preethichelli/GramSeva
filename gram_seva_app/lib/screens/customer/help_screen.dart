import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const _faqs = [
    (
      'How does GramSeva verify workers?',
      'Every worker is registered and verified directly by their Labour Cooperative Society before they can accept jobs.',
    ),
    (
      'Who sets the pricing?',
      "Your cooperative society sets base rates - not individual workers or a platform commission - to keep pricing fair for everyone.",
    ),
    (
      'What happens with emergency bookings?',
      'Emergency requests are flagged for faster dispatch and carry a visible premium, shown before you confirm.',
    ),
    (
      'How do I become a worker on GramSeva?',
      'Look for "Register your services" on the Home tab, then submit your details for your cooperative society to verify.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Frequently asked questions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink)),
        const SizedBox(height: 12),
        ..._faqs.map((f) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(f.$1, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.ink)),
                    const SizedBox(height: 6),
                    Text(f.$2, style: const TextStyle(fontSize: 12.5, color: AppColors.slate, height: 1.4)),
                  ],
                ),
              ),
            )),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.sand, borderRadius: BorderRadius.circular(AppRadius.card)),
          child: const Row(
            children: [
              Icon(Icons.support_agent_rounded, color: AppColors.saffron700),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Still need help? Contact your cooperative society directly for support with a booking.',
                  style: TextStyle(fontSize: 12.5, color: AppColors.ink),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
