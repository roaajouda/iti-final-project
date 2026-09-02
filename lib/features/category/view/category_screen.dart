import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/navigation/app_navigation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_2/core/theme/app_colors.dart';
import 'package:flutter_application_2/features/category/provider/category_provider.dart';
import 'package:flutter_application_2/widgets/app_bottom_nav_bar.dart';
import 'package:flutter_application_2/widgets/app_search_bar.dart';
import 'package:flutter_application_2/widgets/movie_section.dart';

class CategoryScreen extends StatelessWidget {
  final int genreId;
  final String genreName;

  const CategoryScreen({
    super.key,
    required this.genreId,
    required this.genreName,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoryProvider()..loadCategory(genreId),
      child: _CategoryView(genreId: genreId, genreName: genreName),
    );
  }
}

class _CategoryView extends StatelessWidget {
  final int genreId;
  final String genreName;

  const _CategoryView({required this.genreId, required this.genreName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(genreName),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: NavIndex.none),
      body: Consumer<CategoryProvider>(
        builder: (context, provider, _) {
          if (provider.state == CategoryState.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }

          if (provider.state == CategoryState.error) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Something went wrong.',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadCategory(genreId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                const AppSearchBar(margin: EdgeInsets.fromLTRB(16, 12, 16, 4)),
                MovieSection(
                  title: 'Most Popular',
                  movies: provider.mostPopular,
                  onSeeAll: () => context.goToMovieList(
                    'Most Popular — $genreName',
                    (page) => provider.fetchMostPopularPage(genreId, page),
                  ),
                ),
                MovieSection(
                  title: 'Top Rated',
                  movies: provider.topRated,
                  onSeeAll: () => context.goToMovieList(
                    'Top Rated — $genreName',
                    (page) => provider.fetchTopRatedPage(genreId, page),
                  ),
                ),
                MovieSection(
                  title: 'Latest Releases',
                  movies: provider.latest,
                  onSeeAll: () => context.goToMovieList(
                    'Latest — $genreName',
                    (page) => provider.fetchLatestPage(genreId, page),
                  ),
                ),
                MovieSection(
                  title: 'All $genreName',
                  movies: provider.all,
                  onSeeAll: () => context.goToMovieList(
                    'All $genreName',
                    (page) => provider.fetchAllPage(genreId, page),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}