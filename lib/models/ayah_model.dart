class AyahModel {
  final int number;
  final int surahId;
  final String arabic;
  final String translation;
  final String? transliteration;
  final String? audioUrl;
  final int globalNumber;

  const AyahModel({
    required this.number,
    required this.surahId,
    required this.arabic,
    required this.translation,
    this.transliteration,
    this.audioUrl,
    required this.globalNumber,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json, {int surahId = 0, int globalStart = 0}) {
    final num = json['number'] as int? ?? json['numberInSurah'] as int? ?? 1;
    return AyahModel(
      number: num,
      surahId: surahId,
      arabic: json['arabic'] as String? ??
          json['text'] as String? ??
          json['arabic_text'] as String? ?? '',
      translation: json['translation'] as String? ??
          json['text_translation'] as String? ??
          json['english'] as String? ?? '',
      transliteration: json['transliteration'] as String?,
      audioUrl: json['audio_url'] as String? ?? json['audio'] as String?,
      globalNumber: json['global_number'] as int? ?? (globalStart + num - 1),
    );
  }

  Map<String, dynamic> toJson() => {
    'number': number,
    'surah_id': surahId,
    'arabic': arabic,
    'translation': translation,
    'transliteration': transliteration,
    'audio_url': audioUrl,
    'global_number': globalNumber,
  };

  AyahModel copyWith({
    int? number,
    int? surahId,
    String? arabic,
    String? translation,
    String? transliteration,
    String? audioUrl,
    int? globalNumber,
  }) {
    return AyahModel(
      number: number ?? this.number,
      surahId: surahId ?? this.surahId,
      arabic: arabic ?? this.arabic,
      translation: translation ?? this.translation,
      transliteration: transliteration ?? this.transliteration,
      audioUrl: audioUrl ?? this.audioUrl,
      globalNumber: globalNumber ?? this.globalNumber,
    );
  }
}
