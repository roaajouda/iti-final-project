import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_2/core/exceptions/app_exception.dart';
import 'package:flutter_application_2/core/services/firebase_auth_service.dart';
import 'package:flutter_application_2/core/services/hive_service.dart';
import 'package:flutter_application_2/core/services/local_storage_service.dart';

class AuthController {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final LocalStorageService _localStorage = LocalStorageService();

  Future<void> login({required String email, required String password}) async {
    if (email.isEmpty || password.isEmpty) {
      throw AuthException('Please enter email and password');
    }

    try {
      await _authService.logIn(email: email, password: password);

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw AuthException('Something went wrong.');
      }

      final name = user.displayName;

      if (name != null && name.isNotEmpty) {
        await _localStorage.saveUser(name: name);
      }

      await HiveService().openUserBoxes();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
          throw InvalidCredentialsException();

        case 'invalid-email':
          throw AuthException('Invalid email format');

        case 'too-many-requests':
          throw AuthException('Too many attempts. Try again later');

        case 'network-request-failed':
          throw NetworkException();

        default:
          throw AuthException('Something went wrong');
      }
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      throw AuthException('Please fill in all fields');
    }

    if (password != confirmPassword) {
      throw AuthException('Passwords do not match');
    }

    try {
      await _authService.signUp(email: email, password: password);

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw AuthException('Something went wrong.');
      }

      await user.updateDisplayName(name);

      await _localStorage.saveUser(name: name);

      await HiveService().openUserBoxes();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw AuthException('This email is already registered.');

        case 'invalid-email':
          throw AuthException('Invalid email format.');

        case 'weak-password':
          throw AuthException('Password is too weak.');

        case 'network-request-failed':
          throw NetworkException();

        default:
          throw AuthException('Something went wrong.');
      }
    }
  }

  Future<bool> isLoggedIn() async {
    return await _localStorage.isLoggedIn();
  }

  Future<String?> getUserName() async {
    return await _localStorage.getUserName();
  }

  Future<void> logout() async {
    await HiveService().closeUserBoxes();
    await _authService.logOut();
    await _localStorage.clearUser();
  }
}
