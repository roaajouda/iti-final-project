import 'dart:convert';
import 'dart:io';

import 'package:flutter_application_2/core/constants.dart';
import 'package:flutter_application_2/core/exceptions/app_exception.dart';
import 'package:flutter_application_2/models/movies.dart';
import 'package:flutter_application_2/models/single_movie.dart';
import 'package:http/http.dart' as http;

class APIService {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String _headers = 'Bearer ${Constants.tmdbToken}';

  Future<Movies> getPopularMovies(int page) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movie/popular?page=$page'),
        headers: {'Authorization': _headers},
      );
      return _parseMoviesResponse(response);
    } on SocketException {
      throw NetworkException();
    } on FormatException {
      throw InvalidResponseException();
    }
  }

  Future<Movies> getNowPlayingMovies(int page) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movie/now_playing?page=$page'),
        headers: {'Authorization': _headers},
      );
      return _parseMoviesResponse(response);
    } on SocketException {
      throw NetworkException();
    } on FormatException {
      throw InvalidResponseException();
    }
  }

  Future<dynamic> getTopRatedMovies(int page) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movie/top_rated?page=$page'),
        headers: {'Authorization': _headers},
      );
      return _parseMoviesResponse(response);
    } on SocketException {
      throw NetworkException();
    } on FormatException {
      throw InvalidResponseException();
    }
  }

  Future<dynamic> getUpcomingMovies(int page) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movie/upcoming?page=$page'),
        headers: {'Authorization': _headers},
      );
      return _parseMoviesResponse(response);
    } on SocketException {
      throw NetworkException();
    } on FormatException {
      throw InvalidResponseException();
    }
  }

  Future<Movies> getMoviesBasedOnCategory(int id, int page) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/discover/movie'
          '?with_genres=$id'
          '&page=$page',
        ),
        headers: {'Authorization': _headers},
      );

      return _parseMoviesResponse(response);
    } on SocketException {
      throw NetworkException();
    } on FormatException {
      throw InvalidResponseException();
    }
  }

  Future<Movies> getLatestMoviesBasedOnCategory(int id, int page) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/discover/movie'
          '?with_genres=$id'
          '&sort_by=primary_release_date.desc'
          '&page=$page',
        ),
        headers: {'Authorization': _headers},
      );

      return _parseMoviesResponse(response);
    } on SocketException {
      throw NetworkException();
    } on FormatException {
      throw InvalidResponseException();
    }
  }

  Future<Movies> getMostPopularMoviesBasedOnCategory(int id, int page) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/discover/movie'
          '?with_genres=$id'
          '&sort_by=popularity.desc'
          '&page=$page',
        ),
        headers: {'Authorization': _headers},
      );

      return _parseMoviesResponse(response);
    } on SocketException {
      throw NetworkException();
    } on FormatException {
      throw InvalidResponseException();
    }
  }

  Future<Movies> getTopRatedMoviesBasedOnCategory(int id, int page) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/discover/movie'
          '?with_genres=$id'
          '&sort_by=vote_average.desc'
          '&page=$page',
        ),
        headers: {'Authorization': _headers},
      );

      return _parseMoviesResponse(response);
    } on SocketException {
      throw NetworkException();
    } on FormatException {
      throw InvalidResponseException();
    }
  }

  Future<Movies> getSearchMovies(String query, int page) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/search/movie'
          '?query=${Uri.encodeComponent(query)}'
          '&page=$page',
        ),
        headers: {'Authorization': _headers},
      );

      return _parseMoviesResponse(response);
    } on SocketException {
      throw NetworkException();
    } on FormatException {
      throw InvalidResponseException();
    }
  }

  Future<SingleMovie> getMovie(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movie/$id'),
        headers: {'Authorization': _headers},
      );

      if (response.statusCode != 200) {
        throw ApiException();
      }

      final data = jsonDecode(response.body);

      if (data is! Map<String, dynamic>) {
        throw InvalidResponseException();
      }

      return SingleMovie.fromJson(data);
    } on SocketException {
      throw NetworkException();
    } on FormatException {
      throw InvalidResponseException();
    }
  }

  Future<List<Genre>> getMovieGenres() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/genre/movie/list'),
        headers: {'Authorization': _headers},
      );

      if (response.statusCode != 200) {
        throw ApiException();
      }

      final data = jsonDecode(response.body);

      if (data is! Map<String, dynamic> || data['genres'] is! List) {
        throw InvalidResponseException();
      }

      return List<Genre>.from(
        data['genres'].map((genre) => Genre.fromJson(genre)),
      );
    } on SocketException {
      throw NetworkException();
    } on FormatException {
      throw InvalidResponseException();
    }
  }

  Movies _parseMoviesResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw ApiException();
    }

    final data = jsonDecode(response.body);

    if (data is! Map<String, dynamic> || data['results'] is! List) {
      throw InvalidResponseException();
    }

    final movies = Movies.fromJson(data);

    if (movies.results.isEmpty) {
      throw EmptyMoviesException();
    }

    return movies;
  }
}
