import 'package:flutter/material.dart';
import 'package:flutter_application_2/features/category/provider/category_provider.dart';
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
      context.read<CategoryProvider>().loadCategory(widget.genre.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0B0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xff0F0E0E),
        foregroundColor: Colors.white,
        title: Text(
          widget.genre.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, provider, _) {
          if (provider.state == CategoryState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.state == CategoryState.error) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    provider.errorMessage ?? 'Something went wrong.',
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        provider.loadCategory(widget.genre.id),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                MovieSection(
                  title: 'Most Popular',
                  movies: provider.mostPopular,
                  onMovieTap: (movie) {
                    // Navigator.push to MovieDetailsScreen(movieId: movie.id)
                  },
                ),

                const SizedBox(height: 25),

                MovieSection(
                  title: 'Top Rated',
                  movies: provider.topRated,
                  onMovieTap: (movie) {
                    // Navigator.push to MovieDetailsScreen(movieId: movie.id)
                  },
                ),

                const SizedBox(height: 25),

                MovieSection(
                  title: 'Latest Releases',
                  movies: provider.latest,
                  onMovieTap: (movie) {
                    // Navigator.push to MovieDetailsScreen(movieId: movie.id)
                  },
                ),

                const SizedBox(height: 25),

                MovieSection(
                  title: 'All ${widget.genre.name}',
                  movies: provider.allMovies,
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
    );
  }
}