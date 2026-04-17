import 'package:flutter/foundation.dart';
import '../models/surah_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

enum LoadState { idle, loading, success, error }

class QuranProvider extends ChangeNotifier {
  final _api = ApiService();
  final _storage = StorageService();

  // ─── Surah List ───────────────────────────────────────────────────────────
  List<SurahModel> _allSurahs = [];
  List<SurahModel> _filteredSurahs = [];
  String _searchQuery = '';
  LoadState _listState = LoadState.idle;

  List<SurahModel> get allSurahs => _allSurahs;
  List<SurahModel> get filteredSurahs =>
      _searchQuery.isEmpty ? _allSurahs : _filteredSurahs;
  String get searchQuery => _searchQuery;
  LoadState get listState => _listState;

  // ─── Surah Detail ─────────────────────────────────────────────────────────
  SurahModel? _currentSurah;
  LoadState _detailState = LoadState.idle;
  String? _errorMessage;

  SurahModel? get currentSurah => _currentSurah;
  LoadState get detailState => _detailState;
  String? get errorMessage => _errorMessage;
  bool get isDetailLoading => _detailState == LoadState.loading;

  // ─── Last Read ────────────────────────────────────────────────────────────
  Map<String, dynamic>? _lastRead;
  Map<String, dynamic>? get lastRead => _lastRead;

  // ─── Init ──────────────────────────────────────────────────────────────────
  Future<void> initialize() async {
    await _storage.init();
    _loadSurahList();
    _loadLastRead();
  }

  void _loadSurahList() {
    _listState = LoadState.loading;
    notifyListeners();

    _allSurahs = _api.getAllSurahs();
    _listState = LoadState.success;
    notifyListeners();
  }

  void _loadLastRead() {
    _lastRead = _storage.getLastRead();
    notifyListeners();
  }

  // ─── Search ───────────────────────────────────────────────────────────────
  void search(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredSurahs = _allSurahs;
    } else {
      final q = query.toLowerCase();
      _filteredSurahs = _allSurahs.where((s) {
        return s.name.toLowerCase().contains(q) ||
            s.englishName.toLowerCase().contains(q) ||
            s.arabicName.contains(query) ||
            s.id.toString() == query;
      }).toList();
    }
    notifyListeners();
  }

  void clearSearch() => search('');

  // ─── Surah Detail ─────────────────────────────────────────────────────────
  Future<void> loadSurah(int surahId) async {
    if (_currentSurah?.id == surahId && _currentSurah!.ayahs.isNotEmpty) return;

    _detailState = LoadState.loading;
    _currentSurah = null;
    _errorMessage = null;
    notifyListeners();

    final surah = await _api.getSurah(surahId);
    if (surah != null) {
      _currentSurah = surah;
      _detailState = LoadState.success;
    } else {
      _errorMessage = 'Failed to load surah. Please check your connection.';
      _detailState = LoadState.error;
    }
    notifyListeners();
  }

  Future<void> reloadSurah(int surahId) async {
    _detailState = LoadState.loading;
    notifyListeners();
    final surah = await _api.getSurah(surahId);
    if (surah != null) {
      _currentSurah = surah;
      _detailState = LoadState.success;
    } else {
      _errorMessage = 'Failed to load surah.';
      _detailState = LoadState.error;
    }
    notifyListeners();
  }

  // ─── Last Read ────────────────────────────────────────────────────────────
  Future<void> saveLastRead(int surahId, int ayahNumber, String surahName) async {
    await _storage.saveLastRead(
      surahId: surahId,
      ayahNumber: ayahNumber,
      surahName: surahName,
    );
    _lastRead = {
      'surah_id': surahId,
      'ayah_number': ayahNumber,
      'surah_name': surahName,
    };
    notifyListeners();
  }
}
