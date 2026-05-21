import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitbody/core/constants/colors.dart';
import 'package:fitbody/features/auth/presentation/providers/user_provider.dart';
import 'package:fitbody/services/storage_service.dart';
import 'package:fitbody/widgets/common/bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = '';
  String _userEmail = '';
  String _userDob = '';
  String _profileImagePath = '';
  int _currentNavIndex = 3;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final storage = await StorageService.getInstance();
    if (mounted) {
      setState(() {
        _userName = storage.getString('signup_name') ?? '';
        _userEmail = storage.getString('signup_email') ?? '';
        _userDob = storage.getString('user_dob') ?? '';
        _profileImagePath = storage.getString('signup_profile_image') ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildBannerSection(size, colors),
              SizedBox(height: size.height * 0.08),
              _buildMenuButtons(size, colors),
              SizedBox(height: size.height * 0.02),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (index) => setState(() => _currentNavIndex = index),
      ),
    );
  }

  Widget _buildBannerSection(Size size, AppColorScheme colors) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: size.height * 0.02,
            bottom: size.height * 0.08,
          ),
          color: colors.primary,
          child: Column(
            children: [
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
                      'My Profile',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: size.width * 0.055,
                        fontWeight: FontWeight.w600,
                        color: colors.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.001),
              CircleAvatar(
                radius: size.width * 0.15,
                backgroundColor: colors.cardBackground,
                backgroundImage: _profileImagePath.isNotEmpty
                    ? FileImage(File(_profileImagePath))
                    : const AssetImage('assets/images/women.png') as ImageProvider,
              ),
              Text(
                _userName,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: size.width * 0.055,
                  fontWeight: FontWeight.bold,
                  color: colors.onPrimary,
                ),
              ),
              Text(
                _userEmail,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: size.width * 0.03,
                  color: colors.onPrimary,
                ),
              ),
              Text.rich(
                TextSpan(
                  text: 'Birthday: ',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: size.width * 0.03,
                    color: colors.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: _userDob.isNotEmpty ? _formatDob(_userDob) : 'Not set',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: size.width * 0.03,
                        color: colors.onPrimary,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: size.width * 0.05,
          right: size.width * 0.05,
          bottom: -size.height * 0.04,
          child: _buildStatsCard(size, colors),
        ),
      ],
    );
  }

  String _formatDob(String dob) {
    final parts = dob.split('/');
    if (parts.length != 3) return dob;
    try {
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
      if (month < 1 || month > 12) return dob;
      String suffix = 'th';
      if (day == 1 || day == 21 || day == 31) suffix = 'st';
      else if (day == 2 || day == 22) suffix = 'nd';
      else if (day == 3 || day == 23) suffix = 'rd';
      return '${months[month - 1]} $day$suffix';
    } catch (_) {
      return dob;
    }
  }

  int _calculateAge(String dob) {
    final parts = dob.split('/');
    if (parts.length != 3) return 0;
    try {
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final birthDate = DateTime(year, month, day);
      final today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (_) {
      return 0;
    }
  }

  Widget _buildStatsCard(Size size, AppColorScheme colors) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;
    final weight = user?.weight ?? 0;
    final age = _userDob.isNotEmpty ? _calculateAge(_userDob) : (user?.age ?? 0);
    final height = user?.height ?? 0;

    return Container(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
      decoration: BoxDecoration(
        color: colors.statusCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _buildStatItem('${weight.toInt()} kg', 'Weight', size, colors)),
          Container(width: 1, height: size.height * 0.05, color: colors.onSurface),
          Expanded(child: _buildStatItem('$age', 'Years old', size, colors)),
          Container(width: 1, height: size.height * 0.05, color: colors.onSurface),
          Expanded(child: _buildStatItem('${height.toInt()} cm', 'Height', size, colors)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Size size, AppColorScheme colors) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'LeagueSpartan',
            fontSize: size.width * 0.04,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        SizedBox(height: size.height * 0.001),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'LeagueSpartan',
            fontSize: size.width * 0.04,
            color: colors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButtons(Size size, AppColorScheme colors) {
    final menuItems = <Map<String, dynamic>>[
      {'icon': 'assets/images/profile.png', 'label': 'Profile'},
      {'icon': 'assets/images/favourites.png', 'label': 'Favourites'},
      {'icon': 'assets/images/lock.png', 'label': 'Privacy Policy'},
      {'icon': 'assets/images/corgs.png', 'label': 'Settings'},
      {'icon': 'assets/images/Support & Help.png', 'label': 'Help'},
      {'icon': 'assets/images/logout.png', 'label': 'Logout'},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        children: menuItems.asMap().entries.map((entry) {
          return _buildMenuItem(entry.value['icon'] as String, entry.value['label'] as String, size, colors);
        }).toList(),
      ),
    );
  }

  Widget _buildMenuItem(String icon, String label, Size size, AppColorScheme colors) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          switch (label) {
            case 'Profile':
              Navigator.of(context).pushNamed('/update-profile').then((_) => _loadUserData());
              break;
            case 'Favourites':
              Navigator.of(context).pushNamed('/favourites');
              break;
            case 'Logout':
              _handleLogout();
              break;
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.04,
            vertical: size.height * 0.01,
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
                'assets/images/right_arrow.png',
                color: colors.secondary,
                width: size.width * 0.04,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogout() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final size = MediaQuery.of(context).size;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.all(size.width * 0.14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you sure you want to',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'LeagueSpartan',
                fontSize: size.width * 0.045,
                color: colors.surface,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'log out?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'LeagueSpartan',
                fontSize: size.width * 0.045,
                color: colors.surface,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: size.height * 0.04),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: size.height * 0.04,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.onPrimary,
                        foregroundColor: colors.primary,
                        side: BorderSide(color: colors.textPrimary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.04),
                Expanded(
                  child: SizedBox(
                    height: size.height * 0.04,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.secondary,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text('Yes, logout'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
