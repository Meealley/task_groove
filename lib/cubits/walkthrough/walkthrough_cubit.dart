import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'walkthrough_state.dart';

class WalkthroughCubit extends Cubit<WalkthroughState> {
  WalkthroughCubit() : super(WalkthroughState.initial());

  Future<void> initializeWalkthrough() async {
    final prefs = await SharedPreferences.getInstance();
    final isCompleted = prefs.getBool('walkthrough_completed') ?? false;

    if (!isCompleted) {
      emit(state.copyWith(isVisible: true));
    }
  }

  void nextStep() {
    if (state.currentStep < 2) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    } else {
      completeWalkthrough();
    }
  }

  void skipWalkthrough() {
    completeWalkthrough();
  }

  Future<void> completeWalkthrough() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('walkthrough_completed', true);
    emit(state.copyWith(isVisible: false, isCompleted: true));
  }
}
