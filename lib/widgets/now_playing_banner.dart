import 'package:flutter/material.dart';
import '../models/movies.dart';

class NowPlayingBanner extends StatelessWidget {
  final Movies? movies;
  final void Function(Result movie)? onTap;

  const NowPlayingBanner({super.key, required this.movies, this.onTap});

  @override
  Widget build(BuildContext context) {
    final results = movies?.results ?? [];
    if (results.isEmpty) return const SizedBox();

    final movie = results.first;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap != null ? () => onTap!(movie) : null,
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
                  errorBuilder: (_, __, ___) =>
                      Container(color: const Color(0xff201D1A)),
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
                          horizontal: 9, vertical: 5),
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
                        const Icon(Icons.star,
                            color: Color(0xffffc107), size: 15),
                        const SizedBox(width: 4),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(width: 12),
                        if (movie.releaseDate != null)
                          Text(
                            movie.releaseDate!.year.toString(),
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _backdropUrl(String? path) {
    if (path == null || path.isEmpty) {
      return 'https://via.placeholder.com/1280x720';
    }
    return 'https://image.tmdb.org/t/p/w780$path';
  }
}