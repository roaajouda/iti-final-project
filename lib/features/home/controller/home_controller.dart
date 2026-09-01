import 'package:flutter_application_2/core/services/api_service.dart';
import 'package:flutter_application_2/models/movies.dart';
import 'package:flutter_application_2/models/single_movie.dart';

class HomeController {
  final APIService apiService = APIService();

  // Search
  Future<Movies> getSearchMovies(String query, int page) async {
    return await apiService.getSearchMovies(query, page);
  }

  // Categories
  Future<List<Genre>> getMovieGenres() async {
    return await apiService.getMovieGenres();
  }

  // Now Playing
  Future<Movies> getNowPlayingMovies(int page) async {
    return await apiService.getNowPlayingMovies(page);
  }

  // Popular
  Future<Movies> getPopularMovies(int page) async {
    return await apiService.getPopularMovies(page);
  }

  // Top Rated
  Future<Movies> getTopRatedMovies(int page) async {
    return await apiService.getTopRatedMovies(page);
  }

  // Upcoming
  Future<Movies> getUpcomingMovies(int page) async {
    return await apiService.getUpcomingMovies(page);
  }
}