import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_2/services/firebase_auth_service.dart';

class AuthController {
  final FirebaseAuthService _authService = FirebaseAuthService();

  Future<String> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return 'Please enter email and password';
    }
    try {
      await _authService.logIn(email: email, password: password);
      return 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'User not found';
      }

      if (e.code == 'wrong-password') {
        return 'Wrong password';
      }

      if (e.code == 'invalid-email') {
        return 'Invalid email';
      }

      return 'Something went wrong';
    }
  }
}
