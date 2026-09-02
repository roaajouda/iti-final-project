import '../../../core/services/api_service.dart';
import '../../../models/movies.dart';

class SearchScreenController {
  final APIService _apiService = APIService();

  Future<List<Result>> search(String query, {int page = 1}) async {
    if (query.trim().isEmpty) return [];
    final movies = await _apiService.searchMovies(query, page: page);
    return movies.results ?? [];
  }
}