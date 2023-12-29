import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:logger/logger.dart';

import 'auth_static.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  var logger = Logger(
    printer: PrettyPrinter(),
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    signOut();
  }

  User? _user;
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('¡Bienvenidos!'),
      ),
      body: _user != null ? _userInfo() : _googleSigInButton(),
    );
  }

  Widget _googleSigInButton() {
    return Center(
      child: SizedBox(
        height: 50,
        child: SignInButton(
          Buttons.Google,
          text: "Ingresar",
          onPressed: () async {
            try {
              GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
              UserCredential userCredential =
                  await _auth.signInWithProvider(_googleAuthProvider);

              if (userCredential.user != null) {
                AuthData.userCredential = userCredential;
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/home', (route) => false);
                ;
              }
            } catch (error) {
              logger.e(error);
            }
          },
        ),
      ),
    );
  }

  Widget _userInfo() {
    return SizedBox(height: 50, child: Text("Acis"));
  }
}
