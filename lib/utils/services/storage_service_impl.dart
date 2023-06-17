import 'package:easy_english/utils/config/app_config.dart';
import 'package:easy_english/utils/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageServiceImpl implements StorageService {
  final _sharedPreferences = SharedPreferences.getInstance();
  final String targetKey = "TARGET_KEY";
  final String currentCourseKey = "CURRENT_COURSE_KEY";

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
  Future<String> getTarget() async {
    return (await _sharedPreferences).getString(targetKey) ?? "";
  }

  @override
  Future<void> setTarget(String target) async {
    (await _sharedPreferences).setString(targetKey, target);
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
}
