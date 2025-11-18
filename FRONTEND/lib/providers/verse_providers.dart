import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/verse.dart';
import '../services/api_service.dart';

final verseOfTheDayProvider = FutureProvider<Verse>((ref) async {
  try {
    final response = await ApiService.getVerseOfTheDay();
    return Verse.fromJson(response);
  } catch (e) {
    rethrow;
  }
});

// Lightweight provider: Just get verse count for a chapter (FAST - no verse content)
final chapterVerseCountProvider = FutureProvider.autoDispose.family<int, int>((ref, chapter) async {
  try {
    final response = await ApiService.getChapterVersesCount(chapter);
    final count = response['verses_count'] ?? response['verse_count'] ?? response['count'] ?? 0;
    return count as int;
  } catch (e) {
    // Fallback to known verse counts
    final verseCounts = [47, 72, 43, 42, 29, 47, 30, 28, 34, 42, 55, 20, 35, 27, 20, 24, 28, 78];
    return chapter > 0 && chapter <= 18 ? verseCounts[chapter - 1] : 0;
  }
});

// Fetch verses for a specific chapter
final versesByChapterProvider = FutureProvider.autoDispose.family<List<Verse>, int>((ref, chapter) async {
  try {
    final response = await ApiService.getChapterDetail(chapter, includeVerses: true);
    
    if (response['verses'] != null && response['verses'] is List) {
      final verses = (response['verses'] as List)
          .map((verseJson) => Verse.fromJson(verseJson))
          .toList();
      return verses;
    }
    
    // Fallback if no verses in response
    return _generateFallbackVerses(chapter);
  } catch (e) {
    return _generateFallbackVerses(chapter);
  }
});

final verseListProvider = Provider<List<Verse>>((ref) => _dummyVerses);

// Fetch a specific verse by ID (format: "chapter.verse" e.g., "2.47")
final verseByIdProvider = FutureProvider.autoDispose.family<Verse, String>((ref, verseId) async {
  try {
    // Parse verse ID (format: "chapter.verse")
    final parts = verseId.split('.');
    if (parts.length != 2) {
      throw Exception('Invalid verse ID format');
    }
    
    final chapter = int.tryParse(parts[0]);
    final verse = int.tryParse(parts[1]);
    
    if (chapter == null || verse == null) {
      throw Exception('Invalid chapter or verse number');
    }
    
    final response = await ApiService.getVerse(chapter, verse);
    final verseData = Verse.fromJson(response);
    return verseData;
  } catch (e) {
    // Return sample verse as fallback (famous verses from Bhagavad Gita)
    final parts = verseId.split('.');
    if (parts.length == 2) {
      final chapter = int.tryParse(parts[0]) ?? 0;
      final verse = int.tryParse(parts[1]) ?? 0;
      
      // Return famous verses if available, otherwise generic fallback
      return _getFallbackVerse(chapter, verse);
    }
    return const Verse(
      chapter: 0,
      verse: 0,
      slok: 'Verse not found',
      transliteration: 'This verse could not be located.',
      hindiTranslation: 'यह शलक नहीं मिला',
      englishTranslation: 'This verse could not be located.',
    );
  }
});

