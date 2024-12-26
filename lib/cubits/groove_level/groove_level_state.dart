// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:equatable/equatable.dart';

part of 'groove_level_cubit.dart';

class GrooveLevelState extends Equatable {
  final int points;
  final String level;
  final bool isLoading;
  final CustomError? error;

  const GrooveLevelState(
      {required this.points,
      required this.level,
      required this.isLoading,
      this.error});

  factory GrooveLevelState.initial() {
    return const GrooveLevelState(
        isLoading: false, points: 0, level: "Trailblazer", error: null);
  }

  @override
  List<Object?> get props => [points, level, isLoading, error];

  @override
  bool get stringify => true;

  GrooveLevelState copyWith({
    int? points,
    String? level,
    bool? isLoading,
    CustomError? error,
  }) {
    return GrooveLevelState(
      points: points ?? this.points,
      level: level ?? this.level,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
