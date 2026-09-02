import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/exceptions/app_exception.dart';
import 'package:flutter_application_2/core/models/movie_record.dart';

import '../controller/favourites_controller.dart';

enum FavouritesState { idle, loading, error, success }

class FavouritesProvider extends ChangeNotifier {
  final FavouritesController _controller = FavouritesController();

  FavouritesState state = FavouritesState.idle;
  List<MovieRecord> movies = [];
  String? errorMessage;

  int get count => movies.length;

  Future<void> loadFavourites() async {
    state = FavouritesState.loading;
    errorMessage = null;
    notifyListeners();

    try {
      movies = await _controller.getFavourites();
      state = FavouritesState.success;
    } on AppException catch (e) {
      errorMessage = e.message;
      state = FavouritesState.error;
    } catch (_) {
      errorMessage = 'Something went wrong. Please try again.';
      state = FavouritesState.error;
    }

    notifyListeners();
  }
}