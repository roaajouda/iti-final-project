import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/exceptions/app_exception.dart';
import 'package:flutter_application_2/features/category/controller/category_controller.dart';
import 'package:flutter_application_2/models/movies.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryController _controller = CategoryController();

  String? errorMessage;
  CategoryState state = CategoryState.idle;

  Movies? allMovies;
  Movies? mostPopular;
  Movies? topRated;
  Movies? latest;

  Future<void> loadCategory(int genreId) async {
    state = CategoryState.loading;
    errorMessage = null;
    notifyListeners();

    try {
      // Run all four fetches in parallel — faster than sequential awaits
      final results = await Future.wait([
        _controller.getMovies(genreId, 1),
        _controller.getMostPopular(genreId, 1),
        _controller.getTopRated(genreId, 1),
        _controller.getLatest(genreId, 1),
      ]);

      allMovies   = results[0];
      mostPopular = results[1];
      topRated    = results[2];
      latest      = results[3];

      state = CategoryState.success;
    } on EmptyMoviesException {
      // Not a real error — just an empty genre
      state = CategoryState.success;
    } on AppException catch (e) {
      errorMessage = e.message;
      state = CategoryState.error;
    } catch (e) {
      errorMessage = 'Something went wrong.';
      state = CategoryState.error;
    }

    notifyListeners();
  }
}

enum CategoryState { idle, loading, error, success }