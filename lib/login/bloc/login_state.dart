import 'package:equatable/equatable.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState({
    this.username,
    this.password,
    this.apiLoadingState = ApiLoadingState.initial,
  });

  final String? username;
  final String? password;

  final ApiLoadingState apiLoadingState;

  AuthenticationState copyWith({
    String? username,
    String? password,
    ApiLoadingState? apiLoadingState,
  }) {
    return AuthenticationState(
      username: username ?? this.username,
      password: password ?? this.password,
      apiLoadingState: apiLoadingState ?? this.apiLoadingState,
    );
  }

  @override
  List<Object?> get props => [username, password, apiLoadingState];
}

enum ApiLoadingState {
  initial,
  loading,
  loaded,
  error,
}