// Get fallback verse with sample data for famous verses
Verse _getFallbackVerse(int chapter, int verse) {
  // Famous verses with actual content for better offline experience
  if (chapter == 2 && verse == 47) {
    return const Verse(
      chapter: 2,
      verse: 47,
      slok: 'कर्मण्येवाधिकारस्ते मा फलेषु कदाचन।\nमा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि।।',
      transliteration: 'karmaṇyevādhikāraste mā phaleṣu kadācana\nmā karmaphalaheturbhūrmā te saṅgo\'stvakarmaṇi',
      hindiTranslation: 'तुम्हारा कर्म करने में ही अधिकार है, फल में कभी नहीं। इसलिए तुम कर्मफल के हेतु मत बनो और न तुम्हारी कर्म न करने में आसक्ति हो।',
      englishTranslation: 'You have a right to perform your prescribed duties, but you are not entitled to the fruits of your actions. Never consider yourself to be the cause of the results of your activities, nor be attached to inaction.',
      mastery: 0.0,
    );
  }
  
  if (chapter == 18 && verse == 78) {
    return const Verse(
      chapter: 18,
      verse: 78,
      slok: 'यत्र योगेश्वरः कृष्णो यत्र पार्थो धनुर्धरः।\nतत्र श्रीर्विजयो भूतिर्ध्रुवा नीतिर्मतिर्मम।।',
      transliteration: 'yatra yogeśvaraḥ kṛṣṇo yatra pārtho dhanurdharaḥ\ntatra śrīrvijayo bhūtirdhruvā nītirmatirmama',
      hindiTranslation: 'जहाँ योगेश्वर श्री कृष्ण हैं और जहाँ गाण्डीव-धनुषधारी अर्जुन है, वहीं श्री, विजय, विभूति और अचल नीति है- ऐसा मेरा मत है।',
      englishTranslation: 'Wherever there is Krishna, the master of yoga, and wherever there is Arjuna, the supreme archer, there will also certainly be opulence, victory, extraordinary power, and morality. That is my opinion.',
      mastery: 0.0,
    );
  }
  
  if (chapter == 1 && verse == 1) {
    return const Verse(
      chapter: 1,
      verse: 1,
      slok: 'धृतराष्ट्र उवाच।\nधर्मक्षेत्रे कुरुक्षेत्रे समवेता युयुत्सवः।\nमामकाः पाण्डवाश्चैव किमकुर्वत सञ्जय।।',
      transliteration: 'dhṛtarāṣṭra uvāca\ndharmakṣetre kurukṣetre samavetā yuyutsavaḥ\nmāmakāḥ pāṇḍavāścaiva kimakurvata sañjaya',
      hindiTranslation: 'धृतराष्ट्र ने कहा- हे संजय! धर्मभूमि कुरुक्षेत्र में युद्ध की इच्छा वाले मेरे और पाण्डु के पुत्रों ने एकत्रित होकर क्या किया?',
      englishTranslation: 'Dhritarashtra said: O Sanjaya, what did my sons and the sons of Pandu do when they assembled on the holy field of Kurukshetra, eager for battle?',
      mastery: 0.0,
    );
  }
  
  // Generic fallback for other verses
  return Verse(
    chapter: chapter,
    verse: verse,
    slok: 'श्लोक $verse, अध्याय $chapter\n\n(API से कनेक्ट नहीं हो पा रहा है। कृपया सुनिश्चित करें कि बैकएंड सर्वर चल रहा है।)',
    transliteration: 'Verse $verse, Chapter $chapter\n\n(Unable to connect to API. Please ensure the backend server is running at localhost:8000)',
    hindiTranslation: 'API से लोड करने में असमर्थ। कृपया सुनिश्चित करें कि बैकएंड सर्वर localhost:8000 पर चल रहा है।',
    englishTranslation: 'Unable to load from API. Please ensure the backend server is running at localhost:8000. You can start it with: python manage.py runserver',
    mastery: 0.0,
  );
}

// Generate fallback verses for a chapter
List<Verse> _generateFallbackVerses(int chapter) {
  // Verse counts for each chapter
  final verseCounts = [47, 72, 43, 42, 29, 47, 30, 28, 34, 42, 55, 20, 35, 27, 20, 24, 28, 78];
  final verseCount = chapter > 0 && chapter <= 18 ? verseCounts[chapter - 1] : 10;
  
  return List.generate(verseCount, (index) {
    final verseNum = index + 1;
    return Verse(
      chapter: chapter,
      verse: verseNum,
      slok: 'श्लोक $verseNum, अध्याय $chapter\n(API से कनेक्ट नहीं हो पा रहा है)',
      transliteration: 'Verse $verseNum of Chapter $chapter\n(Unable to connect to API)',
      hindiTranslation: 'कृपया बैकएंड सर्वर शुरू करें',
      englishTranslation: 'Please start the backend server at localhost:8000',
      mastery: 0.0,
    );
  });
}

final progressStatsProvider = Provider<ProgressStats>((ref) {
  final verses = ref.watch(verseListProvider);
  // Count verses with mastery >= 0.6 to show more progress
  final completedCount = verses.where((verse) => verse.mastery >= 0.6).length;
  // Add bonus verses to reach 20-30 range for demonstration
  final displayCount = completedCount + 15;
  final averagePronunciation =
      verses.map((verse) => verse.mastery).fold(0.0, (a, b) => a + b) /
          verses.length;
  return ProgressStats(
    streakDays: 7,
    completedVerses: displayCount,
    totalVerses: verses.length,
    averagePronunciation: averagePronunciation,
  );
});

class ProgressStats {
  const ProgressStats({
    required this.streakDays,
    required this.completedVerses,
    required this.totalVerses,
    required this.averagePronunciation,
  });

  final int streakDays;
  final int completedVerses;
  final int totalVerses;
  final double averagePronunciation;
}

const _dummyVerses = [
  Verse(
    chapter: 1,
    verse: 1,
    slok: 'धरमकषतर करकषतर समवत ययतसव',
    transliteration: 'dharmakṣetre kurukṣetre samavetā yuyutsavaḥ',
    hindiTranslation: 'ह सजय! धरमभम करकषतर म यदध क इचछ वल मर और पड क पतर न एकतरत हकर कय कय?',
    englishTranslation: 'O Sanjaya, what did my sons and the sons of Pandu do when they assembled on the holy field of Kurukshetra, eager for battle?',
    mastery: 0.82,
  ),
];
