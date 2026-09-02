import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/exceptions/app_exception.dart';

import '../../../core/models/movies.dart';
import '../controller/search_controller.dart';

enum SearchState { idle, loading, error, success }

class SearchProvider extends ChangeNotifier {
  final SearchScreenController _controller = SearchScreenController();

  SearchState state = SearchState.idle;

  List<Result> results = [];
  List<String> trendingKeywords = [];

  String? errorMessage;

  String _query = '';
  Timer? _debounce;

  String get query => _query;
  bool get hasQuery => _query.trim().isNotEmpty;

  SearchProvider() {
    _loadTrendingKeywords();
  }

  Future<void> _loadTrendingKeywords() async {
    try {
      trendingKeywords = await _controller.getTrendingKeywords();
      notifyListeners();
    } on AppException catch (e) {
      errorMessage = e.message;
      notifyListeners();
    } catch (_) {
      errorMessage = 'Something went wrong. Please try again.';
      notifyListeners();
    }
  }

  void onQueryChanged(String value) {
    _query = value;
    errorMessage = null;
    notifyListeners();

    _debounce?.cancel();

    if (value.trim().isEmpty) {
      results = [];
      state = SearchState.idle;
      notifyListeners();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 400), () => _search(value));
  }

  Future<void> searchKeyword(String keyword) async {
    _query = keyword;
    errorMessage = null;
    notifyListeners();

    await _search(keyword);
  }

  Future<void> _search(String query) async {
    state = SearchState.loading;
    errorMessage = null;
    notifyListeners();

    try {
      results = await _controller.search(query);
      state = SearchState.success;
    } on AppException catch (e) {
      errorMessage = e.message;
      results = [];
      state = SearchState.error;
    } catch (_) {
      errorMessage = 'Something went wrong. Please try again.';
      results = [];
      state = SearchState.error;
    }

    notifyListeners();
  }

  void clear() {
    _debounce?.cancel();
    _query = '';
    results = [];
    errorMessage = null;
    state = SearchState.idle;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
