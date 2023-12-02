// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String id;
  String userName;
  String displayName;
  String accessToken;
  String refreshToken;
  String title;
  String department;

  UserModel({
    required this.id,
    required this.userName,
    required this.displayName,
    required this.accessToken,
    required this.refreshToken,
    required this.title,
    required this.department,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'displayName': displayName,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'title': title,
      'department': department,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      userName: map['userName'] ?? '',
      displayName: map['displayName'] ?? '',
      accessToken: map['access_token'] ?? '',
      refreshToken: map['refresh_token'] ?? '',
      title: map['title'] ?? '',
      department: map['department'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
