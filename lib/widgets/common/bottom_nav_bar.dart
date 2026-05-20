import 'package:flutter/material.dart';
import 'package:fitbody/core/constants/colors.dart';
import 'package:fitbody/core/constants/strings.dart';

enum BottomNavItem {
  home(icon: Icons.home_outlined, activeIcon: Icons.home, label: AppStrings.home),
  library(icon: Icons.video_library_outlined, activeIcon: Icons.video_library, label: AppStrings.library),
  favourites(icon: Icons.star_outline, activeIcon: Icons.star, label: AppStrings.favourites),
  support(icon: Icons.support_outlined, activeIcon: Icons.support, label: AppStrings.support);

  final IconData icon;
  final IconData activeIcon;
  final String label;

  const BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final items = BottomNavItem.values;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: colors.primary,
      selectedItemColor: colors.surface,
      unselectedItemColor: colors.onPrimary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      items: items.map((item) {
        return BottomNavigationBarItem(
          icon: Icon(item.icon),
          activeIcon: Icon(item.activeIcon),
          label: item.label,
        );
      }).toList(),
    );
  }
}
