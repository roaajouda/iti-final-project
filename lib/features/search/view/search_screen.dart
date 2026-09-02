import 'package:flutter/material.dart';
import 'package:flutter_application_2/features/movie-details/view/movie_details_screen.dart';
import 'package:provider/provider.dart';
import '../provider/search_provider.dart';
import '../../../models/movies.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchProvider(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;

  static const Color _bg = Color(0xFF141414);
  static const Color _accent = Color(0xFFFFB800);
  static const Color _surface = Color(0xFF2A2A2A);

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Consumer<SearchProvider>(
          builder: (context, provider, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                _buildSearchBar(context, provider),
                const SizedBox(height: 20),
                Expanded(
                  child: provider.hasQuery
                      ? _buildResults(context, provider)
                      : _buildTrending(provider),
                ),
              ],
            );
          },
        ),
      ),
    );
  }


  Widget _buildSearchBar(BuildContext context, SearchProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                cursorColor: _accent,
                decoration: const InputDecoration(
                  hintText: 'Search TMDB...',
                  hintStyle: TextStyle(color: Colors.white38, fontSize: 15),
                  prefixIcon: Icon(Icons.search, color: Colors.white38, size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
                onChanged: provider.onQueryChanged,
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              _textController.clear();
              provider.clear();
              _focusNode.requestFocus();
            },
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Clear',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTrending(SearchProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TRENDING SEARCHES',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: SearchProvider.trendingKeywords
                .map(
                  (kw) => GestureDetector(
                    onTap: () {
                      _textController.text = kw;
                      provider.searchKeyword(kw);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white24),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        kw,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }


  Widget _buildResults(BuildContext context, SearchProvider provider) {
    if (provider.state == SearchState.loading) {
      return const Center(
        child: CircularProgressIndicator(color: _accent),
      );
    }

    if (provider.state == SearchState.error) {
      return const Center(
        child: Text(
          'Something went wrong.',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    if (provider.results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, color: Colors.white24, size: 48),
            const SizedBox(height: 12),
            Text(
              'No results for "${provider.query}"',
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 16,
        childAspectRatio: 0.58,
      ),
      itemCount: provider.results.length,
      itemBuilder: (context, index) {
        final movie = provider.results[index];
        return _ResultCard(movie: movie);
      },
    );
  }
}


class _ResultCard extends StatelessWidget {
  final Result movie;
  const _ResultCard({required this.movie});

  static const String _imgBase = 'https://image.tmdb.org/t/p/w342';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => MovieDetailsScreen(movieId: movie.id!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: movie.posterPath != null
                  ? Image.network(
                      '$_imgBase${movie.posterPath}',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            movie.title ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1F1F1F),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.movie, color: Colors.white24),
      );
}