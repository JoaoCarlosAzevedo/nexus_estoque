import 'dart:convert';

class User {
  String id;
  String userName;
  String displayName;
  String accessToken;
  String refreshToken;

  User({
    required this.id,
    required this.userName,
    required this.displayName,
    required this.accessToken,
    required this.refreshToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'displayName': displayName,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      userName: map['userName'] ?? '',
      displayName: map['displayName'] ?? '',
      accessToken: map['access_token'] ?? '',
      refreshToken: map['refresh_token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
