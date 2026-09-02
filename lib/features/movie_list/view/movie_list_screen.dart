import 'package:flutter/material.dart';
import 'package:flutter_application_2/features/movie_list/provider/movie_list_provider.dart';
import 'package:flutter_application_2/core/models/movies.dart';
import 'package:flutter_application_2/widgets/movie_list_item.dart';
import 'package:provider/provider.dart';

class MovieListScreen extends StatelessWidget {
  final String title;
  final Future<Movies> Function(int page) fetcher;

  const MovieListScreen({
    super.key,
    required this.title,
    required this.fetcher,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MovieListProvider(fetcher: fetcher)..loadInitial(),
      child: _MovieListView(title: title),
    );
  }
}


class _MovieListView extends StatelessWidget {
  final String title;

  const _MovieListView({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<MovieListProvider>(
        builder: (context, provider, _) {
          if (provider.state == MovieListState.loading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xffffc107)),
            );
          }

          if (provider.state == MovieListState.error &&
              provider.movies.isEmpty) {
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
                    onPressed: provider.loadInitial,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 32),
            itemCount: provider.movies.length + 1, 
            itemBuilder: (context, index) {
              if (index < provider.movies.length) {
                return MovieListItem(movie: provider.movies[index]);
              }
              return _buildFooter(context, provider);
            },
          );
        },
      ),
    );
  }

  Widget _buildFooter(BuildContext context, MovieListProvider provider) {
    if (provider.state == MovieListState.loadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: CircularProgressIndicator(color: Color(0xffffc107)),
        ),
      );
    }

    if (provider.state == MovieListState.error &&
        provider.movies.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          children: [
            Text(
              provider.errorMessage ?? 'Something went wrong.',
              style: const TextStyle(color: Color(0xff777272)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xffffc107),
                side: const BorderSide(color: Color(0xffffc107)),
              ),
              onPressed: () => context.read<MovieListProvider>().loadMore(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (!provider.hasMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            "You've reached the end",
            style: TextStyle(color: Color(0xff777272), fontSize: 13),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffffc107),
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => context.read<MovieListProvider>().loadMore(),
        child: const Text(
          'Load More',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }
}