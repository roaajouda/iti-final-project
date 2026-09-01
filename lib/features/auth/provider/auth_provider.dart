import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/exceptions/app_exception.dart';
import 'package:flutter_application_2/features/auth/controller/auth_controller.dart';

class AuthProvider extends ChangeNotifier {
  final AuthController _controller = AuthController();
  String? errorMessage;
  AuthState state = AuthState.idle;
  Future<void> login(String email, String password) async {
    state = AuthState.loading;
    errorMessage = null;
    notifyListeners();

    try {
      await _controller.login(email, password);

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
    String email,
    String password,
    String confirmPassword,
  ) async {
    state = AuthState.loading;
    errorMessage = null;

    notifyListeners();

    try {
      await _controller.signUp(email, password, confirmPassword);

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
}

enum AuthState { idle, loading, error, success }
