import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../localization/app_strings.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../home_shell.dart';

/// First screen shown at launch, for both household and worker users.
/// Two steps in one screen: pick a language, enter a mobile number.
///
/// TODO: this does not verify the mobile number yet (no OTP). Wire in
/// Firebase Phone Auth's OTP flow before the national round - for the
/// internal-hackathon prototype, entering a number and tapping Continue
/// is enough to demonstrate the flow.
class LanguageMobileLoginScreen extends StatefulWidget {
  const LanguageMobileLoginScreen({super.key});

  @override
  State<LanguageMobileLoginScreen> createState() => _LanguageMobileLoginScreenState();
}

class _LanguageMobileLoginScreenState extends State<LanguageMobileLoginScreen> {
  String _selectedLanguage = 'en';
  final _phoneController = TextEditingController();
  String? _error;

  void _continue() {
    final phone = _phoneController.text.trim();
    if (phone.length < 10) {
      setState(() => _error = 'Enter a valid mobile number');
      return;
    }

    final appState = context.read<AppState>();
    appState.setLanguage(_selectedLanguage);
    appState.setMobileNumber(phone);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmIvory,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 56),
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(color: AppColors.teal100, borderRadius: BorderRadius.circular(22)),
                  child: const Icon(Icons.cottage_rounded, color: AppColors.deepTeal, size: 36),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'GramSeva',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.deepTeal),
              ),
              const SizedBox(height: 4),
              const Text(
                'Trusted services. Stronger communities.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.5, color: AppColors.slate),
              ),
              const SizedBox(height: 44),

              Text(
                AppStrings.t('selectLanguage', _selectedLanguage),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.slate, letterSpacing: 0.3),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: supportedLanguages.map((lang) {
                  final selected = _selectedLanguage == lang.code;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedLanguage = lang.code),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.deepTeal : Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.control),
                        border: Border.all(color: selected ? AppColors.deepTeal : AppColors.cardBorder),
                      ),
                      child: Text(
                        lang.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: selected ? Colors.white : AppColors.ink,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),
              Text(
                AppStrings.t('mobileNumber', _selectedLanguage),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.slate, letterSpacing: 0.3),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: '+91 98765 43210',
                  prefixIcon: Icon(Icons.phone_outlined, size: 20, color: AppColors.slate),
                ),
              ),

              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(_error!, style: const TextStyle(color: AppColors.error, fontSize: 12)),
              ],

              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _continue,
                child: Text(AppStrings.t('continueLabel', _selectedLanguage)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
