import 'package:flutter_application_2/models/movie.record.dart';

import '../../../core/services/database_service.dart';

class MyListsController {
  final DatabaseService _db = DatabaseService();

  Future<List<MovieRecord>> getWatched() => _db.getWatched();
  Future<List<MovieRecord>> getWatching() => _db.getWatchNow();
  Future<List<MovieRecord>> getWantToWatch() => _db.getWatchLater();
}