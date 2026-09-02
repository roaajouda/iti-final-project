import 'package:flutter_application_2/core/models/movie_record.dart';
import 'package:flutter_application_2/core/services/hive_service.dart';

import '../../../core/services/database_service.dart';

class MyListsController {
  final HiveService _db = HiveService();

  Future<List<MovieRecord>> getWatched() async {
    return _db.getWatched();
  }

  Future<List<MovieRecord>> getWatching() async {
    return _db.getWatchNow();
  }

  Future<List<MovieRecord>> getWantToWatch() async {
    return _db.getWatchLater();
  }
}
