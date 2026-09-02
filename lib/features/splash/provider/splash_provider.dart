import 'package:flutter/material.dart';
import '../controller/splash_controller.dart';

enum SplashStatus { waiting, navigateToHome, navigateToLogin }

class SplashProvider extends ChangeNotifier {
  final SplashController _controller = SplashController();

  SplashStatus status = SplashStatus.waiting;

  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 2));

    status = _controller.isLoggedIn()
        ? SplashStatus.navigateToHome
        : SplashStatus.navigateToLogin;

    notifyListeners();
  }
}