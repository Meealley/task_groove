// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:equatable/equatable.dart';

part of 'walkthrough_cubit.dart';

class WalkthroughState extends Equatable {
  final bool isVisible;
  final int currentStep;
  final bool isCompleted;

  const WalkthroughState(
      {required this.isVisible,
      required this.currentStep,
      required this.isCompleted});

  factory WalkthroughState.initial() {
    return const WalkthroughState(
        currentStep: 0, isVisible: false, isCompleted: false);
  }

  @override
  List<Object> get props => [isVisible, currentStep, isCompleted];

  @override
  bool get stringify => true;

  WalkthroughState copyWith({
    bool? isVisible,
    int? currentStep,
    bool? isCompleted,
  }) {
    return WalkthroughState(
      isVisible: isVisible ?? this.isVisible,
      currentStep: currentStep ?? this.currentStep,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
