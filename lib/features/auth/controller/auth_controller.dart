import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/exceptions/app_exception.dart';
import '../../../core/services/firebase_auth_service.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/services/hive_service.dart';

class AuthController {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final LocalStorageService _localStorage = LocalStorageService();
  final HiveService _hiveService = HiveService();

  Future<void> login({required String email, required String password}) async {
    try {
      await _authService.logIn(email: email, password: password);

      await _hiveService.openUserBoxes();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
        case 'invalid-email':
          throw InvalidCredentialsException();

        case 'network-request-failed':
          throw NetworkException();

        default:
          throw ApiException();
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }

      throw ApiException();
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      throw AuthException('Passwords do not match.');
    }

    try {
      await _authService.signUp(email: email, password: password);

      await _localStorage.saveUser(name: name);

      await _hiveService.openUserBoxes();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw AuthException('This email is already registered.');

        case 'invalid-email':
          throw AuthException('Invalid email address.');

        case 'weak-password':
          throw AuthException('Password is too weak.');

        case 'network-request-failed':
          throw NetworkException();

        default:
          throw ApiException();
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }

      throw ApiException();
    }
  }

  Future<void> logout() async {
    await _hiveService.closeUserBoxes();

    await _authService.logOut();

    await _localStorage.clearUser();
  }

  Future<bool> isLoggedIn() => _localStorage.isLoggedIn();

  Future<String> getUserName() async {
    return await _localStorage.getUserName() ?? 'Guest';
  }
}
