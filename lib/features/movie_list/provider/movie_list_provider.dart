import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/exceptions/app_exception.dart';
import 'package:flutter_application_2/features/movie_list/controller/movie_list_controller.dart';
import 'package:flutter_application_2/core/models/movies.dart';

enum MovieListState { idle, loading, loadingMore, error, success }

class MovieListProvider extends ChangeNotifier {
  late final MovieListController _controller;

  MovieListProvider({required Future<Movies> Function(int page) fetcher}) {
    _controller = MovieListController(fetcher: fetcher);
  }

  MovieListState state = MovieListState.idle;
  String? errorMessage;

  final List<Result> movies = [];
  int _currentPage = 1;
  bool hasMore = true;

  Future<void> loadInitial() async {
    state = MovieListState.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _controller.getPage(1);
      final items = result.results ?? [];
      movies
        ..clear()
        ..addAll(items);
      _currentPage = 1;
      hasMore = items.length >= 20;
      state = MovieListState.success;
    } on AppException catch (e) {
      errorMessage = e.message;
      state = MovieListState.error;
    } catch (_) {
      errorMessage = 'Something went wrong. Please try again.';
      state = MovieListState.error;
    }

    notifyListeners();
  }

  Future<void> loadMore() async {
    if (state == MovieListState.loadingMore || !hasMore) return;

    state = MovieListState.loadingMore;
    notifyListeners();

    try {
      final result = await _controller.getPage(_currentPage + 1);
      final newItems = result.results ?? [];
      movies.addAll(newItems);
      _currentPage++;
      hasMore = newItems.length >= 20;
      state = MovieListState.success;
    } on AppException catch (e) {
      errorMessage = e.message;
      state = MovieListState.error;
    } catch (_) {
      errorMessage = 'Something went wrong. Please try again.';
      state = MovieListState.error;
    }

    notifyListeners();
  }
}