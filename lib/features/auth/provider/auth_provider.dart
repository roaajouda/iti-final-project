import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/exceptions/app_exception.dart';
import 'package:flutter_application_2/features/auth/controller/auth_controller.dart';

class AuthProvider extends ChangeNotifier {
  final AuthController _controller = AuthController();

  String? errorMessage;
  String? userName;

  AuthState state = AuthState.idle;

  Future<void> login(String email, String password) async {
    state = AuthState.loading;
    errorMessage = null;

    notifyListeners();

    try {
      await _controller.login(email, password);

      userName = await _controller.getUserName();

      state = AuthState.success;
    } on AppException catch (e) {
      errorMessage = e.message;
      state = AuthState.error;
    } catch (e) {
      errorMessage = 'Something went wrong';
      state = AuthState.error;
    }

    notifyListeners();
  }

  Future<void> signUp(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    state = AuthState.loading;
    errorMessage = null;

    notifyListeners();

    try {
      await _controller.signUp(name, email, password, confirmPassword);

      userName = name;

      state = AuthState.success;
    } on AppException catch (e) {
      errorMessage = e.message;
      state = AuthState.error;
    } catch (e) {
      errorMessage = 'Something went wrong.';
      state = AuthState.error;
    }

    notifyListeners();
  }

  Future<void> loadUser() async {
    try {
      userName = await _controller.getUserName();
      notifyListeners();
    } catch (e) {
      userName = null;
    }
  }

  Future<bool> isLoggedIn() async {
    return await _controller.isLoggedIn();
  }

  Future<void> logout() async {
    await _controller.logout();

    userName = null;
    state = AuthState.idle;

    notifyListeners();
  }
}

enum AuthState { idle, loading, error, success }
