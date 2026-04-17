import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  Future<void> init() async {
    _isDarkMode = _storage.isDarkMode;
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _storage.setDarkMode(_isDarkMode);
    notifyListeners();
  }
}
