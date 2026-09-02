import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/navigation/app_navigation.dart';
import 'package:flutter_application_2/core/theme/app_colors.dart';

class AppSearchBar extends StatelessWidget {
  final String hint;
  final EdgeInsetsGeometry margin;

  const AppSearchBar({
    super.key,
    this.hint = 'Search TMDB...',
    this.margin = const EdgeInsets.fromLTRB(16, 16, 16, 0),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.goToSearch(),
      child: AbsorbPointer(
        child: Container(
          margin: margin,
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceHigh,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
              const SizedBox(width: 10),
              Text(
                hint,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}