import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  AuthenticationRepository(this.auth);
  FirebaseAuth auth;

  //  firebase login with username and password
  Future<UserCredential> firebaseLogin(
      String emailAddress, String password) async {
    final credential = await auth.signInWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );

    return credential;
  }

  Future<UserCredential> signup(String emailAddress, String password) async {
    final credential = await auth.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );

    return credential;
  }
}
