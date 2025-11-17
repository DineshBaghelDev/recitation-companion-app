class Verse {
  const Verse({
    required this.chapter,
    required this.verse,
    required this.slok,
    required this.transliteration,
    required this.hindiTranslation,
    required this.englishTranslation,
    this.mastery = 0.0,
  });

  final int chapter;
  final int verse;
  final String slok;
  final String transliteration;
  final String hindiTranslation;
  final String englishTranslation;
  final double mastery;

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      chapter: json['chapter'] as int,
      verse: json['verse'] as int,
      slok: json['slok'] as String,
      transliteration: json['transliteration'] as String,
      hindiTranslation: json['hindi_translation'] as String,
      englishTranslation: json['english_translation'] as String,
      mastery: json['mastery'] as double? ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapter': chapter,
      'verse': verse,
      'slok': slok,
      'transliteration': transliteration,
      'hindi_translation': hindiTranslation,
      'english_translation': englishTranslation,
      'mastery': mastery,
    };
  }

  String get title => 'श्लोक $verse, अध्याय $chapter';
  String get id => '$chapter.$verse';
}
