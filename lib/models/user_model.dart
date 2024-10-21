// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends Equatable {
  final String name;
  final String email;
  final String userID;
  final String profilePicsUrl;
  final int loginStreak;
  final int points;
  final String? fcmToken;
  final DateTime? lastUsage;

  const UserModel({
    required this.name,
    required this.email,
    required this.userID,
    required this.profilePicsUrl,
    required this.loginStreak,
    required this.points,
    this.fcmToken,
    required this.lastUsage,
  });

  factory UserModel.fromDoc(DocumentSnapshot userDoc) {
    final userData = userDoc.data() as Map<String, dynamic>?;

    return UserModel(
      userID: userDoc.id,
      name: userData!['name'],
      email: userData['email'],
      profilePicsUrl: userData['profilePicsUrl'],
      loginStreak: userData['loginStreak'],
      points: userData['points'],
      fcmToken: userData['fcmToken'],
      lastUsage: (userData['lastUsage'] as Timestamp?)?.toDate(),
    );
  }

  // Create a UserModel object from Firebase User
  factory UserModel.fromFirebaseUser(User user, String? fcmToken) {
    return UserModel(
      userID: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      profilePicsUrl: user.photoURL ?? '',
      loginStreak: 1,
      points: 0,
      fcmToken: fcmToken,
      lastUsage: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        name,
        email,
        userID,
        profilePicsUrl,
        loginStreak,
        points,
        fcmToken,
        lastUsage
      ];

  @override
  bool get stringify => true;
}
