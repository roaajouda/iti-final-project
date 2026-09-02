import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/models/movie_record.dart';
import 'package:flutter_application_2/core/models/movies.dart';
import 'package:flutter_application_2/core/navigation/app_navigation.dart';
import 'package:flutter_application_2/core/theme/app_colors.dart';


class MovieCard extends StatelessWidget {
  final int id;
  final String title;
  final String? posterPath;
  final double? voteAverage; 

  const MovieCard({
    super.key,
    required this.id,
    required this.title,
    this.posterPath,
    this.voteAverage,
  });
  factory MovieCard.fromResult(Result movie) => MovieCard(
        id: movie.id!,
        title: movie.title ?? '',
        posterPath: movie.posterPath,
        voteAverage: movie.voteAverage,
      );

  factory MovieCard.fromRecord(MovieRecord movie) => MovieCard(
        id: movie.id,
        title: movie.title,
        posterPath: movie.posterPath,
      );


  static String posterUrl(String? path) {
    if (path == null || path.isEmpty) {
      return 'https://via.placeholder.com/500x750';
    }
    return 'https://image.tmdb.org/t/p/w500$path';
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.goToMovieDetails(id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                posterUrl(posterPath),
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.surface,
                  child: const Center(
                    child:
                        Icon(Icons.movie_outlined, color: Colors.white24, size: 32),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 7),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),

          if (voteAverage != null) ...[
            const SizedBox(height: 3),
            Row(
              children: [
                const Icon(Icons.star, color: AppColors.accent, size: 13),
                const SizedBox(width: 3),
                Text(
                  voteAverage!.toStringAsFixed(1),
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}