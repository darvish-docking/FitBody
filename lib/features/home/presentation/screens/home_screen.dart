import 'package:flutter/material.dart';
import 'package:fitbody/core/constants/colors.dart';
import 'package:fitbody/services/storage_service.dart';
import 'package:fitbody/widgets/common/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = '';
  int _currentNavIndex = 0;
  int _selectedCategory = 0;
  final Set<int> _favouriteItems = {};
  final Set<int> _favouriteArticles = {};

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final storage = await StorageService.getInstance();
    if (mounted) {
      setState(() {
        _userName = storage.getString('signup_name') ?? '';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.02),
              _buildTopBar(size, colors),
              SizedBox(height: size.height * 0.01),
              _buildDescriptiveText(size, colors),
              SizedBox(height: size.height * 0.01),
              _buildCategorySection(size, colors),
              SizedBox(height: size.height * 0.01),
              _buildSectionHeader('Recommendation', size, colors),
              SizedBox(height: size.height * 0.02),
              _buildRecommendationGrid(size, colors),
              SizedBox(height: size.height * 0.03),
              _buildBanner(size, colors),
              SizedBox(height: size.height * 0.03),
              _buildSectionHeader('Articles & Tips', size, colors,  showSeeAll: false),
              SizedBox(height: size.height * 0.02),
              _buildArticlesGrid(size, colors),
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

  // ─── Top Bar ───────────────────────────────────────────────────────────────

  Widget _buildTopBar(Size size, AppColorScheme colors) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Hi, $_userName',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: size.width * 0.06,
                fontWeight: FontWeight.w600,
                color: colors.statusCard,
              ),
            ),
          ),
          _topBarIcon('assets/images/Search.png', colors, size),
          SizedBox(width: size.width * 0.04),
          _topBarIcon('assets/images/Notifications.png', colors, size),
          SizedBox(width: size.width * 0.04),
          _topBarIcon('assets/images/profile.png', colors, size, onTap: () => Navigator.of(context).pushNamed('/profile')),
        ],
      ),
    );
  }

  Widget _topBarIcon(String imagePath, AppColorScheme colors, Size size, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ImageIcon(AssetImage(imagePath), color: colors.statusCard, size: size.width * 0.06),
    );
  }

  // ─── Descriptive Text ──────────────────────────────────────────────────────

  Widget _buildDescriptiveText(Size size, AppColorScheme colors) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Text(
        "It's time to challenge your limits.",
        style: TextStyle(
          fontFamily: 'LeagueSpartan',
          fontSize: size.width * 0.04,
          color: colors.textPrimary,
        ),
      ),
    );
  }

  // ─── 4 Category Buttons ────────────────────────────────────────────────────

  Widget _buildCategorySection(Size size, AppColorScheme colors) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.015),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            _categoryItem('assets/images/workout.png', 'Workout', 0, size, colors),
            _verticalDivider(colors),
            _categoryItem('assets/images/progress-tracking.png', 'Progress tracking', 1, size, colors),
            _verticalDivider(colors),
            _categoryItem('assets/images/apple.png', 'Nutrition', 2, size, colors),
            _verticalDivider(colors),
            _categoryItem('assets/images/Community.png', 'Community', 3, size, colors),
          ],
        ),
      ),
    );
  }

  Widget _categoryItem(String? imagePath, String label, int index, Size size, AppColorScheme colors, {IconData? icon}) {
    final isSelected = _selectedCategory == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedCategory = index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            imagePath != null
                ? Image.asset(
                    imagePath,
                    width: size.width * 0.08,
                    height: size.width * 0.08,
                    color: isSelected ? colors.secondary : colors.primary,
                  )
                : Icon(icon, size: size.width * 0.08, color: isSelected ? colors.secondary : colors.primary),
            SizedBox(height: size.height * 0.008),
            Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'LeagueSpartan',
                  fontSize: size.width * 0.03,
                  color: isSelected ? colors.secondary : colors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _verticalDivider(AppColorScheme colors) {
    return Container(
      width: 2,
      height: 50,
      color: colors.primary,
    );
  }

  // ─── Section Header ────────────────────────────────────────────────────────

  Widget _buildSectionHeader(String title, Size size, AppColorScheme colors, {bool showSeeAll = true}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.w400,
              color: colors.secondary,
            ),
          ),
          if (showSeeAll)
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'See all',
                    style: TextStyle(
                      fontFamily: 'LeagueSpartan',
                      fontSize: size.width * 0.035,
                      color: colors.onPrimary,
                    ),
                  ),
                  Image.asset('assets/images/right_arrow.png', width: size.width * 0.03, height: size.width * 0.03, color: colors.secondary),
                ]
              ),
            ),
        ],
      ),
    );
  }

  // ─── Recommendation Grid ───────────────────────────────────────────────────

  Widget _buildRecommendationGrid(Size size, AppColorScheme colors) {
    final items = <Map<String, String>>[
      {'title': 'Squat Exercise', 'time': '20 min', 'calories': '180 kcal', 'image': 'assets/images/squats-group.png'},
      {'title': 'Full Body stretching', 'time': '15 min', 'calories': '120 kcal', 'image': 'assets/images/stretch.png'},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Row(
        children: items.asMap().entries.map((entry) {
          return Expanded(
            child: Container(
              margin: entry.key == 0 ? EdgeInsets.only(right: size.width * 0.015) : EdgeInsets.only(left: size.width * 0.015),
              decoration: BoxDecoration(
                color: colors.cardBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height * 0.1,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.asset(
                            entry.value['image']!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: size.height * 0.12,
                              color: colors.primary.withValues(alpha: 0.3),
                              child: Icon(Icons.fitness_center, size: size.width * 0.12, color: colors.primary),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: colors.onSurface, width: 1.5),
                            right: BorderSide(color: colors.onSurface, width: 1.5),
                            bottom: BorderSide(color: colors.onSurface, width: 1.5),
                          ),
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(size.width * 0.03),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(
                                  entry.value['title']!,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: size.width * 0.035,
                                    fontWeight: FontWeight.w400,
                                    color: colors.secondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: size.height * 0.004),
                                Row(
                                  children: [
                                    ImageIcon(AssetImage('assets/images/Time.png'), size: size.width * 0.025, color: colors.primary),
                                    SizedBox(width: size.width * 0.01),
                                    Text(
                                      entry.value['time']!,
                                      style: TextStyle(
                                        fontFamily: 'LeagueSpartan',
                                        fontSize: size.width * 0.025,
                                        color: colors.textSecondary,
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.1),
                                    ImageIcon(AssetImage('assets/images/Calories.png'), size: size.width * 0.025, color: colors.primary),
                                    SizedBox(width: size.width * 0.01),
                                    Text(
                                      entry.value['calories']!,
                                      style: TextStyle(
                                        fontFamily: 'LeagueSpartan',
                                        fontSize: size.width * 0.025,
                                        color: colors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_favouriteItems.contains(entry.key)) {
                            _favouriteItems.remove(entry.key);
                          } else {
                            _favouriteItems.add(entry.key);
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          // color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(4),
                        child: Image.asset(
                          'assets/images/favourites.png',
                          color: _favouriteItems.contains(entry.key) ? colors.secondary : colors.onSurface,
                          width: size.width * 0.04,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.1 - size.width * 0.04,
                    right: size.width * 0.02,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.statusCard,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(2),
                      child: Icon(Icons.play_arrow, color: colors.onSurface, size: size.width * 0.05),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── Banner ────────────────────────────────────────────────────────────────

  Widget _buildBanner(Size size, AppColorScheme colors) {
    return Container(
      width: double.infinity,
      height: size.height * 0.20,
      decoration: BoxDecoration(
        color: colors.primary,
      ),
      child: Container(
        margin: EdgeInsets.only(
          left: size.width * 0.04,
          right: size.width * 0.04,
          top: size.height * 0.035,
          bottom: size.height * 0.035,
        ),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(size.width * 0.04),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Weekly Challenge',
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: size.width * 0.045,
                          fontWeight: FontWeight.bold,
                          color: colors.secondary,
                        ),
                      ),
                      SizedBox(height: size.height * 0.006),
                      Text(
                        'Plank With Hip Twist',
                        style: TextStyle(
                          fontFamily: 'LeagueSpartan',
                          fontSize: size.width * 0.03,
                          color: colors.onPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  // color: colors.secondary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/planks.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Articles Grid ─────────────────────────────────────────────────────────

  Widget _buildArticlesGrid(Size size, AppColorScheme colors) {
    final articles = <Map<String, String>>[
      {'title': 'Supplement Guide...', 'author': 'John Doe', 'image': 'assets/images/supplements.png'},
      {'title': '15 Quick & Effective Daily Routines...', 'author': 'Jane Smith', 'image': 'assets/images/squats-group.png'},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: articles.asMap().entries.map((entry) {
              return Expanded(
                child: Container(
              margin: entry.key == 0 ? EdgeInsets.only(right: size.width * 0.01) : EdgeInsets.only(left: size.width * 0.01),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            height: size.height * 0.1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                entry.value['image']!,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  height: size.height * 0.1,
                                  color: colors.primary.withValues(alpha: 0.2),
                                  child: Icon(Icons.image, size: size.width * 0.1, color: colors.primary),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_favouriteArticles.contains(entry.key)) {
                                    _favouriteArticles.remove(entry.key);
                                  } else {
                                    _favouriteArticles.add(entry.key);
                                  }
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  // color: Colors.black26,
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(4),
                                child: Image.asset(
                                  'assets/images/favourites.png',
                                  color: _favouriteArticles.contains(entry.key) ? colors.secondary : colors.onSurface,
                                  width: size.width * 0.04,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.008),
                      Text(
                        entry.value['title']!,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: size.width * 0.035,
                          fontWeight: FontWeight.w400,
                          color: colors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

}
