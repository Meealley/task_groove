// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final Color color;

  const ThemeState({required this.color});

  factory ThemeState.initial() {
    return const ThemeState(
      color: AppColors.backgroundDark,
    );
  }

  @override
  List<Object> get props => [color];

  @override
  bool get stringify => true;

  ThemeState copyWith({
    Color? color,
  }) {
    return ThemeState(
      color: color ?? this.color,
    );
  }
}
