import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/models/single_movie.dart';
import 'package:flutter_application_2/core/navigation/app_navigation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_2/core/theme/app_colors.dart';
import 'package:flutter_application_2/features/auth/provider/auth_provider.dart';
import 'package:flutter_application_2/features/home/provider/home_provider.dart';
import 'package:flutter_application_2/widgets/app_bottom_nav_bar.dart';
import 'package:flutter_application_2/widgets/app_search_bar.dart';
import 'package:flutter_application_2/widgets/movie_section.dart';
import 'package:flutter_application_2/widgets/now_playing_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadHome();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AppBottomNavBar(currentIndex: NavIndex.home),
      body: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          if (provider.state == HomeState.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }

          if (provider.state == HomeState.error) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline,
                      color: AppColors.textSecondary, size: 48),
                  const SizedBox(height: 12),
                  const Text(
                    'Something went wrong.',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: provider.loadHome,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const AppSearchBar(),
                  const SizedBox(height: 16),
                  _buildGenreChips(context, provider.genres),
                  const SizedBox(height: 8),
                  NowPlayingBanner(
                    movies: provider.nowPlayingMovies,
                    onTap: (movie) => context.goToMovieDetails(movie.id!),
                  ),
                  MovieSection(
                    title: 'Most Popular',
                    movies: provider.popularMovies,
                    onSeeAll: () => context.goToMovieList(
                      'Most Popular',
                      provider.fetchPopularPage,
                    ),
                  ),
                  MovieSection(
                    title: 'Top Rated',
                    movies: provider.topRatedMovies,
                    onSeeAll: () => context.goToMovieList(
                      'Top Rated',
                      provider.fetchTopRatedPage,
                    ),
                  ),
                  MovieSection(
                    title: 'Upcoming',
                    movies: provider.upcomingMovies,
                    onSeeAll: () => context.goToMovieList(
                      'Upcoming',
                      provider.fetchUpcomingPage,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          final name =
              auth.getUserName().isNotEmpty ? auth.getUserName() : 'User';
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What do you want',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'to watch today?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => context.goToProfile(),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.accent,
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGenreChips(BuildContext context, List<Genre> genres) {
    if (genres.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: genres.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final genre = genres[index];
          return GestureDetector(
            onTap: () => context.goToCategory(genre),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xff1a1a1a),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xff302D2D)),
              ),
              child: Text(
                genre.name ?? '',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          );
        },
      ),
    );
  }
}