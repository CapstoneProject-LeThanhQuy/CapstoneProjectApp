class GetAllCourseRequest {
  bool? isMine;
  int? getCount;
  int? pageNo;

  GetAllCourseRequest(this.isMine, this.getCount, this.pageNo);

  Map<String, dynamic> toJson() {
    return {
      'is_mine': isMine,
      'get_count': getCount,
      'page_no': pageNo,
    };
  }
}
