part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class SignUpWithEmailEvent extends AuthEvent {
  final String email;
  final String password;
  const SignUpWithEmailEvent(this.email, this.password);
  @override
  List<Object> get props => [email, password];
}

class LogInWithEmailEvent extends AuthEvent {
  final String email;
  final String password;
  const LogInWithEmailEvent(this.email, this.password);
  @override
  List<Object> get props => [email, password];
}

class SignOutEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}
