import 'package:flutter/material.dart';

enum CourseStepStatus { completed, current, locked }

class CourseArtwork {
  const CourseArtwork({
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
  });

  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;

  LinearGradient toGradient() => LinearGradient(
        colors: [primaryColor, secondaryColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}

class CourseStep {
  const CourseStep({
    required this.id,
    required this.label,
    required this.title,
    required this.status,
    this.description,
    this.verseId,
  });

  final String id;
  final String label;
  final String title;
  final CourseStepStatus status;
  final String? description;
  final String? verseId;

  bool get isLocked => status == CourseStepStatus.locked;
  bool get isCurrent => status == CourseStepStatus.current;
  bool get isCompleted => status == CourseStepStatus.completed;
}

class Course {
  const Course({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.verseCount,
    required this.progress,
    required this.artwork,
    required this.steps,
    this.summary,
    this.chapterNumber,
  });

  final String id;
  final String title;
  final String subtitle;
  final int verseCount;
  final double progress;
  final CourseArtwork artwork;
  final List<CourseStep> steps;
  final String? summary;
  final int? chapterNumber;

  factory Course.fromChapterJson(Map<String, dynamic> json, {double progress = 0.0}) {
    final chapterNum = json['chapter_number'] as int;
    return Course(
      id: 'chapter_$chapterNum',
      title: json['name'] as String,
      subtitle: json['translation'] as String,
      verseCount: json['verses_count'] as int,
      progress: progress,
      artwork: _getArtworkForChapter(chapterNum),
      steps: _generateStepsForChapter(chapterNum, json['verses_count'] as int),
      summary: json['summary'] as String?,
      chapterNumber: chapterNum,
    );
  }

  static CourseArtwork _getArtworkForChapter(int chapter) {
    // Generate different colors for each chapter
    final colors = [
      [const Color(0xFF607AFB), const Color(0xFF8E9FF8)],
      [const Color(0xFFFF6B9D), const Color(0xFFFFA8C5)],
      [const Color(0xFF4CAF50), const Color(0xFF81C784)],
      [const Color(0xFFFF9800), const Color(0xFFFFB74D)],
      [const Color(0xFF9C27B0), const Color(0xFFBA68C8)],
      [const Color(0xFF00BCD4), const Color(0xFF4DD0E1)],
    ];
    final colorPair = colors[(chapter - 1) % colors.length];
    return CourseArtwork(
      icon: Icons.book,
      primaryColor: colorPair[0],
      secondaryColor: colorPair[1],
    );
  }

  static List<CourseStep> _generateStepsForChapter(int chapter, int verseCount) {
    // Generate steps for first 5 verses as sample
    final stepCount = verseCount < 5 ? verseCount : 5;
    return List.generate(stepCount, (index) {
      final verseNum = index + 1;
      return CourseStep(
        id: '$chapter.$verseNum',
        label: 'Verse $verseNum',
        title: 'श्लोक $verseNum',
        status: index == 0 ? CourseStepStatus.current : CourseStepStatus.locked,
        verseId: '$chapter.$verseNum',
      );
    });
  }

  CourseStep get currentStep =>
      steps.firstWhere((step) => step.isCurrent, orElse: () => steps.first);

  double get percentComplete => progress.clamp(0, 1);
  String get displayVerseCount => 'Verse Count: $verseCount';
}
