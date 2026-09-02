import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/services/firebase_auth_service.dart';
import '../../../core/services/hive_service.dart';
import '../../../core/services/local_storage_service.dart';

class ProfileController {
  final LocalStorageService _localStorage = LocalStorageService();
  final HiveService _db = HiveService();
  final FirebaseAuthService _authService = FirebaseAuthService();

  Future<String> getName() async {
    return await _localStorage.getUserName() ?? 'User';
  }

  String? getEmail() {
    return FirebaseAuth.instance.currentUser?.email;
  }

  Future<int> getFavouritesCount() async {
    final list = _db.getFavourites();
    return list.length;
  }

  Future<int> getWatchedCount() async {
    final list = _db.getWatched();
    return list.length;
  }

  Future<int> getWantToWatchCount() async {
    final list = _db.getWatchLater();
    return list.length;
  }

  Future<void> logout() async {
    await _db.closeUserBoxes();
    await _authService.logOut();
    await _localStorage.clearUser(); 
  }
}
