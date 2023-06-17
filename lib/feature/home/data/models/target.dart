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
    );
  }
}
