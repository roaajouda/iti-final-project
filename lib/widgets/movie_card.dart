import 'package:flutter/material.dart';
import '../models/movies.dart';

class MovieCard extends StatelessWidget {
  final Result movie;
  final VoidCallback? onTap;

  const MovieCard({super.key, required this.movie, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xff201D1A),
                    child: const Center(
                      child: Icon(Icons.movie_outlined, color: Colors.white24),
                    ),
                  ),
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

  static String posterUrl(String? path) {
    if (path == null || path.isEmpty) {
      return 'https://via.placeholder.com/500x750';
    }
    return 'https://image.tmdb.org/t/p/w500$path';
  }

  String _posterUrl(String? path) => MovieCard.posterUrl(path);
}