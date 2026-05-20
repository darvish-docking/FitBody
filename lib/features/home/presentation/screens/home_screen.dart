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
              SizedBox(height: size.height * 0.03),
              _buildCategorySection(size, colors),
              SizedBox(height: size.height * 0.03),
              _buildSectionHeader('Recommendation', size, colors),
              SizedBox(height: size.height * 0.02),
              _buildRecommendationGrid(size, colors),
              SizedBox(height: size.height * 0.03),
              _buildBanner(size, colors),
              SizedBox(height: size.height * 0.03),
              _buildSectionHeader('Articles & Tips', size, colors),
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
                color: colors.primary,
              ),
            ),
          ),
          _topBarIcon(Icons.search_outlined, colors, size),
          SizedBox(width: size.width * 0.04),
          _topBarIcon(Icons.notifications_outlined, colors, size),
          SizedBox(width: size.width * 0.04),
          _topBarIcon(Icons.person_outline, colors, size),
        ],
      ),
    );
  }

  Widget _topBarIcon(IconData icon, AppColorScheme colors, Size size) {
    return GestureDetector(
      onTap: () {},
      child: Icon(icon, color: colors.primary, size: size.width * 0.06),
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
          color: colors.textSecondary,
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
            Text(
              label,
              style: TextStyle(
                fontFamily: 'LeagueSpartan',
                fontSize: size.width * 0.03,
                color: isSelected ? colors.secondary : colors.textPrimary,
                fontWeight: FontWeight.w500,
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

  Widget _buildSectionHeader(String title, Size size, AppColorScheme colors) {
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
      {'title': 'squat Exercise', 'subtitle': 'Intermediate', 'image': 'assets/images/squats-group.png'},
      {'title': 'Full Body stretching', 'subtitle': 'Beginner', 'image': 'assets/images/stretch.png'},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Row(
        children: items.asMap().entries.map((entry) {
          return Expanded(
            child: Container(
              margin: entry.key == 0 ? EdgeInsets.only(right: size.width * 0.025) : EdgeInsets.only(left: size.width * 0.025),
              decoration: BoxDecoration(
                color: colors.cardBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(
                      entry.value['image']!,
                      height: size.height * 0.12,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: size.height * 0.12,
                        color: colors.primary.withValues(alpha: 0.3),
                        child: Icon(Icons.fitness_center, size: size.width * 0.12, color: colors.primary),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(size.width * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Text(
                            entry.value['title']!,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: size.width * 0.035,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: size.height * 0.004),
                          Text(
                            entry.value['subtitle']!,
                            style: TextStyle(
                              fontFamily: 'LeagueSpartan',
                              fontSize: size.width * 0.03,
                              color: colors.textSecondary,
                            ),
                          ),
                      ],
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
      height: size.height * 0.17,
      decoration: BoxDecoration(
        color: colors.primary,
      ),
      child: Container(
        margin: EdgeInsets.all(size.width * 0.04),
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
                  color: colors.secondary,
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
      {'title': 'Workout Tips', 'author': 'John Doe', 'image': 'assets/images/supplements.png'},
      {'title': 'Healthy Recipes', 'author': 'Jane Smith', 'image': 'assets/images/squats-group.png'},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        children: [
          Row(
            children: articles.asMap().entries.map((entry) {
              return Expanded(
                child: Container(
                  margin: entry.key == 0 ? EdgeInsets.only(right: size.width * 0.025) : EdgeInsets.only(left: size.width * 0.025),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          entry.value['image']!,
                          height: size.height * 0.1,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: size.height * 0.1,
                            color: colors.primary.withValues(alpha: 0.2),
                            child: Icon(Icons.image, size: size.width * 0.1, color: colors.primary),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.008),
                      Text(
                        entry.value['title']!,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: size.width * 0.035,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        entry.value['author']!,
                        style: TextStyle(
                          fontFamily: 'LeagueSpartan',
                          fontSize: size.width * 0.028,
                          color: colors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
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
