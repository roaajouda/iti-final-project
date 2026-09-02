import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/exceptions/app_exception.dart';
import 'package:flutter_application_2/features/category/controller/category_controller.dart';
import 'package:flutter_application_2/models/movies.dart';

enum CategoryState { idle, loading, error, success }

class CategoryProvider extends ChangeNotifier {
  final CategoryController _controller = CategoryController();

  CategoryState state = CategoryState.idle;
  String? errorMessage;

  Movies? mostPopular;
  Movies? topRated;
  Movies? latest;
  Movies? all;

  Future<void> loadCategory(int genreId) async {
    state = CategoryState.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _controller.getMostPopular(genreId),
        _controller.getTopRated(genreId),
        _controller.getLatest(genreId),
        _controller.getAll(genreId),
      ]);

      mostPopular = results[0];
      topRated   = results[1];
      latest     = results[2];
      all        = results[3];
      state = CategoryState.success;
    } on EmptyMoviesException {
      state = CategoryState.success;
    } on AppException catch (e) {
      errorMessage = e.message;
      state = CategoryState.error;
    } catch (_) {
      errorMessage = 'Something went wrong. Please try again.';
      state = CategoryState.error;
    }

    notifyListeners();
  }

  Future<Movies> fetchMostPopularPage(int genreId, int page) =>
      _controller.getMostPopular(genreId, page: page);

  Future<Movies> fetchTopRatedPage(int genreId, int page) =>
      _controller.getTopRated(genreId, page: page);

  Future<Movies> fetchLatestPage(int genreId, int page) =>
      _controller.getLatest(genreId, page: page);

  Future<Movies> fetchAllPage(int genreId, int page) =>
      _controller.getAll(genreId, page: page);
}