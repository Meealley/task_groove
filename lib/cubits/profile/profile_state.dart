// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String name;
  final int loginStreak;
  final int points;
  final bool isLoading;
  final String? errorMessage;

  const ProfileState(
      {required this.name,
      required this.loginStreak,
      required this.points,
      required this.isLoading,
      required this.errorMessage});

  factory ProfileState.initial() {
    return const ProfileState(
      name: "",
      loginStreak: 1,
      points: 0,
      isLoading: false,
      errorMessage: "",
    );
  }

  @override
  List<Object?> get props {
    return [
      name,
      loginStreak,
      points,
      isLoading,
      errorMessage,
    ];
  }

  @override
  bool get stringify => true;

  ProfileState copyWith({
    String? name,
    int? loginStreak,
    int? points,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProfileState(
      name: name ?? this.name,
      loginStreak: loginStreak ?? this.loginStreak,
      points: points ?? this.points,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
