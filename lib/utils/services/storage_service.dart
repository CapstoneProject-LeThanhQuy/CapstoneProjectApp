abstract class StorageService {
  Future<void> setToken(String token);
  Future<String> getToken();
  Future<void> removeToken();

  Future<void> setTarget(String target);
  Future<String> getTarget();
  Future<void> removeTarget();

  Future<void> setCurrentCourse(String course);
  Future<String> getCurrentCourse();
}
