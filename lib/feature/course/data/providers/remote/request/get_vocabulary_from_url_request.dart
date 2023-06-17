class GetVocabularyFromUrlRequest {
  String? url;
  String? text;
  int? maxWords;
  bool? isExactSearch;

  GetVocabularyFromUrlRequest(this.url, this.text, this.maxWords, this.isExactSearch);

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'text': text,
      'max_words': maxWords,
      'is_exact_search': isExactSearch,
    };
  }
}
