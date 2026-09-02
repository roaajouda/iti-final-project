import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_2/core/constants.dart';
import 'package:flutter_application_2/core/exceptions/app_exception.dart';
import 'package:flutter_application_2/models/movies.dart';
import 'package:flutter_application_2/models/single_movie.dart';

class ApiService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String _authHeader = 'Bearer ${Constants.tmdbToken}';

  Map<String, String> get _headers => {
        'Authorization': _authHeader,
        'accept': 'application/json',
      };

  // ─── Private helpers ───────────────────────────────────────────────

  Future<Map<String, dynamic>> _get(String path,
      [Map<String, String>? params]) async {
    final uri = Uri.parse('$_baseUrl$path')
        .replace(queryParameters: params);
    try {
      final response = await http.get(uri, headers: _headers);
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw ApiException();
      }
    } on ApiException {
      rethrow;
    } catch (_) {
      throw NetworkException();
    }
  }

  Movies _parseMovies(Map<String, dynamic> json) {
    final movies = Movies.fromJson(json);
    if (movies.results == null || movies.results!.isEmpty) {
      throw EmptyMoviesException();
    }
    return movies;
  }

  Movies _parseSearchMovies(Map<String, dynamic> json) {
    // Search can legitimately return empty — don't throw EmptyMoviesException
    return Movies.fromJson(json);
  }

  // ─── Home ──────────────────────────────────────────────────────────

  Future<Movies> getNowPlayingMovies({int page = 1}) async {
    final json = await _get('/movie/now_playing', {'page': '$page'});
    return _parseMovies(json);
  }

  Future<Movies> getPopularMovies({int page = 1}) async {
    final json = await _get('/movie/popular', {'page': '$page'});
    return _parseMovies(json);
  }

  Future<Movies> getTopRatedMovies({int page = 1}) async {
    final json = await _get('/movie/top_rated', {'page': '$page'});
    return _parseMovies(json);
  }

  Future<Movies> getUpcomingMovies({int page = 1}) async {
    final json = await _get('/movie/upcoming', {'page': '$page'});
    return _parseMovies(json);
  }

  // ─── Genres ────────────────────────────────────────────────────────

  Future<List<Genre>> getMovieGenres() async {
    final json = await _get('/genre/movie/list');
    final list = json['genres'] as List?;
    if (list == null) throw InvalidResponseException();
    return list.map((e) => Genre.fromJson(e as Map<String, dynamic>)).toList();
  }

  // ─── Category ──────────────────────────────────────────────────────

  Future<Movies> getMoviesByGenre({
    required int genreId,
    int page = 1,
    String sortBy = 'popularity.desc',
  }) async {
    final json = await _get('/discover/movie', {
      'with_genres': '$genreId',
      'page': '$page',
      'sort_by': sortBy,
    });
    return _parseMovies(json);
  }

  // ─── Search ────────────────────────────────────────────────────────

  Future<Movies> searchMovies(String query, {int page = 1}) async {
    final json = await _get('/search/movie', {
      'query': query,
      'page': '$page',
    });
    return _parseSearchMovies(json);
  }

  // ─── Single Movie ──────────────────────────────────────────────────

  Future<SingleMovie> getMovieDetails(int movieId) async {
    final json = await _get('/movie/$movieId');
    return SingleMovie.fromJson(json);
  }
}