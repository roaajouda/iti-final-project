import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/movie_details_provider.dart';
import '../../../core/models/single_movie.dart';
import '../../../core/models/movies.dart';

class MovieDetailsScreen extends StatelessWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MovieDetailsProvider(movieId: movieId)..loadDetails(),
      child: const _MovieDetailsView(),
    );
  }
}


class _MovieDetailsView extends StatelessWidget {
  const _MovieDetailsView();

  static const String _imgBase = 'https://image.tmdb.org/t/p/';
  static const Color _accent = Color(0xFFFFB800);
  static const Color _bg = Color(0xFF141414);
  static const Color _surface = Color(0xFF1F1F1F);
  static const Color _label = Color(0xFF9E9E9E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Consumer<MovieDetailsProvider>(
        builder: (context, provider, _) {
          if (provider.state == MovieDetailsState.loading) {
            return const Center(
              child: CircularProgressIndicator(color: _accent),
            );
          }

          if (provider.state == MovieDetailsState.error) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    provider.errorMessage,
                    style: const TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: provider.loadDetails,
                    style: ElevatedButton.styleFrom(backgroundColor: _accent),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final movie = provider.movie;
          if (movie == null) return const SizedBox.shrink();

          return CustomScrollView(
            slivers: [
              _buildAppBar(context, movie, provider),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfo(movie),
                      const SizedBox(height: 16),
                      _buildGenreChips(movie.genres),
                      const SizedBox(height: 20),
                      _buildActionButtons(provider),
                      const SizedBox(height: 24),
                      _buildSection('OVERVIEW', _buildOverview(movie)),
                      const SizedBox(height: 24),
                      if (provider.similarMovies.isNotEmpty)
                        _buildSection(
                          'SIMILAR',
                          _buildSimilarMovies(context, provider.similarMovies),
                        ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }


  SliverAppBar _buildAppBar(
    BuildContext context,
    SingleMovie movie,
    MovieDetailsProvider provider,
  ) {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      backgroundColor: _bg,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Consumer<MovieDetailsProvider>(
            builder: (_, p, __) => IconButton(
              icon: Icon(
                p.isFavourite ? Icons.favorite : Icons.favorite_border,
                color: p.isFavourite ? _accent : Colors.white,
                size: 28,
              ),
              onPressed: p.movie != null ? p.toggleFavourite : null,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (movie.backdropPath != null)
              Image.network(
                '$_imgBase/w1280${movie.backdropPath}',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: _surface),
              )
            else
              Container(color: _surface),

            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xFF141414),
                    Colors.transparent,
                    Color(0x88000000),
                  ],
                  stops: [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildInfo(SingleMovie movie) {
    final year = movie.releaseDate?.year.toString() ?? '—';
    final runtime = movie.runtime != null
        ? '${movie.runtime! ~/ 60}h ${movie.runtime! % 60}m'
        : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Poster
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: movie.posterPath != null
              ? Image.network(
                  '$_imgBase/w342${movie.posterPath}',
                  width: 100,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _posterPlaceholder(),
                )
              : _posterPlaceholder(),
        ),
        const SizedBox(width: 16),

        // Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                [year, if (runtime != null) runtime].join(' · '),
                style: const TextStyle(color: _label, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: _accent, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    movie.voteAverage.toStringAsFixed(1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'TMDB',
                    style: TextStyle(color: _label, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _posterPlaceholder() => Container(
        width: 100,
        height: 150,
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.movie, color: Colors.white24, size: 40),
      );


  Widget _buildGenreChips(List<Genre> genres) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: genres
          .map(
            (g) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                g.name,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          )
          .toList(),
    );
  }


  Widget _buildActionButtons(MovieDetailsProvider provider) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.play_circle_outline,
            label: 'Watch Now',
            active: provider.isWatchNow,
            onTap: provider.movie != null ? provider.toggleWatchNow : null,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ActionButton(
            icon: Icons.bookmark_border,
            activeIcon: Icons.bookmark,
            label: 'Watch Later',
            active: provider.isWatchLater,
            onTap: provider.movie != null ? provider.toggleWatchLater : null,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ActionButton(
            icon: Icons.check_circle_outline,
            activeIcon: Icons.check_circle,
            label: 'Watched',
            active: provider.isWatched,
            onTap: provider.movie != null ? provider.toggleWatched : null,
          ),
        ),
      ],
    );
  }


  Widget _buildOverview(SingleMovie movie) {
    final text = (movie.overview?.isNotEmpty == true)
        ? movie.overview!
        : 'No overview available.';
    return Text(
      text,
      style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.6),
    );
  }


  Widget _buildSimilarMovies(BuildContext context, List<Result> movies) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final m = movies[index];
          return GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MovieDetailsScreen(movieId: m.id!),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: m.posterPath != null
                  ? Image.network(
                      '$_imgBase/w185${m.posterPath}',
                      width: 100,
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _similarPlaceholder(),
                    )
                  : _similarPlaceholder(),
            ),
          );
        },
      ),
    );
  }

  Widget _similarPlaceholder() => Container(
        width: 100,
        height: 160,
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.movie, color: Colors.white24, size: 32),
      );


  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _label,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        content,
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  static const Color _accent = Color(0xFFFFB800);

  const _ActionButton({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.active,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: active ? _accent : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: active ? null : Border.all(color: Colors.white12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              active ? (activeIcon ?? icon) : icon,
              color: active ? Colors.black : Colors.white70,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.black : Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}