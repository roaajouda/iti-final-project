import 'package:flutter/material.dart';
import '../controller/profile_controller.dart';

enum ProfileState { idle, loading, error, success }

class ProfileProvider extends ChangeNotifier {
  final ProfileController _controller = ProfileController();

  ProfileState state = ProfileState.idle;

  String name = '';
  String email = '';
  int favouritesCount = 0;
  int watchedCount = 0;
  int wantToWatchCount = 0;

  Future<void> loadProfile() async {
    state = ProfileState.loading;
    notifyListeners();

    try {
      final results = await Future.wait([
        _controller.getName(),
        _controller.getFavouritesCount(),
        _controller.getWatchedCount(),
        _controller.getWantToWatchCount(),
      ]);

      name = results[0] as String;
      email = _controller.getEmail() ?? '';
      favouritesCount = results[1] as int;
      watchedCount = results[2] as int;
      wantToWatchCount = results[3] as int;

      state = ProfileState.success;
    } catch (_) {
      state = ProfileState.error;
    }

    notifyListeners();
  }

  Future<void> logout() => _controller.logout();
}