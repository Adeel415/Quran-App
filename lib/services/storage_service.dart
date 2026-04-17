import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/favorite_model.dart';
import '../utils/constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late SharedPreferences _prefs;
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  // ─── Last Read ────────────────────────────────────────────────────────────
  Future<void> saveLastRead({
    required int surahId,
    required int ayahNumber,
    required String surahName,
  }) async {
    await _prefs.setInt(AppConstants.lastReadSurahKey, surahId);
    await _prefs.setInt(AppConstants.lastReadAyahKey, ayahNumber);
    await _prefs.setString(AppConstants.lastReadSurahNameKey, surahName);
  }

  Map<String, dynamic>? getLastRead() {
    final surahId = _prefs.getInt(AppConstants.lastReadSurahKey);
    final ayahNumber = _prefs.getInt(AppConstants.lastReadAyahKey);
    final surahName = _prefs.getString(AppConstants.lastReadSurahNameKey);
    if (surahId == null) return null;
    return {
      'surah_id': surahId,
      'ayah_number': ayahNumber ?? 1,
      'surah_name': surahName ?? '',
    };
  }

  Future<void> clearLastRead() async {
    await _prefs.remove(AppConstants.lastReadSurahKey);
    await _prefs.remove(AppConstants.lastReadAyahKey);
    await _prefs.remove(AppConstants.lastReadSurahNameKey);
  }

  // ─── Favorites ────────────────────────────────────────────────────────────
  List<FavoriteModel> getFavorites() {
    try {
      final raw = _prefs.getStringList(AppConstants.favoritesKey) ?? [];
      return raw
          .map((s) => FavoriteModel.fromJson(jsonDecode(s) as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.savedAt.compareTo(a.savedAt));
    } catch (_) {
      return [];
    }
  }

  Future<void> saveFavorites(List<FavoriteModel> favorites) async {
    final raw = favorites.map((f) => jsonEncode(f.toJson())).toList();
    await _prefs.setStringList(AppConstants.favoritesKey, raw);
  }

  Future<bool> toggleFavorite(FavoriteModel favorite) async {
    final favorites = getFavorites();
    final exists = favorites.any((f) => f.id == favorite.id);
    if (exists) {
      favorites.removeWhere((f) => f.id == favorite.id);
    } else {
      favorites.add(favorite);
    }
    await saveFavorites(favorites);
    return !exists; // true = added
  }

  bool isFavorite(int surahId, int ayahNumber) {
    final favorites = getFavorites();
    return favorites.any((f) => f.surahId == surahId && f.ayahNumber == ayahNumber);
  }

  // ─── Settings ─────────────────────────────────────────────────────────────
  bool get isDarkMode => _prefs.getBool(AppConstants.isDarkModeKey) ?? false;

  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool(AppConstants.isDarkModeKey, value);
  }
}
