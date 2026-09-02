import 'package:flutter/material.dart';
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

  static const Color _bg = Color(0xFF141414);
  static const Color _accent = Color(0xFFFFB800);
  static const Color _surface = Color(0xFF1F1F1F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Consumer<ProfileProvider>(
          builder: (context, provider, _) {
            if (provider.state == ProfileState.loading) {
              return const Center(
                child: CircularProgressIndicator(color: _accent),
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
            color: const Color(0xFF3D2E00),
            shape: BoxShape.circle,
            border: Border.all(color: _accent.withOpacity(0.4), width: 2),
          ),
          alignment: Alignment.center,
          child: Text(
            initial,
            style: const TextStyle(
              color: _accent,
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
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              provider.email,
              style: const TextStyle(
                color: Colors.white38,
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
          child: _StatCard(
            count: provider.watchedCount,
            label: 'WATCHED',
          ),
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
          backgroundColor: const Color(0xFF3D0A0A),
          foregroundColor: Colors.redAccent,
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
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }

  Future<void> _confirmLogout(
      BuildContext context, ProfileProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1F1F1F),
        title: const Text('Log out?',
            style: TextStyle(color: Colors.white)),
        content: const Text(
          'You will be returned to the login screen.',
          style: TextStyle(color: Colors.white60),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Log out',
                style: TextStyle(color: Colors.redAccent)),
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
        style: TextStyle(color: Colors.white24, fontSize: 12),
      ),
    );
  }
}


class _StatCard extends StatelessWidget {
  final int count;
  final String label;

  static const Color _accent = Color(0xFFFFB800);
  static const Color _surface = Color(0xFF1F1F1F);

  const _StatCard({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$count',
            style: const TextStyle(
              color: _accent,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white38,
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