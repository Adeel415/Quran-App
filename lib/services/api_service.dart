import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/surah_model.dart';
import '../models/ayah_model.dart';
import '../utils/constants.dart';
import '../utils/quran_data.dart';

enum ApiStatus { idle, loading, success, error }

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final _client = http.Client();
  static const _timeout = Duration(seconds: 15);

  // ─── Surah List ───────────────────────────────────────────────────────────
  /// Returns all surahs from static data immediately (instant load).
  List<SurahModel> getAllSurahs() {
    return QuranData.surahs
        .map((data) => SurahModel.fromStaticData(data))
        .toList();
  }

  // ─── Surah Detail ─────────────────────────────────────────────────────────
  /// Fetches surah with ayahs from FastAPI backend.
  /// Falls back to the public alquran.cloud API on failure.
  Future<SurahModel?> getSurah(int surahId) async {
    // Try FastAPI backend first
    try {
      final res = await _client
          .get(Uri.parse('${AppConstants.baseUrl}${AppConstants.surahEndpoint(surahId)}'))
          .timeout(_timeout);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final staticData = QuranData.getSurahById(surahId);
        final globalStart = staticData?['start'] as int? ?? 1;
        return SurahModel.fromJson(data, globalStart: globalStart);
      }
    } catch (_) {
      // Fall through to public API
    }

    // Fallback: public alquran.cloud API
    return _fetchFromPublicApi(surahId);
  }

  Future<SurahModel?> _fetchFromPublicApi(int surahId) async {
    try {
      // Fetch Arabic text
      final arabicRes = await _client
          .get(Uri.parse('https://api.alquran.cloud/v1/surah/$surahId'))
          .timeout(_timeout);

      // Fetch English translation
      final transRes = await _client
          .get(Uri.parse('https://api.alquran.cloud/v1/surah/$surahId/en.asad'))
          .timeout(_timeout);

      if (arabicRes.statusCode != 200) return null;

      final arabicData = jsonDecode(arabicRes.body)['data'] as Map<String, dynamic>;
      final transAyahs = transRes.statusCode == 200
          ? (jsonDecode(transRes.body)['data']['ayahs'] as List<dynamic>)
          : null;

      final staticData = QuranData.getSurahById(surahId);
      final globalStart = staticData?['start'] as int? ?? 1;

      final rawAyahs = arabicData['ayahs'] as List<dynamic>;
      final ayahs = rawAyahs.asMap().entries.map((entry) {
        final idx = entry.key;
        final a = entry.value as Map<String, dynamic>;
        final num = a['numberInSurah'] as int? ?? (idx + 1);
        final trans = transAyahs != null && idx < transAyahs.length
            ? (transAyahs[idx] as Map<String, dynamic>)['text'] as String? ?? ''
            : '';

        return AyahModel(
          number: num,
          surahId: surahId,
          arabic: a['text'] as String? ?? '',
          translation: trans,
          globalNumber: globalStart + num - 1,
          audioUrl: AppConstants.ayahAudioUrl(globalStart + num - 1),
        );
      }).toList();

      return SurahModel.fromStaticData(staticData!).copyWith(ayahs: ayahs);
    } catch (e) {
      return null;
    }
  }

  // ─── Surah Range ──────────────────────────────────────────────────────────
  Future<List<AyahModel>> getAyahRange(int surahId, int start, int end) async {
    try {
      final url = '${AppConstants.baseUrl}${AppConstants.surahRangeEndpoint(surahId, start, end)}';
      final res = await _client.get(Uri.parse(url)).timeout(_timeout);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data is List) {
          final staticData = QuranData.getSurahById(surahId);
          final globalStart = staticData?['start'] as int? ?? 1;
          return data
              .map((a) => AyahModel.fromJson(a as Map<String, dynamic>,
                  surahId: surahId, globalStart: globalStart))
              .toList();
        }
      }
    } catch (_) {}
    return [];
  }

  // ─── Search ───────────────────────────────────────────────────────────────
  Future<List<SurahModel>> searchSurahs(String query) async {
    if (query.trim().isEmpty) return getAllSurahs();

    // Search static data immediately
    final staticResults = QuranData.search(query)
        .map((data) => SurahModel.fromStaticData(data))
        .toList();

    // Try server search in background
    try {
      final url = '${AppConstants.baseUrl}${AppConstants.searchEndpoint(query)}';
      final res = await _client.get(Uri.parse(url)).timeout(_timeout);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data is List && data.isNotEmpty) {
          return data
              .map((s) => SurahModel.fromJson(s as Map<String, dynamic>))
              .toList();
        }
      }
    } catch (_) {}

    return staticResults;
  }

  void dispose() => _client.close();
}
