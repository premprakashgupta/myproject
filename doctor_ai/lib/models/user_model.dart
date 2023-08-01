import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String username;
  final String id;
  final String email;
  final String role;
  final Timestamp timeStamp;
  UserModel({
    required this.username,
    required this.id,
    required this.email,
    required this.role,
    required this.timeStamp,
  });

  UserModel copyWith({
    String? username,
    String? id,
    String? email,
    String? role,
    Timestamp? timeStamp,
  }) {
    return UserModel(
      username: username ?? this.username,
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'id': id,
      'email': email,
      'role': role,
      'timeStamp': timeStamp,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] as String,
      id: map['id'] as String,
      email: map['email'] as String,
      role: map['role'] as String,
      timeStamp: map['timeStamp'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(username: $username, id: $id, email: $email, role: $role, timeStamp: $timeStamp)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.username == username &&
        other.id == id &&
        other.email == email &&
        other.role == role &&
        other.timeStamp == timeStamp;
  }

  @override
  int get hashCode {
    return username.hashCode ^
        id.hashCode ^
        email.hashCode ^
        role.hashCode ^
        timeStamp.hashCode;
  }
}
