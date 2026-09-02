import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/models/movies.dart';
import 'package:flutter_application_2/core/models/single_movie.dart';
import 'package:flutter_application_2/features/category/view/category_screen.dart';
import 'package:flutter_application_2/features/favourites/view/favourites_screen.dart';
import 'package:flutter_application_2/features/movie-details/view/movie_details_screen.dart';
import 'package:flutter_application_2/features/movie_list/view/movie_list_screen.dart';
import 'package:flutter_application_2/features/my_lists/view/my_lists_screen.dart';
import 'package:flutter_application_2/features/profile/view/profile_screen.dart';
import 'package:flutter_application_2/features/search/view/search_screen.dart';

extension AppNavigator on BuildContext {
  void goToMovieDetails(int movieId) {
    Navigator.of(this).push(
      MaterialPageRoute(builder: (_) => MovieDetailsScreen(movieId: movieId)),
    );
  }

  void goToMovieList(String title, Future<Movies> Function(int page) fetcher) {
    Navigator.of(this).push(
      MaterialPageRoute(
        builder: (_) => MovieListScreen(title: title, fetcher: fetcher),
      ),
    );
  }

  void goToCategory(Genre genre) {
    Navigator.of(this).push(
      MaterialPageRoute(
        builder: (_) =>
            CategoryScreen(genreId: genre.id, genreName: genre.name ?? " "),
      ),
    );
  }

  void goToSearch() {
    Navigator.of(this)
        .push(MaterialPageRoute(builder: (_) => const SearchScreen()));
  }

  void goToFavourites() {
    Navigator.of(this)
        .push(MaterialPageRoute(builder: (_) => const FavouritesScreen()));
  }

  void goToMyLists() {
    Navigator.of(this)
        .push(MaterialPageRoute(builder: (_) => const MyListsScreen()));
  }

  void goToProfile() {
    Navigator.of(this)
        .push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
  }
}
