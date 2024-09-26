// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends Equatable {
  final String name;
  final String email;
  final String userID;
  final String profilePicsUrl;

  const UserModel(
      {required this.name,
      required this.email,
      required this.userID,
      required this.profilePicsUrl});

  factory UserModel.fromDoc(DocumentSnapshot userDoc) {
    final userData = userDoc.data() as Map<String, dynamic>?;

    return UserModel(
      userID: userDoc.id,
      name: userData!['name'],
      email: userData['email'],
      profilePicsUrl: userData['profilePicsUrl'],
    );
  }

  // Create a UserModel object from Firebase User
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      userID: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      profilePicsUrl: user.photoURL ?? '',
    );
  }

  @override
  List<Object> get props => [name, email, userID, profilePicsUrl];

  @override
  bool get stringify => true;
}
