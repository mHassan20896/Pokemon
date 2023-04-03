import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/constants.dart';
import 'package:pokemon_app/login/bloc/login_event.dart';
import 'package:pokemon_app/login/repository/authentication_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({required this.authenticationRepository})
      : super(const AuthenticationState()) {
    on<SignInCredentialsEvent>(_signIn);
    on<SignupCredentialsEvent>(_signup);
  }

  final AuthenticationRepository authenticationRepository;

  Future<void> _signIn(
    SignInCredentialsEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(state.copyWith(apiLoadingState: ApiLoadingState.loading));
    try {
      await authenticationRepository.firebaseLogin(
        event.username,
        event.password,
      );
      final pref = await SharedPreferences.getInstance();
      pref.setBool(LOGIN_KEY, true);
      emit(state.copyWith(apiLoadingState: ApiLoadingState.loaded));
    } catch (e) {
      emit(state.copyWith(apiLoadingState: ApiLoadingState.error));
    }
  }

  Future<void> _signup(
    SignupCredentialsEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(state.copyWith(apiLoadingState: ApiLoadingState.loading));
    try {
      await authenticationRepository.signup(
        event.username,
        event.password,
      );
      final pref = await SharedPreferences.getInstance();
      pref.setBool(LOGIN_KEY, true);
      emit(state.copyWith(apiLoadingState: ApiLoadingState.loaded));
    } catch (e) {
      emit(state.copyWith(apiLoadingState: ApiLoadingState.error));
    }
  }
}
