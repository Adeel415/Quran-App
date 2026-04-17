import 'ayah_model.dart';

class SurahModel {
  final int id;
  final String name;
  final String arabicName;
  final String englishName;
  final int ayahCount;
  final String revelationType;
  final List<AyahModel> ayahs;
  final int globalStart;

  const SurahModel({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.englishName,
    required this.ayahCount,
    required this.revelationType,
    this.ayahs = const [],
    required this.globalStart,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json, {int globalStart = 0}) {
    final rawAyahs = json['ayahs'] as List<dynamic>?;
    return SurahModel(
      id: json['id'] as int? ?? json['number'] as int? ?? 0,
      name: json['name'] as String? ?? json['englishName'] as String? ?? '',
      arabicName: json['arabic_name'] as String? ??
          json['arabic'] as String? ??
          json['name_arabic'] as String? ??
          json['name'] as String? ?? '',
      englishName: json['english_name'] as String? ??
          json['englishNameTranslation'] as String? ??
          json['english'] as String? ?? '',
      ayahCount: json['ayah_count'] as int? ??
          json['numberOfAyahs'] as int? ??
          (rawAyahs?.length ?? 0),
      revelationType: json['revelation_type'] as String? ??
          json['revelationType'] as String? ?? 'Meccan',
      ayahs: rawAyahs
          ?.map((a) => AyahModel.fromJson(
                a as Map<String, dynamic>,
                surahId: json['id'] as int? ?? 0,
                globalStart: globalStart,
              ))
          .toList() ??
          [],
      globalStart: globalStart,
    );
  }

  factory SurahModel.fromStaticData(Map<String, dynamic> data) {
    return SurahModel(
      id: data['id'] as int,
      name: data['name'] as String,
      arabicName: data['arabic'] as String,
      englishName: data['english'] as String,
      ayahCount: data['ayahs'] as int,
      revelationType: data['type'] as String,
      globalStart: data['start'] as int,
    );
  }

  SurahModel copyWith({List<AyahModel>? ayahs}) {
    return SurahModel(
      id: id,
      name: name,
      arabicName: arabicName,
      englishName: englishName,
      ayahCount: ayahCount,
      revelationType: revelationType,
      ayahs: ayahs ?? this.ayahs,
      globalStart: globalStart,
    );
  }
}
