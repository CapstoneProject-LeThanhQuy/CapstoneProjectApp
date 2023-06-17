class LoginRequest {
  String? phoneNumber;
  String? email;
  String? password;

  LoginRequest(this.password, {this.email, this.phoneNumber});

  Map<String, dynamic> toJson() {
    if (phoneNumber != null) {
      return {
        'phone_number': phoneNumber,
        'password': password,
      };
    } else if (email != null) {
      return {
        'email': email,
        'password': password,
      };
    }
    return {
      'password': password,
    };
  }
}
