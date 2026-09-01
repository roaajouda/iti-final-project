import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/exceptions/app_exception.dart';
import 'package:flutter_application_2/features/home/controller/home_controller.dart';
import 'package:flutter_application_2/models/movies.dart';
import 'package:flutter_application_2/models/single_movie.dart';

class HomeProvider extends ChangeNotifier {
  final HomeController _controller = HomeController();

  String? errorMessage;
  MovieState state = MovieState.idle;

  Movies? nowPlayingMovies;
  Movies? popularMovies;
  Movies? topRatedMovies;
  Movies? upcomingMovies;

  List<Genre> genres = [];

  Future<void> getHomeMovies() async {
    state = MovieState.loading;
    errorMessage = null;

    notifyListeners();

    try {
      nowPlayingMovies = await _controller.getNowPlayingMovies(1);
      popularMovies = await _controller.getPopularMovies(1);
      topRatedMovies = await _controller.getTopRatedMovies(1);
      upcomingMovies = await _controller.getUpcomingMovies(1);

      state = MovieState.success;
    } on AppException catch (e) {
      errorMessage = e.message;
      state = MovieState.error;
    } catch (e) {
      errorMessage = 'Something went wrong.';
      state = MovieState.error;
    }

    notifyListeners();
  }

  Future<void> getGenres() async {
    errorMessage = null;

    try {
      genres = await _controller.getMovieGenres();

      notifyListeners();
    } on AppException catch (e) {
      errorMessage = e.message;
      notifyListeners();
    } catch (e) {
      errorMessage = 'Something went wrong.';
      notifyListeners();
    }
  }

  Future<Movies?> searchMovies(String query, int page) async {
    errorMessage = null;

    try {
      return await _controller.getSearchMovies(query, page);
    } on AppException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'Something went wrong.';
    }

    notifyListeners();
    return null;
  }
}

enum MovieState { idle, loading, error, success }
