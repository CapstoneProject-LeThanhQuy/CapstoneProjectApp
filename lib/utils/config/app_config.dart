import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:easy_english/feature/authentication/data/models/account_model.dart';
import 'package:easy_english/feature/authentication/data/models/token_model.dart';
import 'package:easy_english/feature/course/data/models/course.dart';
import 'package:easy_english/feature/course/data/models/course_level.dart';
import 'package:easy_english/feature/home/data/models/target.dart';

class AppConfig {
  static const baseUrl = 'http://159.223.52.44:5000/';
  static const keyToken = 'Authentication Token';
  static TokenModel tokenInfo = TokenModel();
  static AccountModel accountInfo = AccountModel();
  static Course currentCourse = Course(0, 0, '', '', '', 0, 0, 0, 0, 0);
  static CourseLevel currentCourseLevel = CourseLevel(0, 0, '', 0, 0, 0);
  static bool isReview = false;
  static bool isSpeakLearn = false;
  static List<String> listTypeWord = <String>[
    'Noun',
    'Pronoun',
    'Adjective',
    'Verb',
    'Adverb',
    'Determiner',
    'Preposition',
    'Conjunction',
    'Interjection',
    'Auxiliary',
  ];
  static List<String> listMaxWords = <String>[
    '5',
    '10',
    '20',
    '50',
    '100',
  ];

  static Target currentTarget = Target(
    record: 0,
    consecutiveDays: 0,
    learnedWords: 0,
    newWords: 0,
    time: 0,
    currentDate: DateTime.now().toUtc().millisecondsSinceEpoch,
    targetWord: 20,
    listNewWords: [],
    listReviewedWords: [],
    listReviewedWordsTime: [],
    listNewWordsTime: [],
  );

  // Game

  static RxString currentCharacter = ''.obs;
}
