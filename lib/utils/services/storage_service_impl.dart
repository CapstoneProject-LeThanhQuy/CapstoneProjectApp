import 'package:easy_english/utils/config/app_config.dart';
import 'package:easy_english/utils/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageServiceImpl implements StorageService {
  final _sharedPreferences = SharedPreferences.getInstance();
  final String targetKey = "TARGET_KEY";
  final String currentCourseKey = "CURRENT_COURSE_KEY";
  final String myWordsKey = "MY_WORDS_KEY";
  final String myBestScore = "MY_BEST_SCORE_KEY";

  @override
  Future<void> setToken(String token) async {
    (await _sharedPreferences).setString(AppConfig.keyToken, token);
  }

  @override
  Future<String> getToken() async {
    return (await _sharedPreferences).getString(AppConfig.keyToken) ?? "";
  }

  @override
  Future<void> removeToken() async {
    (await _sharedPreferences).remove(AppConfig.keyToken);
  }

  @override
  Future<String> getTarget(int userId) async {
    return (await _sharedPreferences).getString('$targetKey-$userId') ?? "";
  }

  @override
  Future<void> setTarget(String target, int userId) async {
    (await _sharedPreferences).setString('$targetKey-$userId', target);
  }

  @override
  Future<void> removeTarget() async {
    (await _sharedPreferences).remove(targetKey);
  }

  @override
  Future<String> getCurrentCourse() async {
    return (await _sharedPreferences).getString(currentCourseKey) ?? "";
  }

  @override
  Future<void> setCurrentCourse(String course) async {
    (await _sharedPreferences).setString(currentCourseKey, course);
  }

  @override
  Future<void> setMyWord(List<String> myWords, int userId) async {
    (await _sharedPreferences).setStringList('$myWordsKey-$userId', myWords);
  }

  @override
  Future<List<String>> getMyWord(int userId) async {
    return (await _sharedPreferences).getStringList('$myWordsKey-$userId') ?? [];
  }

  @override
  Future<void> removeMyWord(int userId) async {
    (await _sharedPreferences).remove('$myWordsKey-$userId');
  }

  @override
  Future<int> getMyBestScore() async {
    return (await _sharedPreferences).getInt(myBestScore) ?? 0;
  }

  @override
  Future<void> setMyBestScore(int bestScore) async {
    (await _sharedPreferences).setInt(myBestScore, bestScore);
  }
}
