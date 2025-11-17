import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/course.dart';
import '../services/api_service.dart';

// Fetch all chapters from API and convert to courses
final courseListProvider = FutureProvider<List<Course>>((ref) async {
  try {
    final chapters = await ApiService.getChapters();
    return chapters.map((json) => Course.fromChapterJson(json)).toList();
  } catch (e) {
    // If API fails, generate all 18 chapters as fallback
    return _generateAll18Chapters();
  }
});

// Generate all 18 Bhagavad Gita chapters as fallback
List<Course> _generateAll18Chapters() {
  final chapterNames = [
    'Arjuna Vishada Yoga',
    'Sankhya Yoga',
    'Karma Yoga',
    'Jnana Karma Sanyasa Yoga',
    'Karma Sanyasa Yoga',
    'Atma Samyama Yoga',
    'Jnana Vijnana Yoga',
    'Aksara Brahma Yoga',
    'Raja Vidya Raja Guhya Yoga',
    'Vibhuti Yoga',
    'Vishvarupa Darshana Yoga',
    'Bhakti Yoga',
    'Ksetra Ksetrajna Vibhaga Yoga',
    'Gunatraya Vibhaga Yoga',
    'Purushottama Yoga',
    'Daivasura Sampad Vibhaga Yoga',
    'Shraddhatraya Vibhaga Yoga',
    'Moksha Sanyasa Yoga',
  ];

  final translations = [
    'The Yoga of Arjuna\'s Dejection',
    'The Yoga of Knowledge',
    'The Yoga of Action',
    'The Yoga of Knowledge and Action',
    'The Yoga of Renunciation of Action',
    'The Yoga of Meditation',
    'The Yoga of Knowledge and Wisdom',
    'The Yoga of the Imperishable Brahman',
    'The Yoga of Royal Knowledge and Royal Secret',
    'The Yoga of Divine Glories',
    'The Yoga of the Vision of the Universal Form',
    'The Yoga of Devotion',
    'The Yoga of the Field and the Knower of the Field',
    'The Yoga of the Three Gunas',
    'The Yoga of the Supreme Person',
    'The Yoga of the Divine and Demoniac Estates',
    'The Yoga of the Three Types of Faith',
    'The Yoga of Liberation through Renunciation',
  ];

  final verseCounts = [47, 72, 43, 42, 29, 47, 30, 28, 34, 42, 55, 20, 35, 27, 20, 24, 28, 78];

  return List.generate(18, (index) {
    final chapterNum = index + 1;
    
    // Create a mock JSON object to use the existing fromChapterJson method
    final mockJson = {
      'chapter_number': chapterNum,
      'name': 'Chapter $chapterNum: ${chapterNames[index]}',
      'translation': translations[index],
      'verses_count': verseCounts[index],
      'summary': '',
    };
    
    return Course.fromChapterJson(mockJson);
  });
}

final courseByIdProvider = Provider.family<Course?, String>((ref, courseId) {
  final coursesAsync = ref.watch(courseListProvider);
  return coursesAsync.when(
    data: (courses) {
      for (final course in courses) {
        if (course.id == courseId) {
          return course;
        }
      }
      return null;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

final featuredCourseProvider = Provider<Course?>((ref) {
  final coursesAsync = ref.watch(courseListProvider);
  return coursesAsync.when(
    data: (courses) => courses.isEmpty ? null : courses.first,
    loading: () => null,
    error: (_, __) => null,
  );
});

// Fallback courses if API is unavailable
