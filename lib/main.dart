import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/views/email_verify.dart';
import 'package:mynotes/views/login.dart';
import 'package:mynotes/views/register.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.blue),
    home: const HomePage(),
    routes: {
      "/login/": (context) => const LoginView(),
      "/register/": (context) => const RegisterView()
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final userCred = FirebaseAuth.instance.currentUser;
              if (userCred != null) {
                if (userCred.emailVerified) {
                  print("Email is verified");
                } else {
                  return const EmailVerificationView();
                }
              } else {
                return const LoginView();
              }
              // return const Text("Done");
              //   print("User is Verified");
              //   return const Text("Done");
              // } else {
              //   print("User is not verified");
              //   return const EmailVerificationView();
              // }
              return const LoginView();

            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
