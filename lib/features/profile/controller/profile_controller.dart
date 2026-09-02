import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/database_service.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/services/firebase_auth_service.dart';

class ProfileController {
  final LocalStorageService _localStorage = LocalStorageService();
  final DatabaseService _db = DatabaseService();
  final FirebaseAuthService _authService = FirebaseAuthService();

  Future<String> getName() async {
    return await _localStorage.getUserName() ?? 'User';
  }

  String? getEmail() {
    return FirebaseAuth.instance.currentUser?.email;
  }

  Future<int> getFavouritesCount() async {
    final list = await _db.getFavourites();
    return list.length;
  }

  Future<int> getWatchedCount() async {
    final list = await _db.getWatched();
    return list.length;
  }

  Future<int> getWantToWatchCount() async {
    final list = await _db.getWatchLater();
    return list.length;
  }

  Future<void> logout() => _authService.logOut();
}