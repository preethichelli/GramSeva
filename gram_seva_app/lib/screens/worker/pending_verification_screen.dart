import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../home_shell.dart';

/// Shown right after a worker submits their registration. In the real
/// product this state lasts until the cooperative society verifies them;
/// here (no verification backend yet) it's an honest stopping point with
/// a "back to home" path, plus a clearly-labeled demo shortcut so judges
/// can still see the worker dashboard without waiting on a real review.
class PendingVerificationScreen extends StatelessWidget {
  const PendingVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: const BoxDecoration(color: AppColors.teal100, shape: BoxShape.circle),
                child: const Icon(Icons.hourglass_top_rounded, color: AppColors.deepTeal, size: 38),
              ),
              const SizedBox(height: 24),
              const Text(
                'Your registration is under review',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.ink),
              ),
              const SizedBox(height: 10),
              const Text(
                "Your cooperative society typically reviews new worker registrations within 2-3 business days. We'll let you know as soon as you're verified.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.5, color: AppColors.slate, height: 1.4),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                  child: const Text('Back to Home'),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  context.read<AppState>().setRole(UserRole.worker);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomeShell()),
                    (route) => false,
                  );
                },
                child: const Text('Preview worker dashboard (demo)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
