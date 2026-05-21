import 'package:flutter/material.dart';
import 'package:fitbody/core/constants/colors.dart';

enum BottomNavItem {
  home(imagePath: 'assets/images/home.png'),
  library(imagePath: 'assets/images/resources.png'),
  favourites(imagePath: 'assets/images/favourites.png'),
  support(imagePath: 'assets/images/Support & Help.png');

  final String imagePath;

  const BottomNavItem({
    required this.imagePath,
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

    return BottomAppBar(
      height: 50,
      color: colors.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = index == currentIndex;
          return GestureDetector(
            onTap: () => onTap(index),
            child: SizedBox(
              width: 48,
              height: 48,
              child: IconTheme(
                data: const IconThemeData(size: 30),
                child: ImageIcon(
                  AssetImage(item.imagePath),
                  color: isSelected ? colors.surface : colors.onPrimary,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
