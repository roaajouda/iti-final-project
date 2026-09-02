import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/exceptions/app_exception.dart';
import 'package:flutter_application_2/models/movies.dart';

enum MovieListState { idle, loading, loadingMore, error, success }

class MovieListProvider extends ChangeNotifier {
  final Future<Movies> Function(int page) fetcher;

  MovieListProvider({required this.fetcher});

  MovieListState state = MovieListState.idle;
  String? errorMessage;

  final List<Result> movies = [];
  int _currentPage = 1;
  bool hasMore = true;

  /// Call once when screen opens
  Future<void> loadInitial() async {
    state = MovieListState.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await fetcher(1);
      movies
        ..clear()
        ..addAll(result.results ?? []);
      _currentPage = 1;
      hasMore = (result.results?.length ?? 0) >= 20; // TMDB returns 20/page
      state = MovieListState.success;
    } on AppException catch (e) {
      errorMessage = e.message;
      state = MovieListState.error;
    } catch (_) {
      errorMessage = 'Something went wrong.';
      state = MovieListState.error;
    }

    notifyListeners();
  }

  /// Call when user scrolls near the bottom
  Future<void> loadMore() async {
    if (state == MovieListState.loadingMore || !hasMore) return;

    state = MovieListState.loadingMore;
    notifyListeners();

    try {
      final result = await fetcher(_currentPage + 1);
      final newMovies = result.results ?? [];
      if (newMovies.isEmpty) {
        hasMore = false;
      } else {
        movies.addAll(newMovies);
        _currentPage++;
        hasMore = newMovies.length >= 20;
      }
      state = MovieListState.success;
    } on AppException catch (e) {
      errorMessage = e.message;
      state = MovieListState.error;
    } catch (_) {
      errorMessage = 'Something went wrong.';
      state = MovieListState.error;
    }

    notifyListeners();
  }
}