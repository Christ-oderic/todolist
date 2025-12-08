part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthSuccess extends AuthState {
  final UserModel user;
  const AuthSuccess(this.user);
  @override
  List<Object> get props => [user];
}

final class AuthLogOutSuccess extends AuthState {
  const AuthLogOutSuccess();
  @override
  List<Object> get props => [];
}

final class AuthFailure extends AuthState {
  final String error;
  const AuthFailure(this.error);
  @override
  List<Object> get props => [error];
}
