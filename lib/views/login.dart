import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/main.dart';
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Login View")),
      body: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            enableSuggestions: false,
            decoration: const InputDecoration(hintText: "Enter email here"),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: "Enter password here"),
          ),
          TextButton(
            onPressed: () async {
              try {
                final userCred = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: _email.text, password: _password.text);
                if (userCred.user?.emailVerified ?? false) {
                  devtools.log("Email Verified");
                  navigator.pushNamedAndRemoveUntil(
                      notesRoute, (route) => false);
                } else {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => const EmailVerificationView()));
                }

                devtools.log(userCred.toString());
              } on FirebaseException catch (error) {
                devtools.log(error.runtimeType.toString());
                devtools.log(error.toString());
              }
            },
            child: const Text("Login"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text("Register Now!"),
          ),
        ],
      ),
    );
  }
}
