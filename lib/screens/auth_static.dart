import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthData {
  static UserCredential? userCredential;

  static void authVerification(BuildContext context) {
    if (userCredential == null) {
      Navigator.pushNamed(context, '/');
    }
  }
}
