import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
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
          text: "Sign in",
          onPressed: () async {
            try {
              GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
              UserCredential userCredential =
                  await _auth.signInWithProvider(_googleAuthProvider);

              // Verifica si la autenticación fue exitosa
              if (userCredential.user != null) {
                // Navega a la pantalla de inicio (Home) y reemplaza la pila de rutas actual
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/home');

                ;
              }
            } catch (error) {
              print(error);
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
