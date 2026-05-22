import 'package:flutter/material.dart';
import 'package:fitbody/core/constants/colors.dart';
import 'package:fitbody/widgets/common/bottom_nav_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _currentNavIndex = 3;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final size = MediaQuery.sizeOf(context);

    final menuItems = [
      {'icon': 'assets/images/Notifications.png', 'label': 'Notification setting', 'route': '/notification-settings'},
      {'icon': 'assets/images/Key.png', 'label': 'Password setting', 'route': '/password-settings'},
      {'icon': 'assets/images/profile.png', 'label': 'Delete Account'},
    ];

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Image.asset(
                      'assets/images/left_arrow.png',
                      width: size.width * 0.05,
                      color: colors.secondary,
                    ),
                  ),
                  SizedBox(width: size.width * 0.03),
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: size.width * 0.055,
                      fontWeight: FontWeight.w600,
                      color: colors.statusCard,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.04),
            ...menuItems.map((item) => _buildMenuItem(
              context,
              item['icon'] as String,
              item['label'] as String,
              item['route'],
              size,
              colors,
            )),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (index) => setState(() => _currentNavIndex = index),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String icon, String label, String? route, Size size, AppColorScheme colors) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (route != null) {
            Navigator.of(context).pushNamed(route);
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.04,
            vertical: size.height * 0.018,
          ),
          child: Row(
            children: [
              Container(
                width: size.width * 0.09,
                height: size.width * 0.09,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.statusCard,
                ),
                child: Image.asset(icon, color: colors.onPrimary, width: size.width * 0.045),
              ),
              SizedBox(width: size.width * 0.04),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'LeagueSpartan',
                    fontSize: size.width * 0.05,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              Image.asset(
                'assets/images/downward_arrow.png',
                color: colors.secondary,
                width: size.width * 0.06,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
