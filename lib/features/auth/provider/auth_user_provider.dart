import 'package:flutter/material.dart';

import '../../../core/exceptions/app_exception.dart';
import '../controller/auth_controller.dart';

enum AuthState { idle, loading, error, success }

class AuthUserProvider extends ChangeNotifier {
  final AuthController _controller = AuthController();

  AuthState state = AuthState.idle;
  String errorMessage = '';
  String _userName = '';

  String get userName => _userName;

  Future<void> login({required String email, required String password}) async {
    state = AuthState.loading;
    errorMessage = '';
    notifyListeners();

    try {
      await _controller.login(email: email, password: password);

      await loadUser();

      state = AuthState.success;
    } on AppException catch (e) {
      state = AuthState.error;
      errorMessage = e.message;
    } catch (_) {
      state = AuthState.error;
      errorMessage = 'Something went wrong. Please try again.';
    }

    notifyListeners();
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    state = AuthState.loading;
    errorMessage = '';
    notifyListeners();

    try {
      await _controller.signUp(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );

      await loadUser();

      state = AuthState.success;
    } on AppException catch (e) {
      state = AuthState.error;
      errorMessage = e.message;
    } catch (_) {
      state = AuthState.error;
      errorMessage = 'Something went wrong. Please try again.';
    }

    notifyListeners();
  }

  Future<void> logout() async {
    state = AuthState.loading;
    errorMessage = '';
    notifyListeners();

    try {
      await _controller.logout();

      _userName = '';
      state = AuthState.idle;
    } catch (_) {
      state = AuthState.error;
      errorMessage = 'Something went wrong. Please try again.';
    }

    notifyListeners();
  }

  Future<void> loadUser() async {
    _userName = await _controller.getUserName() ?? '';
    notifyListeners();
  }

  Future<bool> isLoggedIn() {
    return _controller.isLoggedIn();
  }

  String getUserName() {
    return _userName;
  }

  void resetState() {
    state = AuthState.idle;
    errorMessage = '';
    notifyListeners();
  }
}
