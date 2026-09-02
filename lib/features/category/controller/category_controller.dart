import 'package:flutter_application_2/core/services/api_service.dart';
import 'package:flutter_application_2/models/movies.dart';

class CategoryController {
  final APIService _apiService = APIService();

  Future<Movies> getMostPopular(int genreId, {int page = 1}) =>
      _apiService.getMoviesByGenre(
        genreId: genreId,
        page: page,
        sortBy: 'popularity.desc',
      );

  Future<Movies> getTopRated(int genreId, {int page = 1}) =>
      _apiService.getMoviesByGenre(
        genreId: genreId,
        page: page,
        sortBy: 'vote_average.desc',
      );

  Future<Movies> getLatest(int genreId, {int page = 1}) =>
      _apiService.getMoviesByGenre(
        genreId: genreId,
        page: page,
        sortBy: 'release_date.desc',
      );

  Future<Movies> getAll(int genreId, {int page = 1}) =>
      _apiService.getMoviesByGenre(
        genreId: genreId,
        page: page,
      );
}