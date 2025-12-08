part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PageChangedEvent extends OnboardingEvent {
  final int page;
  PageChangedEvent(this.page);

  @override
  List<Object?> get props => [page];
}

class LastPageEvent extends OnboardingEvent {}
