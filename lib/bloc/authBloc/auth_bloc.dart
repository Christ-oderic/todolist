import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/features/todo/data/datasources/models/user_model.dart';
import 'package:todolist/features/todo/data/repositories/Auth/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthInitial()) {
    on<SignUpWithEmailEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await repository.signUpWithEmail(
          event.email,
          event.password,
        );
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<LogInWithEmailEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await repository.logInWithEmail(
          event.email,
          event.password,
        );
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<SignWithGoogleEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await repository.signInWithGoogle();
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<SignInWithFacebookEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await repository.signInWithFacebook();
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<SignOutEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await repository.signOut();
        emit(AuthLogOutSuccess());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
