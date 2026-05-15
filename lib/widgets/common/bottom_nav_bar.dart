import 'package:flutter/material.dart';
import 'package:fitbody/core/constants/strings.dart';

enum BottomNavItem {
  home(icon: Icons.home_outlined, activeIcon: Icons.home, label: AppStrings.home),
  workouts(icon: Icons.fitness_center_outlined, activeIcon: Icons.fitness_center, label: AppStrings.workouts),
  progress(icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart, label: AppStrings.progress),
  profile(icon: Icons.person_outline, activeIcon: Icons.person, label: AppStrings.profile);

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
    final items = BottomNavItem.values;
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
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
