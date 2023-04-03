import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pokemon_app/home/repository/pokemon_repository.dart';
import 'package:pokemon_app/login/bloc/login_bloc.dart';
import 'package:pokemon_app/login/signup_screen.dart';
import 'package:pokemon_app/network/http.dart';

import '../home/bloc/home_bloc.dart';
import '../home/home_screen.dart';
import 'bloc/login_event.dart';

import 'bloc/login_state.dart';
import 'dart:convert';

import 'package:http/http.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state.apiLoadingState == ApiLoadingState.error) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Something went wrong. Please try again.')));
          }

          if (state.apiLoadingState == ApiLoadingState.loaded) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>  BlocProvider(
                      create: (context) => HomeBloc(PokemonRepository(HttpService(client: Client()))),
                      child: const HomeScreen(),
                    )));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FormBuilder(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        FormBuilderTextField(
                            name: 'email',
                            decoration:
                                const InputDecoration(labelText: 'Email'),
                            validator: (email) {
                              // email regex
                              final emailRegex = RegExp(
                                  r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

                              // validate email
                              if (email == null || email.isEmpty) {
                                return 'Email is required';
                              } else if (!emailRegex.hasMatch(email)) {
                                return 'Email is invalid';
                              } else {
                                return null;
                              }
                            }),
                        FormBuilderTextField(
                          name: 'password',
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (password) {
                            if (password == null || password.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (state.apiLoadingState == ApiLoadingState.loading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.saveAndValidate()) {
                          // Perform login logic
                          final formData = _formKey.currentState!.value;
                          final email = formData['email'] as String;
                          final password = formData['password'] as String;

                          BlocProvider.of<AuthenticationBloc>(context).add(
                            SignInCredentialsEvent(
                              username: email,
                              password: password,
                            ),
                          );
                        }
                      },
                      child: const Text('Login'),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                    value: context.read<AuthenticationBloc>(),
                                    child: const SignupScreen(),
                                  )));
                    },
                    child: const Text('Don\'t have an account? Sign up'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
