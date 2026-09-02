import 'package:flutter_application_2/core/models/movie.record.dart';

import '../../../core/services/database_service.dart';

class FavouritesController {
  final DatabaseService _db = DatabaseService();

  Future<List<MovieRecord>> getFavourites() => _db.getFavourites();
}