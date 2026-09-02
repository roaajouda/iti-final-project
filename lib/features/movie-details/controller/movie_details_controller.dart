import 'package:flutter_application_2/models/movie.record.dart';

import '../../../core/services/api_service.dart';
import '../../../core/services/database_service.dart';
import '../../../models/single_movie.dart';
import '../../../models/movies.dart';

class MovieDetailsController {
  final int movieId;
  final APIService _apiService = APIService();
  final DatabaseService _db = DatabaseService();

  MovieDetailsController({required this.movieId});

  // ── API ──────────────────────────────────────────────────────────────────

  Future<SingleMovie> getMovieDetails() => _apiService.getMovieDetails(movieId);

  /// NOTE: add this method to ApiService if not already present:
  ///
  ///   Future<Movies> getSimilarMovies(int movieId, {int page = 1}) async {
  ///     final json = await _get('/movie/$movieId/similar', {'page': '$page'});
  ///     return Movies.fromJson(json);
  ///   }
  Future<List<Result>> getSimilarMovies() async {
    try {
      final movies = await _apiService.getSimilarMovies(movieId);
      return movies.results ?? [];
    } catch (_) {
      return [];
    }
  }

  // ── Favourites ───────────────────────────────────────────────────────────

  Future<bool> isFavourite() => _db.isFavourite(movieId);

  Future<void> addFavourite(MovieRecord record) => _db.addFavourite(record);

  Future<void> removeFavourite() => _db.removeFavourite(movieId);

  // ── Watch Now ────────────────────────────────────────────────────────────

  Future<bool> isWatchNow() => _db.isWatchNow(movieId);

  Future<void> addWatchNow(MovieRecord record) => _db.addWatchNow(record);

  Future<void> removeWatchNow() => _db.removeWatchNow(movieId);

  // ── Watch Later ──────────────────────────────────────────────────────────

  Future<bool> isWatchLater() => _db.isWatchLater(movieId);

  Future<void> addWatchLater(MovieRecord record) => _db.addWatchLater(record);

  Future<void> removeWatchLater() => _db.removeWatchLater(movieId);

  // ── Watched ──────────────────────────────────────────────────────────────

  Future<bool> isWatched() => _db.isWatched(movieId);

  Future<void> addWatched(MovieRecord record) => _db.addWatched(record);

  Future<void> removeWatched() => _db.removeWatched(movieId);
}