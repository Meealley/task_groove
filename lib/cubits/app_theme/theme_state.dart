// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final Color color;
  final int selectedThemeIndex;

  const ThemeState({required this.color, required this.selectedThemeIndex});

  factory ThemeState.initial() {
    return const ThemeState(
      color: AppColors.backgroundDark,
      selectedThemeIndex: 0,
    );
  }

  @override
  List<Object> get props => [color, selectedThemeIndex];

  @override
  bool get stringify => true;

  ThemeState copyWith({
    Color? color,
    int? selectedThemeIndex,
  }) {
    return ThemeState(
      color: color ?? this.color,
      selectedThemeIndex: selectedThemeIndex ?? this.selectedThemeIndex,
    );
  }
}
