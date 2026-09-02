import 'package:flutter/material.dart';
import 'package:flutter_application_2/features/movie-details/view/movie_details_screen.dart';
import 'package:flutter_application_2/models/movie.record.dart';
import 'package:provider/provider.dart';
import '../provider/favourites_provider.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FavouritesProvider()..loadFavourites(),
      child: const _FavouritesView(),
    );
  }
}

class _FavouritesView extends StatelessWidget {
  const _FavouritesView();

  static const Color _bg = Color(0xFF141414);
  static const Color _accent = Color(0xFFFFB800);
  static const Color _surface = Color(0xFF1F1F1F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(),
      body: SafeArea(
        child: Consumer<FavouritesProvider>(
          builder: (context, provider, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(provider.count),
                Expanded(child: _buildBody(context, provider)),
              ],
            );
          },
        ),
      ),
    );
  }



  Widget _buildHeader(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Favourites',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'SQLite · $count movies',
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, FavouritesProvider provider) {
    if (provider.state == FavouritesState.loading) {
      return const Center(
        child: CircularProgressIndicator(color: _accent),
      );
    }

    if (provider.movies.isEmpty) {
      return _buildEmptyState(context);
    }

    return _buildGrid(context, provider.movies);
  }


  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.favorite_border,
                color: Colors.white38,
                size: 32,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Nothing saved yet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Movies you favourite are stored on this device and stay here after you close the app.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 28),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: _accent,
                side: const BorderSide(color: _accent),
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Browse movies',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildGrid(BuildContext context, List<MovieRecord> movies) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.62,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) =>
          _MovieCard(movie: movies[index]),
    );
  }
}


class _MovieCard extends StatelessWidget {
  final MovieRecord movie;
  const _MovieCard({required this.movie});

  static const String _imgBase = 'https://image.tmdb.org/t/p/w342';
  static const Color _surface = Color(0xFF1F1F1F);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => MovieDetailsScreen(movieId: movie.id),
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
          const SizedBox(height: 6),
          Text(
            movie.title,
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
        color: _surface,
        child: const Icon(Icons.movie, color: Colors.white24),
      );
}