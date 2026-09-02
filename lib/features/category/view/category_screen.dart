import 'package:flutter/material.dart';
import 'package:flutter_application_2/features/category/provider/category_provider.dart';
import 'package:flutter_application_2/features/movie_list/view/movie_list_screen.dart';
import 'package:flutter_application_2/models/movies.dart';
import 'package:flutter_application_2/models/single_movie.dart';
import 'package:flutter_application_2/widgets/movie_section.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  final Genre genre;

  const CategoryScreen({super.key, required this.genre});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().loadCategory(widget.genre.id!);
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

  @override
  Widget build(BuildContext context) {
    final genreId   = widget.genre.id!;
    final genreName = widget.genre.name ?? '';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          genreName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, provider, _) {

          if (provider.state == CategoryState.loading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xffffc107)),
            );
          }

          if (provider.state == CategoryState.error) {
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
                MovieSection(
                  title: 'Most Popular',
                  movies: provider.mostPopular,
                  onSeeAll: () => _goToMovieList(
                    'Most Popular — $genreName',
                    (page) => provider.fetchMostPopularPage(genreId, page),
                  ),
                ),
                MovieSection(
                  title: 'Top Rated',
                  movies: provider.topRated,
                  onSeeAll: () => _goToMovieList(
                    'Top Rated — $genreName',
                    (page) => provider.fetchTopRatedPage(genreId, page),
                  ),
                ),
                MovieSection(
                  title: 'Latest Releases',
                  movies: provider.latest,
                  onSeeAll: () => _goToMovieList(
                    'Latest — $genreName',
                    (page) => provider.fetchLatestPage(genreId, page),
                  ),
                ),
                MovieSection(
                  title: 'All $genreName',
                  movies: provider.all,
                  onSeeAll: () => _goToMovieList(
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