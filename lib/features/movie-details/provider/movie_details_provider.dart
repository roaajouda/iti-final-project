import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/movie.record.dart';
import '../../../core/exceptions/app_exception.dart';
import '../../../models/movies.dart';
import '../../../models/single_movie.dart';
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
    } catch (e) {
      state = MovieDetailsState.error;
      errorMessage = 'Failed to load movie details.';
    }

    notifyListeners();
  }


  MovieRecord get _record => MovieRecord.fromSingleMovie(movie!);

  Future<void> toggleFavourite() async {
    isFavourite = !isFavourite;
    notifyListeners();
    if (isFavourite) {
      await _controller.addFavourite(_record);
    } else {
      await _controller.removeFavourite();
    }
  }

  Future<void> toggleWatchNow() async {
    isWatchNow = !isWatchNow;
    notifyListeners();
    if (isWatchNow) {
      await _controller.addWatchNow(_record);
    } else {
      await _controller.removeWatchNow();
    }
  }

  Future<void> toggleWatchLater() async {
    isWatchLater = !isWatchLater;
    notifyListeners();
    if (isWatchLater) {
      await _controller.addWatchLater(_record);
    } else {
      await _controller.removeWatchLater();
    }
  }

  Future<void> toggleWatched() async {
    isWatched = !isWatched;
    notifyListeners();
    if (isWatched) {
      await _controller.addWatched(_record);
    } else {
      await _controller.removeWatched();
    }
  }
}