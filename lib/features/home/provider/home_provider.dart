import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/exceptions/app_exception.dart';
import 'package:flutter_application_2/features/home/controller/home_controller.dart';
import 'package:flutter_application_2/models/movies.dart';
import 'package:flutter_application_2/models/single_movie.dart';

enum HomeState { idle, loading, error, success }

class HomeProvider extends ChangeNotifier {
  final HomeController _controller = HomeController();

  HomeState state = HomeState.idle;
  String? errorMessage;

  Movies? nowPlayingMovies;
  Movies? popularMovies;
  Movies? topRatedMovies;
  Movies? upcomingMovies;
  List<Genre> genres = [];

  Future<void> loadHome() async {
    state = HomeState.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _controller.getNowPlayingMovies(),
        _controller.getPopularMovies(),
        _controller.getTopRatedMovies(),
        _controller.getUpcomingMovies(),
        _controller.getMovieGenres(),
      ]);

      nowPlayingMovies = results[0] as Movies;
      popularMovies    = results[1] as Movies;
      topRatedMovies   = results[2] as Movies;
      upcomingMovies   = results[3] as Movies;
      genres           = results[4] as List<Genre>;
      state = HomeState.success;
    } on AppException catch (e) {
      errorMessage = e.message;
      state = HomeState.error;
    } catch (_) {
      errorMessage = 'Something went wrong. Please try again.';
      state = HomeState.error;
    }

    notifyListeners();
  }

  // ── Fetchers used by MovieListScreen ─────────────────────────────
  // Screen → Provider → Controller → ApiService (never skip a layer)

  Future<Movies> fetchPopularPage(int page) =>
      _controller.getPopularMovies(page: page);

  Future<Movies> fetchTopRatedPage(int page) =>
      _controller.getTopRatedMovies(page: page);

  Future<Movies> fetchUpcomingPage(int page) =>
      _controller.getUpcomingMovies(page: page);
}