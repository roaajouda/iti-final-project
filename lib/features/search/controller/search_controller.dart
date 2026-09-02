import '../../../core/services/api_service.dart';
import '../../../models/movies.dart';

class SearchScreenController {
  final APIService _apiService = APIService();

  Future<List<Result>> search(String query, {int page = 1}) async {
    if (query.trim().isEmpty) return [];
    final movies = await _apiService.searchMovies(query, page: page);
    return movies.results ?? [];
  }
  Future<List<String>> getTrendingKeywords() async {
    try {
      final movies = await _apiService.getTrendingMovies();
      final keywords = movies.results
              ?.take(6)
              .map((m) => m.title ?? '')
              .where((t) => t.isNotEmpty)
              .toList() ??
          [];
      return keywords.isNotEmpty ? keywords : _fallback;
    } catch (_) {
      return _fallback;
    }
  }

  static const List<String> _fallback = [
    'Dune', 'Drama', 'Animation', 'Batman', '2023', 'Thriller',
  ];
}