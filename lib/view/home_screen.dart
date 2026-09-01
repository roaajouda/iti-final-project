import 'package:flutter/material.dart';
import 'package:flutter_application_2/features/auth/provider/auth_provider.dart';
import 'package:flutter_application_2/features/home/provider/home_provider.dart';
import 'package:provider/provider.dart';

import '../models/movies.dart';

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
      final provider = context.read<HomeProvider>();
      final authProvider = context.read<AuthProvider>();

      authProvider.loadUser();
      provider.getHomeMovies();
      provider.getGenres();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0B0A0A),
      body: SafeArea(
        child: Consumer2<HomeProvider, AuthProvider>(
          builder: (context, provider, authProvider, child) {
            if (provider.state == MovieState.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.state == MovieState.error) {
              return Center(
                child: Text(
                  provider.errorMessage ?? 'Something went wrong.',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(authProvider),
                  _buildSearchBar(),

                  const SizedBox(height: 18),

                  _buildCategories(provider),

                  const SizedBox(height: 20),

                  _buildNowPlaying(provider),

                  const SizedBox(height: 25),

                  _buildMovieSection(
                    title: 'Popular',
                    movies: provider.popularMovies,
                  ),

                  const SizedBox(height: 25),

                  _buildMovieSection(
                    title: 'Top Rated',
                    movies: provider.topRatedMovies,
                  ),

                  const SizedBox(height: 25),

                  _buildMovieSection(
                    title: 'Upcoming',
                    movies: provider.upcomingMovies,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // =========================
  // Header
  // =========================

  Widget _buildHeader(AuthProvider authProvider) {
    final name = authProvider.userName ?? 'User';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'GOOD EVENING',
                  style: TextStyle(
                    color: Color(0xff9E9E9E),
                    fontSize: 10,
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xff1A1818),
              border: Border.all(color: const Color(0xff353232)),
            ),
            alignment: Alignment.center,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'U',
              style: const TextStyle(
                color: Color(0xffffc107),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // Search
  // =========================

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search movies',
          hintStyle: const TextStyle(color: Color(0xff777272)),
          prefixIcon: const Icon(Icons.search, color: Color(0xff777272)),
          filled: true,
          fillColor: const Color(0xff151313),
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(color: Color(0xff302D2D)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(color: Color(0xff302D2D)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(color: Color(0xffffc107)),
          ),
        ),
      ),
    );
  }

  // =========================
  // Categories
  // =========================

  Widget _buildCategories(HomeProvider provider) {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: provider.genres.length,
        itemBuilder: (context, index) {
          final genre = provider.genres[index];

          return GestureDetector(
            onTap: () {
              // لاحقًا:
              // Navigator.push(...)
              // إلى CategoryScreen
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xff191717),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xff302D2D)),
              ),
              child: Text(
                genre.name,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          );
        },
      ),
    );
  }

  // =========================
  // Now Playing
  // =========================

  Widget _buildNowPlaying(HomeProvider provider) {
    final movies = provider.nowPlayingMovies?.results ?? [];

    if (movies.isEmpty) {
      return const SizedBox();
    }

    final movie = movies.first;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            SizedBox(
              height: 220,
              width: double.infinity,
              child: Image.network(
                _backdropUrl(movie.backdropPath),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: const Color(0xff201D1A));
                },
              ),
            ),

            Container(
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.9),
                  ],
                ),
              ),
            ),

            Positioned(
              left: 16,
              bottom: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Text(
                      'NOW PLAYING',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 9),

                  Text(
                    movie.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xffffc107),
                        size: 15,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        movie.voteAverage.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _getYear(movie.releaseDate),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // Movie Section
  // =========================

  Widget _buildMovieSection({required String title, required Movies? movies}) {
    final results = movies?.results ?? [];

    if (results.isEmpty) {
      return const SizedBox();
    }

    final displayedMovies = results.take(12).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {
                  // لاحقًا:
                  // Navigator.push(...)
                  // إلى الصفحة الخاصة بالـsection
                },
                child: const Text(
                  'See all',
                  style: TextStyle(color: Color(0xff8E8989), fontSize: 10),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        SizedBox(
          height: 245,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: displayedMovies.length,
            itemBuilder: (context, index) {
              return _buildMovieCard(displayedMovies[index]);
            },
          ),
        ),
      ],
    );
  }

  // =========================
  // Movie Card
  // =========================

  Widget _buildMovieCard(Result movie) {
    return GestureDetector(
      onTap: () {
        // لاحقًا:
        // Navigator.push(...)
        // إلى MovieDetailsScreen(movieId: movie.id)
      },
      child: Container(
        width: 108,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 108,
                height: 165,
                child: Image.network(
                  _posterUrl(movie.posterPath),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xff201D1A),
                      child: const Center(
                        child: Icon(
                          Icons.movie_outlined,
                          color: Colors.white24,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 7),

            Text(
              movie.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 4),

            Row(
              children: [
                const Icon(Icons.star, color: Color(0xffffc107), size: 13),
                const SizedBox(width: 3),
                Text(
                  movie.voteAverage.toStringAsFixed(1),
                  style: const TextStyle(
                    color: Color(0xffffc107),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // Bottom Navigation
  // =========================

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xff0F0E0E),
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      selectedItemColor: const Color(0xffffc107),
      unselectedItemColor: const Color(0xff777272),
      selectedFontSize: 9,
      unselectedFontSize: 9,
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
          label: 'Saved',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }

  // =========================
  // Helpers
  // =========================

  String _posterUrl(String? path) {
    if (path == null || path.isEmpty) {
      return 'https://via.placeholder.com/500x750';
    }

    return 'https://image.tmdb.org/t/p/w500$path';
  }

  String _backdropUrl(String? path) {
    if (path == null || path.isEmpty) {
      return 'https://via.placeholder.com/1280x720';
    }

    return 'https://image.tmdb.org/t/p/w780$path';
  }

  String _getYear(DateTime? date) {
    if (date == null) {
      return '';
    }

    return date.year.toString();
  }
}
