import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/movies.dart';
import 'package:flutter_application_2/widgets/movie_card.dart';

class MovieListItem extends StatelessWidget {
  final Result movie;
  final VoidCallback? onTap;

  const MovieListItem({super.key, required this.movie, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xff1a1a1a),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: movie.posterPath != null
                  ? Image.network(
                      MovieCard.posterUrl(movie.posterPath!),
                      width: 90,
                      height: 130,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    movie.title ?? 'Unknown',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Year + Genre chip
                  Row(
                    children: [
                      if (movie.releaseDate != null)
                        Text(
                          movie.releaseDate!.year.toString(),
                          style: const TextStyle(
                            color: Color(0xff777272),
                            fontSize: 12,
                          ),
                        ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xff2a2a2a),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'drama',
                          style: TextStyle(
                            color: Color(0xff777272),
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Rating
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xffffc107),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        movie.voteAverage?.toStringAsFixed(1) ?? 'N/A',
                        style: const TextStyle(
                          color: Color(0xffffc107),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Overview
                  Text(
                    movie.overview ?? '',
                    style: const TextStyle(
                      color: Color(0xff777272),
                      fontSize: 12,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
    width: 90,
    height: 130,
    decoration: BoxDecoration(
      color: const Color(0xff2a2a2a),
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Icon(Icons.movie, color: Color(0xff777272)),
  );
}
