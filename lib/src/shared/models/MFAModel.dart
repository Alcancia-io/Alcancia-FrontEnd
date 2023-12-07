class MFAInputModel {
  const MFAInputModel(
      {required this.verificationCode,
        required this.email,
        required this.token,
        required this.type,
        required this.deviceToken}
      );

  final String verificationCode;
  final String email;
  final String token;
  final String type;
  final String deviceToken;
}

class MFAResponseModel {
  const MFAResponseModel({required this.accessToken, required this.refreshToken, required this.userName, required this.userEmail});

  factory MFAResponseModel.fromMap(Map<String, dynamic> map) {
    return MFAResponseModel(
      accessToken: map['accessToken'] as String,
      refreshToken: map['refreshToken'] as String,
      userName: map['user']['name'] as String,
      userEmail: map['user']['email'] as String,
    );
  }

  final String accessToken;
  final String refreshToken;
  final String userName;
  final String userEmail;
}
