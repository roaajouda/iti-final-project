import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/models/movie.record.dart';
import '../controller/favourites_controller.dart';

enum FavouritesState { idle, loading, error, success }

class FavouritesProvider extends ChangeNotifier {
  final FavouritesController _controller = FavouritesController();

  FavouritesState state = FavouritesState.idle;
  List<MovieRecord> movies = [];

  int get count => movies.length;

  Future<void> loadFavourites() async {
    state = FavouritesState.loading;
    notifyListeners();

    try {
      movies = await _controller.getFavourites();
      state = FavouritesState.success;
    } catch (_) {
      state = FavouritesState.error;
    }

    notifyListeners();
  }
}