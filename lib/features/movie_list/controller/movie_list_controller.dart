import 'package:flutter_application_2/models/movies.dart';

class MovieListController {
  final Future<Movies> Function(int page) fetcher;

  MovieListController({required this.fetcher});

  Future<Movies> getPage(int page) => fetcher(page);
}