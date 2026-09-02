import 'package:firebase_auth/firebase_auth.dart';

class SplashController {
  bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }
}