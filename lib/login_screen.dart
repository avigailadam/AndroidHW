import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_notifier.dart';
import 'random_words.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
          child: Column(children: <Widget>[
        const SizedBox(height: 16.0),
        const Text('Welcome to the Startup Names Generator, please log in!',
            textAlign: TextAlign.center),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
              labelText: 'email', border: UnderlineInputBorder()),
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          controller: _passwordController,
          decoration: const InputDecoration(
              labelText: 'password', border: UnderlineInputBorder()),
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: context.watch<AuthNotifier>().status ==
                  Status.authenticating
              ? null
              : () async {
                  final email = _emailController.text;
                  final password = _passwordController.text;
                  final authRepo = context.read<AuthNotifier>();
                  final result = await authRepo.signIn(email, password);
                  if (result) {
                    if (mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RandomWords()),
                      );
                    }
                  } else {
                    const snackBar = SnackBar(
                      content: Text('There was an error logging into the app'),
                      duration: Duration(seconds: 2),
                    );
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }
                },
          child: context.watch<AuthNotifier>().status == Status.authenticating
              ? const CircularProgressIndicator()
              : const Text('login'),
        ),
        const SizedBox(height: 10.0),
        TextButton(
          onPressed: () async {
            final email = _emailController.text;
            final password = _passwordController.text;
            final authRepo = context.read<AuthNotifier>();
            final result = await authRepo.signUp(email, password);
            if (result) {
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const RandomWords()),
                );
              }
            } else {
              const snackBar = SnackBar(
                content: Text('There was an error signing into the app'),
                duration: Duration(seconds: 2),
              );
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            }
          },
          child: const Text('signup',
              style: TextStyle(decoration: TextDecoration.underline)),
        )
      ])),
    );
  }
}
