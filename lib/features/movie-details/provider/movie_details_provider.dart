import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/models/movie_record.dart';

import '../../../core/exceptions/app_exception.dart';
import '../../../core/models/movies.dart';
import '../../../core/models/single_movie.dart';
import '../controller/movie_details_controller.dart';

enum MovieDetailsState { idle, loading, error, success }

class MovieDetailsProvider extends ChangeNotifier {
  late final MovieDetailsController _controller;

  MovieDetailsProvider({required int movieId}) {
    _controller = MovieDetailsController(movieId: movieId);
  }

  MovieDetailsState state = MovieDetailsState.idle;

  SingleMovie? movie;
  List<Result> similarMovies = [];

  String errorMessage = '';

  bool isFavourite = false;
  bool isWatchNow = false;
  bool isWatchLater = false;
  bool isWatched = false;

  Future<void> loadDetails() async {
    state = MovieDetailsState.loading;
    errorMessage = '';
    notifyListeners();

    try {
      final results = await Future.wait([
        _controller.getMovieDetails(),
        _controller.getSimilarMovies(),
        _controller.isFavourite(),
        _controller.isWatchNow(),
        _controller.isWatchLater(),
        _controller.isWatched(),
      ]);

      movie = results[0] as SingleMovie;
      similarMovies = results[1] as List<Result>;
      isFavourite = results[2] as bool;
      isWatchNow = results[3] as bool;
      isWatchLater = results[4] as bool;
      isWatched = results[5] as bool;

      state = MovieDetailsState.success;
    } on AppException catch (e) {
      state = MovieDetailsState.error;
      errorMessage = e.message;
    } catch (_) {
      state = MovieDetailsState.error;
      errorMessage = 'Something went wrong. Please try again.';
    }

    notifyListeners();
  }

  MovieRecord get _record => MovieRecord.fromSingleMovie(movie!);

  Future<void> toggleFavourite() async {
    try {
      if (isFavourite) {
        await _controller.removeFavourite();
        isFavourite = false;
      } else {
        await _controller.addFavourite(_record);
        isFavourite = true;
      }

      errorMessage = '';
      notifyListeners();
    } on AppException catch (e) {
      errorMessage = e.message;
      notifyListeners();
    } catch (_) {
      errorMessage = 'Something went wrong. Please try again.';
      notifyListeners();
    }
  }

  Future<void> toggleWatchNow() async {
    try {
      if (isWatchNow) {
        await _controller.removeWatchNow();
        isWatchNow = false;
      } else {
        await _controller.addWatchNow(_record);
        isWatchNow = true;
      }

      errorMessage = '';
      notifyListeners();
    } on AppException catch (e) {
      errorMessage = e.message;
      notifyListeners();
    } catch (_) {
      errorMessage = 'Something went wrong. Please try again.';
      notifyListeners();
    }
  }

  Future<void> toggleWatchLater() async {
    try {
      if (isWatchLater) {
        await _controller.removeWatchLater();
        isWatchLater = false;
      } else {
        await _controller.addWatchLater(_record);
        isWatchLater = true;
      }

      errorMessage = '';
      notifyListeners();
    } on AppException catch (e) {
      errorMessage = e.message;
      notifyListeners();
    } catch (_) {
      errorMessage = 'Something went wrong. Please try again.';
      notifyListeners();
    }
  }

  Future<void> toggleWatched() async {
    try {
      if (isWatched) {
        await _controller.removeWatched();
        isWatched = false;
      } else {
        await _controller.addWatched(_record);
        isWatched = true;
      }

      errorMessage = '';
      notifyListeners();
    } on AppException catch (e) {
      errorMessage = e.message;
      notifyListeners();
    } catch (_) {
      errorMessage = 'Something went wrong. Please try again.';
      notifyListeners();
    }
  }
}
