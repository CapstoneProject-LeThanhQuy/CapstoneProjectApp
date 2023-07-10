abstract class StorageService {
  Future<void> setToken(String token);
  Future<String> getToken();
  Future<void> removeToken();

  Future<void> setTarget(String target, int userId);
  Future<String> getTarget(int userId);
  Future<void> removeTarget();

  Future<void> setCurrentCourse(String course);
  Future<String> getCurrentCourse();

  Future<void> setMyWord(List<String> myWords);
  Future<List<String>> getMyWord();
  Future<void> removeMyWord();

  Future<void> setMyBestScore(int bestScore);
  Future<int> getMyBestScore();
}
