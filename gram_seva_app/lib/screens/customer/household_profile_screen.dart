import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../worker/worker_registration_screen.dart';

class HouseholdProfileScreen extends StatelessWidget {
  const HouseholdProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _row('Mobile number', appState.mobileNumber ?? '—'),
              const Divider(height: 24),
              _row('Language', _languageLabel(appState.languageCode)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // A second, equally de-emphasized entry point into worker mode -
        // the main one lives as a banner on the Home tab.
        OutlinedButton.icon(
          onPressed: () {
            if (appState.workerRegistered) {
              appState.setRole(UserRole.worker);
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const WorkerRegistrationScreen()));
            }
          },
          icon: const Icon(Icons.engineering_outlined, size: 18),
          label: const Text('Register your services'),
        ),
      ],
    );
  }

  String _languageLabel(String code) {
    switch (code) {
      case 'hi':
        return 'हिंदी';
      case 'te':
        return 'తెలుగు';
      default:
        return 'English';
    }
  }

  Widget _row(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.slate)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink)),
      ],
    );
  }
}
