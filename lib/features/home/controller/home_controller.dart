import 'package:flutter_application_2/core/services/api_service.dart';
import 'package:flutter_application_2/models/movies.dart';
import 'package:flutter_application_2/models/single_movie.dart';

class HomeController {
  final APIService _apiService = APIService();

  Future<Movies> getNowPlayingMovies({int page = 1}) =>
      _apiService.getNowPlayingMovies(page: page);

  Future<Movies> getPopularMovies({int page = 1}) =>
      _apiService.getPopularMovies(page: page);

  Future<Movies> getTopRatedMovies({int page = 1}) =>
      _apiService.getTopRatedMovies(page: page);

  Future<Movies> getUpcomingMovies({int page = 1}) =>
      _apiService.getUpcomingMovies(page: page);

  Future<List<Genre>> getMovieGenres() =>
      _apiService.getMovieGenres();
}