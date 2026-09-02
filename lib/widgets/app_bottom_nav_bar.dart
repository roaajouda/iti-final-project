import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/navigation/app_navigation.dart';
import 'package:flutter_application_2/core/theme/app_colors.dart';
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavBar({super.key, this.currentIndex = NavIndex.none});

  @override
  Widget build(BuildContext context) {
    final bool hasActive = currentIndex >= 0 && currentIndex <= 4;

    return BottomNavigationBar(
      backgroundColor: const Color(0xFF0F0E0E),
      type: BottomNavigationBarType.fixed,
      currentIndex: hasActive ? currentIndex : 0,
      selectedItemColor: hasActive ? AppColors.accent : AppColors.textMuted,
      unselectedItemColor: AppColors.textMuted,
      selectedFontSize: 9,
      unselectedFontSize: 9,
      onTap: (index) => _onTap(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt_outlined),
          label: 'My Lists',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_border),
          activeIcon: Icon(Icons.bookmark),
          label: 'Favourites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case NavIndex.home:
        Navigator.of(context).popUntil((route) => route.isFirst);
        break;
      case NavIndex.search:
        context.goToSearch();
        break;
      case NavIndex.myLists:
        context.goToMyLists();
        break;
      case NavIndex.favourites:
        context.goToFavourites();
        break;
      case NavIndex.profile:
        context.goToProfile();
        break;
    }
  }
}

abstract class NavIndex {
  static const int home = 0;
  static const int search = 1;
  static const int myLists = 2;
  static const int favourites = 3;
  static const int profile = 4;
  static const int none = -1; 
}