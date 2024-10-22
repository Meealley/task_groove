// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String name;
  final String userID;
  final String email;
  final int loginStreak;
  final String profileImageUrl;
  final int points;
  final bool isLoading;
  final String? errorMessage;

  const ProfileState(
      {required this.name,
      required this.userID,
      required this.loginStreak,
      required this.points,
      required this.isLoading,
      required this.errorMessage,
      required this.email,
      required this.profileImageUrl});

  factory ProfileState.initial() {
    return const ProfileState(
      userID: "",
      name: "",
      loginStreak: 1,
      points: 0,
      isLoading: false,
      errorMessage: "",
      profileImageUrl: "",
      email: "",
    );
  }

  @override
  List<Object?> get props {
    return [
      userID,
      name,
      loginStreak,
      points,
      isLoading,
      email,
      errorMessage,
      profileImageUrl
    ];
  }

  @override
  bool get stringify => true;

  ProfileState copyWith({
    String? userID,
    String? name,
    int? loginStreak,
    int? points,
    bool? isLoading,
    String? errorMessage,
    String? profileImageUrl,
    String? email,
  }) {
    return ProfileState(
      userID: userID ?? this.userID,
      name: name ?? this.name,
      email: email ?? this.email,
      loginStreak: loginStreak ?? this.loginStreak,
      points: points ?? this.points,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
