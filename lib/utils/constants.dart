class AppConstants {
  // Replace with your actual FastAPI server IP
  static const String baseUrl = 'http://YOUR_IP:8000';

  // API Endpoints
  static const String surahListEndpoint = '/surah';
  static String surahEndpoint(int id) => '/surah/$id';
  static String surahRangeEndpoint(int id, int start, int end) => '/surah/$id/$start/$end';
  static String searchEndpoint(String query) => '/search?query=$query';

  // Audio CDN — Mishary Rashid Al-Afasy (128kbps)
  static const String audioCdn = 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/';
  static String ayahAudioUrl(int globalAyahNumber) =>
      '$audioCdn$globalAyahNumber.mp3';

  // Translation API (fallback)
  static String translationApi(int surahId) =>
      'https://api.alquran.cloud/v1/surah/$surahId/en.asad';

  // SharedPreferences Keys
  static const String lastReadSurahKey = 'last_read_surah';
  static const String lastReadAyahKey = 'last_read_ayah';
  static const String lastReadSurahNameKey = 'last_read_surah_name';
  static const String favoritesKey = 'favorites';
  static const String isDarkModeKey = 'is_dark_mode';

  // Hive Box Names
  static const String favoritesBox = 'favorites_box';
  static const String settingsBox = 'settings_box';

  // UI
  static const double borderRadius = 16.0;
  static const double cardElevation = 0.0;
  static const double screenPadding = 16.0;
  static const Duration animDuration = Duration(milliseconds: 400);
  static const Duration shortAnim = Duration(milliseconds: 200);
  static const Duration longAnim = Duration(milliseconds: 600);

  // Audio
  static const Duration audioSeekStep = Duration(seconds: 5);
}
