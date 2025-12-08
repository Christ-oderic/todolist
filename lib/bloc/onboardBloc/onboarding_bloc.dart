import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final PageController controller = PageController();

  OnboardingBloc() : super(OnboardingState(currentPage: 0)) {
    on<PageChangedEvent>((event, emit) {
      emit(state.copyWith(currentPage: event.page));
    });

    on<LastPageEvent>((event, emit) {
      // Rien à émettre, on laisse l'UI gérer la navigation
    });
  }

  @override
  Future<void> close() {
    controller.dispose();
    return super.close();
  }
}
