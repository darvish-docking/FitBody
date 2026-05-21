import 'package:flutter/material.dart';
import 'package:fitbody/core/constants/colors.dart';
import 'package:fitbody/widgets/common/bottom_nav_bar.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  int _selectedFilter = 0;
  int _currentNavIndex = 2;

  final List<String> _filters = ['All', 'Video', 'Article'];

  final List<Map<String, String>> _videos = [
    {'title': 'Squat Exercise', 'duration': '20 min', 'calories': '180 kcal', 'exercises': '8', 'image': 'assets/images/squats-group.png'},
    {'title': 'Full Body stretching', 'duration': '15 min', 'calories': '120 kcal', 'exercises': '6', 'image': 'assets/images/stretch.png'},
  ];

  final List<Map<String, String>> _articles = [
    {'title': 'Workout Tips', 'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.', 'image': 'assets/images/supplements.png'},
    {'title': 'Healthy Recipes', 'description': 'Sed do eiusmod tempor incididunt ut labore et dolore.', 'image': 'assets/images/squats-group.png'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.02),
            _buildTopBar(size, colors),
            SizedBox(height: size.height * 0.02),
            _buildFilterChips(size, colors),
            SizedBox(height: size.height * 0.02),
            Expanded(child: _buildContent(size, colors)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (index) => setState(() => _currentNavIndex = index),
      ),
    );
  }

  Widget _buildTopBar(Size size, AppColorScheme colors) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/left_arrow.png',
                  width: size.width * 0.05,
                  color: colors.secondary,
                ),
                SizedBox(width: size.width * 0.02),
                Text(
                  'Favourites',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: size.width * 0.055,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          ImageIcon(AssetImage('assets/images/Search.png'), color: colors.primary, size: size.width * 0.055),
          SizedBox(width: size.width * 0.04),
          ImageIcon(AssetImage('assets/images/Notifications.png'), color: colors.primary, size: size.width * 0.055),
          SizedBox(width: size.width * 0.04),
          ImageIcon(AssetImage('assets/images/profile.png'), color: colors.primary, size: size.width * 0.055),
        ],
      ),
    );
  }

  Widget _buildFilterChips(Size size, AppColorScheme colors) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      child: Row(
        children: [
          Text(
            'Sort By',
            style: TextStyle(
              fontFamily: 'LeagueSpartan',
              fontSize: size.width * 0.04,
              color: colors.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: size.width * 0.03),
          ...List.generate(_filters.length, (index) {
            final isSelected = _selectedFilter == index;
            return Padding(
              padding: EdgeInsets.only(right: size.width * 0.02),
              child: SizedBox(
                height: 32,
                child: ChoiceChip(
                  label: Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                    child: Text(
                      _filters[index],
                      style: TextStyle(
                        fontFamily: 'LeagueSpartan',
                        fontSize: size.width * 0.03,
                        color: isSelected ? colors.cardBackground : colors.textPrimary,
                      ),
                    ),
                  ),
                  selected: isSelected,
                  showCheckmark: false,
                  onSelected: (selected) => setState(() => _selectedFilter = index),
                  selectedColor: colors.secondary,
                  backgroundColor: colors.chipBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide.none,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildContent(Size size, AppColorScheme colors) {
    if (_selectedFilter == 1) {
      return _buildVideoList(size, colors);
    } else if (_selectedFilter == 2) {
      return _buildArticleList(size, colors);
    }
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      children: [
        _buildSectionLabel('Videos', size, colors),
        ..._videos.map((v) => _buildVideoCard(v, size, colors)),
        SizedBox(height: size.height * 0.03),
        _buildSectionLabel('Articles', size, colors),
        ..._articles.map((a) => _buildArticleCard(a, size, colors)),
      ],
    );
  }

  Widget _buildSectionLabel(String label, Size size, AppColorScheme colors) {
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.015),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: size.width * 0.045,
          fontWeight: FontWeight.w600,
          color: colors.secondary,
        ),
      ),
    );
  }

  Widget _buildVideoList(Size size, AppColorScheme colors) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      children: _videos.map((v) => _buildVideoCard(v, size, colors)).toList(),
    );
  }

  Widget _buildArticleList(Size size, AppColorScheme colors) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      children: _articles.map((a) => _buildArticleCard(a, size, colors)).toList(),
    );
  }

  Widget _buildVideoCard(Map<String, String> video, Size size, AppColorScheme colors) {
    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.02),
      decoration: BoxDecoration(
        color: colors.onPrimary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          video['title']!,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.w600,
                            color: colors.surface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Image.asset(
                        'assets/images/favourites.png',
                        color: colors.secondary,
                        width: size.width * 0.05,
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.015),
                  Wrap(
                    spacing: size.width * 0.04,
                    runSpacing: size.height * 0.008,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ImageIcon(AssetImage('assets/images/Time.png'), size: size.width * 0.03, color: colors.surface),
                          SizedBox(width: size.width * 0.01),
                          Text(
                            video['duration']!,
                            style: TextStyle(
                              fontFamily: 'LeagueSpartan',
                              fontSize: size.width * 0.03,
                              color: colors.surface,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.local_fire_department, size: size.width * 0.035, color: colors.surface),
                          SizedBox(width: size.width * 0.01),
                          Text(
                            video['calories']!,
                            style: TextStyle(
                              fontFamily: 'LeagueSpartan',
                              fontSize: size.width * 0.03,
                              color: colors.surface,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.directions_run, size: size.width * 0.035, color: colors.surface),
                          SizedBox(width: size.width * 0.01),
                          Text(
                            '${video['exercises']} exercises',
                            style: TextStyle(
                              fontFamily: 'LeagueSpartan',
                              fontSize: size.width * 0.03,
                              color: colors.surface,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              video['image']!,
              width: size.width * 0.35,
              height: size.height * 0.12,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildArticleCard(Map<String, String> article, Size size, AppColorScheme colors) {
    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.02),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          article['title']!,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Image.asset(
                        'assets/images/favourites.png',
                        color: colors.secondary,
                        width: size.width * 0.05,
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.008),
                  Text(
                    article['description']!,
                    style: TextStyle(
                      fontFamily: 'LeagueSpartan',
                      fontSize: size.width * 0.03,
                      color: colors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              article['image']!,
              width: size.width * 0.35,
              height: size.height * 0.1,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
