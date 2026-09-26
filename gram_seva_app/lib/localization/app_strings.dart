/// Simple manual localization for the prototype stage.
///
/// This intentionally skips Flutter's official `intl`/ARB code-generation
/// pipeline (flutter gen-l10n) since that needs to run through the Flutter
/// SDK's build step. A flat string map is enough to prove multilingual
/// support for your demo; swap this out for real ARB-based localization
/// once you have time before the national round.
library;

class AppLanguage {
  final String code; // e.g. 'en'
  final String label; // shown in the language picker, in that language's own script
  const AppLanguage(this.code, this.label);
}

const supportedLanguages = [
  AppLanguage('en', 'English'),
  AppLanguage('hi', 'हिंदी'),
  AppLanguage('te', 'తెలుగు'),
];

class AppStrings {
  static const Map<String, Map<String, String>> _values = {
    'appTitle': {
      'en': 'GramSeva',
      'hi': 'ग्रामसेवा',
      'te': 'గ్రామసేవ',
    },
    'selectLanguage': {
      'en': 'Select your language',
      'hi': 'अपनी भाषा चुनें',
      'te': 'మీ భాషను ఎంచుకోండి',
    },
    'mobileNumber': {
      'en': 'Mobile number',
      'hi': 'मोबाइल नंबर',
      'te': 'మొబైల్ నంబర్',
    },
    'continueLabel': {
      'en': 'Continue',
      'hi': 'जारी रखें',
      'te': 'కొనసాగించండి',
    },
    'household': {
      'en': 'Household',
      'hi': 'घर',
      'te': 'ఇల్లు',
    },
    'worker': {
      'en': 'Worker',
      'hi': 'कामगार',
      'te': 'కార్మికుడు',
    },
    'searchService': {
      'en': 'Search a service',
      'hi': 'सेवा खोजें',
      'te': 'సేవను వెతకండి',
    },
    'services': {
      'en': 'Services',
      'hi': 'सेवाएं',
      'te': 'సేవలు',
    },
    'verifiedWorkersNearby': {
      'en': 'Verified workers nearby',
      'hi': 'आस-पास सत्यापित कामगार',
      'te': 'సమీపంలో ధృవీకరించబడిన కార్మికులు',
    },
    'noVerifiedWorkers': {
      'en': 'No verified workers yet for this service.',
      'hi': 'इस सेवा के लिए अभी कोई सत्यापित कामगार नहीं है।',
      'te': 'ఈ సేవ కోసం ఇంకా ధృవీకరించబడిన కార్మికులు లేరు.',
    },
    'newRequests': {
      'en': 'New requests',
      'hi': 'नए अनुरोध',
      'te': 'కొత్త అభ్యర్థనలు',
    },
    'activeJobs': {
      'en': 'Active jobs',
      'hi': 'सक्रिय काम',
      'te': 'యాక్టివ్ పనులు',
    },
    'noNewRequests': {
      'en': 'No new requests right now.',
      'hi': 'अभी कोई नया अनुरोध नहीं है।',
      'te': 'ప్రస్తుతం కొత్త అభ్యర్థనలు లేవు.',
    },
    'noActiveJobs': {
      'en': 'No active jobs.',
      'hi': 'कोई सक्रिय काम नहीं है।',
      'te': 'యాక్టివ్ పనులు లేవు.',
    },
    'notRegisteredYet': {
      'en': 'Not registered as a cooperative worker yet?',
      'hi': 'अभी तक सहकारी कामगार के रूप में पंजीकृत नहीं हैं?',
      'te': 'ఇంకా సహకార కార్మికుడిగా నమోదు కాలేదా?',
    },
    'register': {
      'en': 'Register your services',
      'hi': 'अपनी सेवाएं पंजीकृत करें',
      'te': 'మీ సేవలను నమోదు చేయండి',
    },
    'areYouSkilledWorker': {
      'en': 'Are you a skilled worker?',
      'hi': 'क्या आप एक कुशल कामगार हैं?',
      'te': 'మీరు నైపుణ్యం గల కార్మికులా?',
    },
  };

  static String t(String key, String languageCode) {
    return _values[key]?[languageCode] ?? _values[key]?['en'] ?? key;
  }
}
