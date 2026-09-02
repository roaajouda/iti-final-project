import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:your_app/models/movies.dart';
import 'package:your_app/widgets/movie_list_item.dart';

class MovieListScreen extends StatefulWidget {
  final String title;
  final Future<Movies> Function(int page) fetcher;

  const MovieListScreen({
    super.key,
    required this.title,
    required this.fetcher,
  });

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  static const _pageSize = 20;

  final PagingController<int, Result> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(_fetchPage);
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final movies = await widget.fetcher(pageKey);
      final newItems = movies.results ?? [];
      final isLastPage = newItems.length < _pageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        _pagingController.appendPage(newItems, pageKey + 1);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PagedListView<int, Result>(
        pagingController: _pagingController,
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        builderDelegate: PagedChildBuilderDelegate<Result>(
          itemBuilder: (context, movie, index) => MovieListItem(
            movie: movie,
            onTap: () {
              // Navigate to MovieDetailsScreen later
            },
          ),
          // Built-in states — no manual handling needed
          firstPageProgressIndicatorBuilder: (_) => const Center(
            child: CircularProgressIndicator(color: Color(0xffffc107)),
          ),
          newPageProgressIndicatorBuilder: (_) => const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: CircularProgressIndicator(color: Color(0xffffc107)),
            ),
          ),
          firstPageErrorIndicatorBuilder: (_) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Something went wrong.',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffffc107),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: _pagingController.retryLastFailedRequest,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          noItemsFoundIndicatorBuilder: (_) => const Center(
            child: Text(
              'No movies found.',
              style: TextStyle(color: Color(0xff777272)),
            ),
          ),
          noMoreItemsIndicatorBuilder: (_) => const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: Text(
                'No more movies',
                style: TextStyle(color: Color(0xff777272)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}