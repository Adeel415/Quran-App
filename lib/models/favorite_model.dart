class FavoriteModel {
  final int surahId;
  final int ayahNumber;
  final String surahName;
  final String arabicText;
  final String translation;
  final int globalNumber;
  final DateTime savedAt;

  const FavoriteModel({
    required this.surahId,
    required this.ayahNumber,
    required this.surahName,
    required this.arabicText,
    required this.translation,
    required this.globalNumber,
    required this.savedAt,
  });

  String get id => '${surahId}_$ayahNumber';

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      surahId: json['surah_id'] as int,
      ayahNumber: json['ayah_number'] as int,
      surahName: json['surah_name'] as String,
      arabicText: json['arabic_text'] as String,
      translation: json['translation'] as String,
      globalNumber: json['global_number'] as int,
      savedAt: DateTime.tryParse(json['saved_at'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'surah_id': surahId,
    'ayah_number': ayahNumber,
    'surah_name': surahName,
    'arabic_text': arabicText,
    'translation': translation,
    'global_number': globalNumber,
    'saved_at': savedAt.toIso8601String(),
  };

  @override
  bool operator ==(Object other) =>
      other is FavoriteModel && other.surahId == surahId && other.ayahNumber == ayahNumber;

  @override
  int get hashCode => Object.hash(surahId, ayahNumber);
}
