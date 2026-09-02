import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/exceptions/app_exception.dart';
import 'package:flutter_application_2/core/services/api_service.dart';
import 'package:flutter_application_2/models/movies.dart';

enum MovieListType {
  categoryPopular,
  categoryTopRated,
  categoryLatest,
}

class MovieListScreen extends StatefulWidget {
  final String title;
  final int categoryId;
  final MovieListType type;

  const MovieListScreen({
    super.key,
    required this.title,
    required this.categoryId,
    required this.type,
  });

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final APIService _apiService = APIService();

  final ScrollController _scrollController = ScrollController();

  final List<Result> _movies = [];

  int _currentPage = 1;

  bool _isLoading = false;
  bool _hasMore = true;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    _loadMovies();
  }

  Future<void> _loadMovies() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      late Movies response;

      switch (widget.type) {
        case MovieListType.categoryPopular:
          response = await _apiService
              .getMostPopularMoviesBasedOnCategory(
            widget.categoryId,
            _currentPage,
          );
          break;

        case MovieListType.categoryTopRated:
          response = await _apiService
              .getTopRatedMoviesBasedOnCategory(
            widget.categoryId,
            _currentPage,
          );
          break;

        case MovieListType.categoryLatest:
          response = await _apiService
              .getLatestMoviesBasedOnCategory(
            widget.categoryId,
            _currentPage,
          );
          break;
      }

      setState(() {
        _movies.addAll(response.results);

        if (_currentPage >= response.totalPages) {
          _hasMore = false;
        } else {
          _currentPage++;
        }

        _isLoading = false;
      });
    } on AppException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Something went wrong.';
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      _loadMovies();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0B0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xff0B0A0A),
        foregroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_movies.isEmpty && _isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_movies.isEmpty && _errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        childAspectRatio: 0.62,
      ),
      itemCount: _movies.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _movies.length) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return _buildMovieCard(_movies[index]);
      },
    );
  }

  Widget _buildMovieCard(Result movie) {
    final imageUrl =
        'https://image.tmdb.org/t/p/w500${movie.posterPath}';

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            color: const Color(0xff1A1818),
            child: const Icon(
              Icons.movie_outlined,
              color: Colors.grey,
              size: 40,
            ),
          );
        },
      ),
    );
  }
}