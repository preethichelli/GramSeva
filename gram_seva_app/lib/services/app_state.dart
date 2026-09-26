import 'package:flutter/foundation.dart';

enum UserRole { household, worker }

/// Holds the few things almost every screen needs: which mode the user is
/// currently in, and (once registered) their worker record id.
/// A single logged-in person CAN hold both roles - so this only tracks
/// the *active* mode, not identity.
class AppState extends ChangeNotifier {
  UserRole _activeRole = UserRole.household;
  String? workerId; // set after worker registration/lookup completes
  String languageCode = 'en'; // set on the language + mobile login screen
  String? mobileNumber;

  // Session-only flag: true once this device has submitted a worker
  // registration this session. Not tied to a real backend "is this phone
  // number already a verified worker" check yet - see the TODOs in
  // worker_registration_screen.dart - so it resets on app restart.
  bool workerRegistered = false;

  UserRole get activeRole => _activeRole;

  void setRole(UserRole role) {
    _activeRole = role;
    notifyListeners();
  }

  void toggleRole() {
    _activeRole = _activeRole == UserRole.household ? UserRole.worker : UserRole.household;
    notifyListeners();
  }

  void setLanguage(String code) {
    languageCode = code;
    notifyListeners();
  }

  void setMobileNumber(String number) {
    mobileNumber = number;
    notifyListeners();
  }

  void setWorkerRegistered(bool value) {
    workerRegistered = value;
    notifyListeners();
  }
}
