import 'dart:async';
import 'package:flutter/material.dart';
import '../../../models/movies.dart';
import '../controller/search_controller.dart';

enum SearchState { idle, loading, error, success }

class SearchProvider extends ChangeNotifier {
  final SearchScreenController _controller = SearchScreenController();

  SearchState state = SearchState.idle;
  List<Result> results = [];
  List<String> trendingKeywords = [];
  String _query = '';
  Timer? _debounce;

  String get query => _query;
  bool get hasQuery => _query.trim().isNotEmpty;

  SearchProvider() {
    _loadTrendingKeywords();
  }


  Future<void> _loadTrendingKeywords() async {
    trendingKeywords = await _controller.getTrendingKeywords();
    notifyListeners();
  }


  void onQueryChanged(String value) {
    _query = value;
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
    notifyListeners();
    await _search(keyword);
  }

  Future<void> _search(String query) async {
    state = SearchState.loading;
    notifyListeners();

    try {
      results = await _controller.search(query);
      state = SearchState.success;
    } catch (_) {
      state = SearchState.error;
      results = [];
    }

    notifyListeners();
  }

  void clear() {
    _debounce?.cancel();
    _query = '';
    results = [];
    state = SearchState.idle;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}