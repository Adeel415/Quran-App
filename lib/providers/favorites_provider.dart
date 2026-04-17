import 'package:flutter/foundation.dart';
import '../models/favorite_model.dart';
import '../services/storage_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  List<FavoriteModel> _favorites = [];

  List<FavoriteModel> get favorites => _favorites;
  int get count => _favorites.length;

  Future<void> loadFavorites() async {
    _favorites = _storage.getFavorites();
    notifyListeners();
  }

  bool isFavorite(int surahId, int ayahNumber) {
    return _favorites.any((f) => f.surahId == surahId && f.ayahNumber == ayahNumber);
  }

  Future<bool> toggleFavorite({
    required int surahId,
    required int ayahNumber,
    required String surahName,
    required String arabicText,
    required String translation,
    required int globalNumber,
  }) async {
    final favorite = FavoriteModel(
      surahId: surahId,
      ayahNumber: ayahNumber,
      surahName: surahName,
      arabicText: arabicText,
      translation: translation,
      globalNumber: globalNumber,
      savedAt: DateTime.now(),
    );

    final wasAdded = await _storage.toggleFavorite(favorite);
    _favorites = _storage.getFavorites();
    notifyListeners();
    return wasAdded;
  }

  Future<void> removeFavorite(FavoriteModel favorite) async {
    _favorites.removeWhere((f) => f.id == favorite.id);
    await _storage.saveFavorites(_favorites);
    notifyListeners();
  }

  Future<void> clearAll() async {
    _favorites = [];
    await _storage.saveFavorites(_favorites);
    notifyListeners();
  }
}
