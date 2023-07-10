class RegisterRequest {
  String? phoneNumber;
  String? email;
  bool? gender;
  String? username;
  String? password;
  String? verificationId;

  RegisterRequest(
    this.phoneNumber,
    this.email,
    this.gender,
    this.username,
    this.password, {
    this.verificationId,
  });

  Map<String, dynamic> toJson() {
    if (phoneNumber != null) {
      return {
        'phone_number': phoneNumber,
        'gender': gender,
        'username': username,
        'password': password,
      };
    }
    return {
      'email': email,
      'gender': gender,
      'username': username,
      'password': password,
    };
  }
}
