import 'package:flutter/material.dart';
import 'package:flutter_application_2/features/movie-details/view/movie_details_screen.dart';
import 'package:flutter_application_2/models/movie.record.dart';
import 'package:provider/provider.dart';
import '../provider/my_lists_provider.dart';

class MyListsScreen extends StatelessWidget {
  const MyListsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyListsProvider()..loadLists(),
      child: const _MyListsView(),
    );
  }
}

class _MyListsView extends StatelessWidget {
  const _MyListsView();

  static const Color _bg = Color(0xFF141414);
  static const Color _accent = Color(0xFFFFB800);
  static const Color _surface = Color(0xFF2A2A2A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: _bg,
      body: SafeArea(
        child: Consumer<MyListsProvider>(
          builder: (context, provider, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
                  child: Text(
                    'My lists',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Tab chips
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _TabChip(
                        label: 'Watched',
                        active: provider.activeTab == ListTab.watched,
                        onTap: () => provider.setTab(ListTab.watched),
                      ),
                      const SizedBox(width: 8),
                      _TabChip(
                        label: 'Watching',
                        active: provider.activeTab == ListTab.watching,
                        onTap: () => provider.setTab(ListTab.watching),
                      ),
                      const SizedBox(width: 8),
                      _TabChip(
                        label: 'Want to watch',
                        active: provider.activeTab == ListTab.wantToWatch,
                        onTap: () => provider.setTab(ListTab.wantToWatch),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Content
                Expanded(child: _buildBody(context, provider)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, MyListsProvider provider) {
    if (provider.state == MyListsState.loading) {
      return const Center(child: CircularProgressIndicator(color: _accent));
    }

    if (provider.state == MyListsState.error) {
      return const Center(
        child: Text('Failed to load', style: TextStyle(color: Colors.white54)),
      );
    }

    final movies = provider.currentList;

    if (movies.isEmpty) {
      return _buildEmptyState(provider.activeTab);
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 16,
        childAspectRatio: 0.58,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) => _MovieCard(movie: movies[index]),
    );
  }

  Widget _buildEmptyState(ListTab tab) {
    final labels = {
      ListTab.watched: ('check_circle', 'Nothing watched yet',
          'Movies you mark as watched will appear here.'),
      ListTab.watching: ('play_circle', 'Nothing here yet',
          'Movies you are currently watching will appear here.'),
      ListTab.wantToWatch: ('bookmark', 'Nothing saved yet',
          'Movies you want to watch will appear here.'),
    };

    final (_, title, subtitle) = labels[tab]!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFF1F1F1F),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                tab == ListTab.watched
                    ? Icons.check_circle_outline
                    : tab == ListTab.watching
                        ? Icons.play_circle_outline
                        : Icons.bookmark_border,
                color: Colors.white38,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tab chip ──────────────────────────────────────────────────────────────────

class _TabChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  static const Color _accent = Color(0xFFFFB800);

  const _TabChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: active ? _accent : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(24),
          border: active ? null : Border.all(color: Colors.white12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.black : Colors.white60,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// ── Movie card ────────────────────────────────────────────────────────────────

class _MovieCard extends StatelessWidget {
  final MovieRecord movie;
  const _MovieCard({required this.movie});

  static const String _imgBase = 'https://image.tmdb.org/t/p/w342';

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
        decoration: BoxDecoration(
          color: const Color(0xFF1F1F1F),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.movie, color: Colors.white24),
      );
}