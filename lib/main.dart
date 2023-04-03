import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/constants.dart';
import 'package:pokemon_app/login/bloc/login_bloc.dart';
import 'package:pokemon_app/login/repository/authentication_repository.dart';
import 'package:pokemon_app/login/signin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home/bloc/home_bloc.dart';
import 'home/home_screen.dart';
import 'home/repository/pokemon_repository.dart';
import 'network/http.dart';
import 'package:http/http.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationBloc(
        authenticationRepository:
            AuthenticationRepository(FirebaseAuth.instance),
      ),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: FutureBuilder<bool?>(
            future: _isHome(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!) {
                  return BlocProvider(
                    create: (context) => HomeBloc(
                        PokemonRepository(HttpService(client: Client()))),
                    child: const HomeScreen(),
                  );
                } else {
                  return const LoginScreen();
                }
              } else {
                 return const LoginScreen();
              }
            },
          )),
    );
  }

  Future<bool?> _isHome() async {
    final pref = await SharedPreferences.getInstance();

    return pref.getBool(LOGIN_KEY);
  }
}
