import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'services/app_state.dart';
import 'screens/auth/language_mobile_login_screen.dart';

// Firebase is not initialized in this build - the language + mobile
// number screen is the entry point for the prototype. Wire in
// Firebase.initializeApp() + Phone Auth OTP verification before your
// national round demo; see language_mobile_login_screen.dart's TODO.

void main() {
  runApp(const GramSevaApp());
}

class GramSevaApp extends StatelessWidget {
  const GramSevaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'GramSeva',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const LanguageMobileLoginScreen(),
      ),
    );
  }
}
