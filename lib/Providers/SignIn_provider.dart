import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/material.dart';

import '../Screens/Dashboard.dart';

class SignInViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  String? errorMessage;

  // Sign in with email and password
  Future<void> signInWithEmail(
      String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pop(context, "loggedIn");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(),
        ),
      );
    } catch (error) {
      errorMessage = error.toString();
      notifyListeners();
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      Navigator.pop(context, "loggedIn");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(),
        ),
      );
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Sign in with Facebook
  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      final loginResult = await _facebookAuth.login();

      if (loginResult.status == LoginStatus.success) {
        final credential = FacebookAuthProvider.credential(
            loginResult.accessToken!.tokenString);
        await _auth.signInWithCredential(credential);
        Navigator.pop(context, "loggedIn");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(),
          ),
        );
      }
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> signUpWithEmail(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      errorMessage = null; // Reset error message on success
    } catch (e) {
      errorMessage = e.toString();
    }
    notifyListeners(); // Notify listeners about the state change
  }
}
