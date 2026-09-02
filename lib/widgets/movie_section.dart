import 'package:flutter/material.dart';
import '../models/movies.dart';
import 'movie_card.dart';

class MovieSection extends StatelessWidget {
  final String title;
  final Movies? movies;
  final VoidCallback? onSeeAll;
  final void Function(Result movie)? onMovieTap;

  const MovieSection({
    super.key,
    required this.title,
    required this.movies,
    this.onSeeAll,
    this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    final results = movies?.results ?? [];
    if (results.isEmpty) return const SizedBox();

    final displayed = results.take(12).toList();

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
              if (onSeeAll != null)
                GestureDetector(
                  onTap: onSeeAll,
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
            itemCount: displayed.length,
            itemBuilder: (context, index) {
              final movie = displayed[index];
              return MovieCard(
                movie: movie,
                onTap: onMovieTap != null ? () => onMovieTap!(movie) : null,
              );
            },
          ),
        ),
      ],
    );
  }
}