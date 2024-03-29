class Target {
  int record;
  int consecutiveDays;
  int learnedWords;
  int newWords;
  int time;
  int currentDate;
  int targetWord;
  List<int> listNewWords;
  List<int> listReviewedWords;
  List<int> listReviewedWordsTime;
  List<int> listNewWordsTime;

  Target({
    required this.record,
    required this.consecutiveDays,
    required this.learnedWords,
    required this.newWords,
    required this.time,
    required this.currentDate,
    required this.targetWord,
    required this.listNewWords,
    required this.listReviewedWords,
    required this.listReviewedWordsTime,
    required this.listNewWordsTime,
  });

  Map<String, dynamic> toJson() {
    return {
      '"record"': record,
      '"consecutiveDays"': consecutiveDays,
      '"learnedWords"': learnedWords,
      '"newWords"': newWords,
      '"time"': time,
      '"currentDate"': currentDate,
      '"targetWord"': targetWord,
      '"listNewWords"': listNewWords,
      '"listReviewedWords"': listReviewedWords,
      '"listReviewedWordsTime"': listReviewedWordsTime,
      '"listNewWordsTime"': listNewWordsTime,
    };
  }

  factory Target.fromJson(Map<String, dynamic> json) {
    return Target(
      record: json["record"],
      consecutiveDays: json["consecutiveDays"],
      learnedWords: json["learnedWords"],
      newWords: json["newWords"],
      time: json["time"],
      currentDate: json["currentDate"],
      targetWord: json["targetWord"],
      listNewWords: (json['listNewWords'] as List).map((e) => e as int).toList(),
      listReviewedWords: (json['listReviewedWords'] as List).map((e) => e as int).toList(),
      listReviewedWordsTime: (json['listReviewedWordsTime'] as List).map((e) => e as int).toList(),
      listNewWordsTime: (json['listNewWordsTime'] as List).map((e) => e as int).toList(),
    );
  }
}
