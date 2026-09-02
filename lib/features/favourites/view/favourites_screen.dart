import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/models/movie_record.dart';
import 'package:flutter_application_2/core/theme/app_colors.dart';
import 'package:flutter_application_2/widgets/app_bottom_nav_bar.dart';
import 'package:flutter_application_2/widgets/movie_card.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      bottomNavigationBar: const AppBottomNavBar(
        currentIndex: NavIndex.favourites,
      ),
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
        child: CircularProgressIndicator(color: AppColors.accent),
      );
    }

    if (provider.state == FavouritesState.error) {
      return Center(
        child: Text(
          provider.errorMessage ?? 'Something went wrong.',
          style: const TextStyle(color: Colors.white54),
          textAlign: TextAlign.center,
        ),
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
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.bookmark_border,
                color: Colors.white38,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No favourites yet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Movies you mark as favourite will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.accent,
                side: const BorderSide(color: AppColors.accent),
                padding: const EdgeInsets.symmetric(
                  horizontal: 36,
                  vertical: 14,
                ),
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
      itemBuilder: (context, index) => MovieCard.fromRecord(movies[index]),
    );
  }
}
