import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/theme/app_colors.dart';
import 'package:flutter_application_2/widgets/app_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../provider/profile_provider.dart';
import '../../auth/view/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileProvider()..loadProfile(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      bottomNavigationBar: const AppBottomNavBar(
        currentIndex: NavIndex.profile,
      ),
      body: SafeArea(
        child: Consumer<ProfileProvider>(
          builder: (context, provider, _) {
            if (provider.state == ProfileState.loading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.accent),
              );
            }
            if (provider.state == ProfileState.error) {
              return Center(
                child: Text(
                  provider.errorMessage ?? 'Something went wrong.',
                  style: const TextStyle(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAvatar(provider),
                  const SizedBox(height: 28),
                  _buildStats(provider),
                  const SizedBox(height: 32),
                  _buildLogoutButton(context, provider),
                  const SizedBox(height: 20),
                  _buildFooter(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAvatar(ProfileProvider provider) {
    final initial = provider.name.isNotEmpty
        ? provider.name[0].toUpperCase()
        : 'U';

    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.accentDark,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.4),
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            initial,
            style: const TextStyle(
              color: AppColors.accent,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              provider.name,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              provider.email,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStats(ProfileProvider provider) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            count: provider.favouritesCount,
            label: 'FAVOURITES',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(count: provider.watchedCount, label: 'WATCHED'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            count: provider.wantToWatchCount,
            label: 'WANT TO WATCH',
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context, ProfileProvider provider) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () => _confirmLogout(context, provider),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.dangerDark,
          foregroundColor: AppColors.danger,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Log out',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.danger,
          ),
        ),
      ),
    );
  }

  Future<void> _confirmLogout(
    BuildContext context,
    ProfileProvider provider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Log out?',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'You will be returned to the login screen.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Log out',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await provider.logout();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }

  Widget _buildFooter() {
    return const Center(
      child: Text(
        'Reel v1.0  ·  TMDB  ·  Firebase',
        style: TextStyle(color: AppColors.textMuted, fontSize: 12),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final int count;
  final String label;

  const _StatCard({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$count',
            style: const TextStyle(
              color: AppColors.accent,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
