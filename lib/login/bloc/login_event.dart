import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class SignInCredentialsEvent extends AuthenticationEvent {
  const SignInCredentialsEvent(
      {required this.username, required this.password});

  final String username;
  final String password;

  @override
  List<Object> get props => [username, password];
}

class SignupCredentialsEvent extends AuthenticationEvent {
  const SignupCredentialsEvent(
      {required this.username, required this.password});

  final String username;
  final String password;

  @override
  List<Object> get props => [username, password];
}
