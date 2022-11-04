import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final loginAction;
  final String? loginError;

  const Login(this.loginAction, this.loginError, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            loginAction();
          },
          child: const Text('Login'),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            loginError != null
                ? 'An Error has occurred. Please try again.'
                : '',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
