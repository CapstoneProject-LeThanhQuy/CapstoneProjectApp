abstract class StorageService {
  Future<void> setToken(String token);
  Future<String> getToken();
  Future<void> removeToken();

  Future<void> setTarget(String target, int userId);
  Future<String> getTarget(int userId);
  Future<void> removeTarget();

  Future<void> setCurrentCourse(String course);
  Future<String> getCurrentCourse();

  Future<void> setMyWord(List<String> myWords, int userId);
  Future<List<String>> getMyWord(int userId);
  Future<void> removeMyWord(int userId);

  Future<void> setMyBestScore(int bestScore);
  Future<int> getMyBestScore();
}
