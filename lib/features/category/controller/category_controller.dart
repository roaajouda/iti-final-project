import 'package:flutter_application_2/core/services/api_service.dart';
import 'package:flutter_application_2/models/movies.dart';

class CategoryController {
  final APIService _apiService = APIService();

  Future<Movies> getMovies(int genreId, int page) async {
    return await _apiService.getMoviesBasedOnCategory(genreId, page);
  }

  Future<Movies> getMostPopular(int genreId, int page) async {
    return await _apiService.getMostPopularMoviesBasedOnCategory(genreId, page);
  }

  Future<Movies> getTopRated(int genreId, int page) async {
    return await _apiService.getTopRatedMoviesBasedOnCategory(genreId, page);
  }

  Future<Movies> getLatest(int genreId, int page) async {
    return await _apiService.getLatestMoviesBasedOnCategory(genreId, page);
  }
}