class JWTZendesk {
  String? jwt;

  JWTZendesk({this.jwt});

  JWTZendesk.fromJson(Map<String, dynamic> json) {
    jwt = json['jwt'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['jwt'] = jwt.toString();
    return data;
  }
}
