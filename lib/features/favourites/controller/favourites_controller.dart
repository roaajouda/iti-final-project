import 'package:flutter_application_2/core/models/movie_record.dart';
import 'package:flutter_application_2/core/services/hive_service.dart';

class FavouritesController {
  final HiveService _db = HiveService();

  Future<List<MovieRecord>> getFavourites() async {
    return _db.getFavourites();
  }
}
