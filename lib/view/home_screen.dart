import 'package:flutter/material.dart';
import 'package:flutter_application_2/features/auth/provider/auth_provider.dart';
import 'package:flutter_application_2/features/category/provider/category_provider.dart';
import 'package:flutter_application_2/features/category/view/category_screen.dart';
import 'package:flutter_application_2/features/favourites/view/favourites_screen.dart';
import 'package:flutter_application_2/features/home/provider/home_provider.dart';
import 'package:flutter_application_2/features/movie_list/view/movie_list_screen.dart';
import 'package:flutter_application_2/models/movies.dart';
import 'package:flutter_application_2/models/single_movie.dart';
import 'package:flutter_application_2/widgets/movie_section.dart';
import 'package:flutter_application_2/widgets/now_playing_banner.dart';
import 'package:provider/provider.dart';

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


  void _goToMovieList(String title, Future<Movies> Function(int page) fetcher) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MovieListScreen(title: title, fetcher: fetcher),
      ),
    );
  }

  void _goToCategory(Genre genre) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => CategoryProvider(),
          child: CategoryScreen(genre: genre),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: _buildBottomNavBar(),
      body: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          if (provider.state == HomeState.loading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xffffc107)),
            );
          }

          if (provider.state == HomeState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.errorMessage ?? 'Something went wrong.',
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffffc107),
                      foregroundColor: Colors.black,
                    ),
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
                  _buildHeader(),
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  _buildGenreChips(provider.genres),
                  const SizedBox(height: 8),
                  NowPlayingBanner(movies: provider.nowPlayingMovies),
                  MovieSection(
                    title: 'Most Popular',
                    movies: provider.popularMovies,
                    onSeeAll: () => _goToMovieList(
                      'Most Popular',
                      provider.fetchPopularPage,
                    ),
                  ),
                  MovieSection(
                    title: 'Top Rated',
                    movies: provider.topRatedMovies,
                    onSeeAll: () =>
                        _goToMovieList('Top Rated', provider.fetchTopRatedPage),
                  ),
                  MovieSection(
                    title: 'Upcoming',
                    movies: provider.upcomingMovies,
                    onSeeAll: () =>
                        _goToMovieList('Upcoming', provider.fetchUpcomingPage),
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


  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          final name = auth.getUserName() ?? 'User';
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'What do you want',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'to watch today?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xffffc107),
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {},
      child: AbsorbPointer(
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Icon(Icons.search, color: Colors.white38, size: 20),
              SizedBox(width: 10),
              Text('Search TMDB...', style: TextStyle(color: Colors.white38)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenreChips(List<Genre> genres) {
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
            onTap: () => _goToCategory(genre),
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

  void _onBottomNavTap(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        break;

      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        break;

      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        break;

      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FavouritesScreen()),
        );
        break;

      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        break;
    }
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xff0F0E0E),
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      selectedItemColor: const Color(0xffffc107),
      unselectedItemColor: const Color(0xff777272),
      selectedFontSize: 9,
      unselectedFontSize: 9,
      onTap: _onBottomNavTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt_outlined),
          label: 'Lists',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_border),
          label: 'Favourites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}
