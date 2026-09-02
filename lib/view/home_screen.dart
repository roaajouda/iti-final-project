import 'package:flutter/material.dart';
import 'package:flutter_application_2/features/auth/provider/auth_provider.dart';
import 'package:flutter_application_2/features/category/provider/category_provider.dart';
import 'package:flutter_application_2/features/category/view/category_screen.dart';
import 'package:flutter_application_2/features/home/provider/home_provider.dart';
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
      context.read<HomeProvider>().getHomeMovies();
      context.read<HomeProvider>().getGenres();
      context.read<AuthProvider>().loadUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0B0A0A),
      body: SafeArea(
        child: Consumer2<HomeProvider, AuthProvider>(
          builder: (context, provider, authProvider, _) {
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

                  NowPlayingBanner(
                    movies: provider.nowPlayingMovies,
                    onTap: (movie) {
                      // Navigator.push to MovieDetailsScreen(movieId: movie.id)
                    },
                  ),

                  const SizedBox(height: 25),

                  MovieSection(
                    title: 'Popular',
                    movies: provider.popularMovies,
                    onMovieTap: (movie) {
                      // Navigator.push to MovieDetailsScreen(movieId: movie.id)
                    },
                  ),

                  const SizedBox(height: 25),

                  MovieSection(
                    title: 'Top Rated',
                    movies: provider.topRatedMovies,
                    onMovieTap: (movie) {
                      // Navigator.push to MovieDetailsScreen(movieId: movie.id)
                    },
                  ),

                  const SizedBox(height: 25),

                  MovieSection(
                    title: 'Upcoming',
                    movies: provider.upcomingMovies,
                    onMovieTap: (movie) {
                      // Navigator.push to MovieDetailsScreen(movieId: movie.id)
                    },
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
                      color: Color(0xff9E9E9E), fontSize: 10, letterSpacing: 2),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold),
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
                  color: Color(0xffffc107), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (_) => CategoryProvider(),
                    child: CategoryScreen(genre: genre),
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xff191717),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xff302D2D)),
              ),
              child: Text(
                genre.name,
                style:
                    const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          );
        },
      ),
    );
  }

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
            label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined), label: 'Search'),
        BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined), label: 'Lists'),
        BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border), label: 'Saved'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}