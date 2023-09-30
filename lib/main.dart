import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/views/email_verify.dart';
import 'package:mynotes/views/login.dart';
import 'package:mynotes/views/register.dart';
import 'dart:developer' as devtools show log;

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
                  return const NotesView();
                } else {
                  return const EmailVerificationView();
                }
              } else {
                return const LoginView();
              }

            default:
              return const CircularProgressIndicator();
          }
        });
  }
}

enum MenuActions { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          PopupMenuButton(
            onSelected: (value) async {
              // devtools.log(value.toString());
              switch (value) {
                case MenuActions.logout:
                  final navigator = Navigator.of(
                      context); // use the context before the await call.
                  final showLogout = await showDialogBox(context);
                  if (showLogout) {
                    await FirebaseAuth.instance.signOut();
                    navigator.pushNamedAndRemoveUntil("/login/", (_) => false);
                  }
                  devtools.log(showLogout.toString());
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  value: MenuActions.logout,
                  child: Text("Logout"),
                ),
              ];
            },
          )
        ],
      ),
      body: const Text("Notes List"),
    );
  }
}

Future<bool> showDialogBox(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Sign Out"),
      content: const Text("Are you sure you want to sign out?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text("Not yet!"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text("Sign Out"),
        ),
      ],
    ),
  ).then((value) =>
      value ??
      false); // once the future is completed take the result and pass it to the callback function.
}
