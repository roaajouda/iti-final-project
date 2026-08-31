import 'package:flutter/material.dart';
import 'package:flutter_application_2/features/auth/controller/auth_controller.dart';

class AuthProvider extends ChangeNotifier {
  AuthController controller = AuthController();
  String? errorMessage;
  AuthStates state = AuthStates.idel;
  void login(String email, String password) async {
    state = AuthStates.loading;
    String res = await controller.login(email, password);
    if (res != 'success') {
      errorMessage = res;
      state = AuthStates.error;
    } else {
      state = AuthStates.sucess;
      errorMessage = null;
    }
    notifyListeners();
  }
}

enum AuthStates { idel, loading, error, sucess }
