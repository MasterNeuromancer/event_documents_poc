import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class User {
  final String? userId;
  final String? userDisplayName;
  final String? email;
  final String? avatarUrl;

  const User({
    this.userId,
    this.userDisplayName,
    this.email,
    this.avatarUrl,
  });

  @override
  String toString() {
    return 'User(userId: $userId, userDisplayName: $userDisplayName, email: $email, avatarUrl: $avatarUrl)';
  }

  User copyWith({
    String? userId,
    String? userDisplayName,
    String? email,
    String? avatarUrl,
  }) {
    return User(
      userId: userId ?? this.userId,
      userDisplayName: userDisplayName ?? this.userDisplayName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final dynamic data = snapshot.data();
    return User(
      userId: data?['userId'],
      userDisplayName: data?['userDisplayName'],
      email: data?['email'],
      avatarUrl: data?['avatarUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      if (userId != null) 'userId': userId,
      if (userDisplayName != null) 'userDisplayName': userDisplayName,
      if (email != null) 'email': email,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
    };
  }

  factory User.empty() => const User(
        userId: '',
        userDisplayName: '',
        email: '',
        avatarUrl: '',
      );
}
