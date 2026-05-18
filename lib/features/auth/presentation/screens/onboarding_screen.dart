import 'package:flutter/material.dart';
import 'package:fitbody/core/constants/app_constants.dart';
import 'package:fitbody/core/constants/colors.dart';
import 'package:fitbody/features/auth/presentation/data/onboarding_data.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<OnboardingPageData> _pages = OnboardingPageData.pages;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final size = MediaQuery.sizeOf(context);
    final currentData = _pages[_currentPage];

    return Scaffold(
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Image.asset(
              currentData.backgroundImage,
              key: ValueKey(currentData.backgroundImage),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withValues(alpha: 0.4),
          ),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, right: 10),
                    child: Visibility(
                      visible: _currentPage > 0 && _currentPage < _pages.length - 1,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Skip',
                              style: TextStyle(
                                color: colors.secondary,
                                fontWeight: FontWeight.bold,
                                fontFamily: "LeagueSpartan",
                                fontSize: size.width * 0.048,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Image.asset(
                              'assets/images/right_arrow.png',
                              width: size.width * 0.04,
                              color: colors.secondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      final data = _pages[index];
                      final isLastPage = index == _pages.length - 1;

                      return Center(
                        child: data.isWelcome
                            ? _buildWelcomeContent(colors, size, data)
                            : _buildInfoPage(context, colors, size, isLastPage, data, index),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeContent(AppColorScheme colors, Size size, OnboardingPageData data) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _goNext,
          child: Text(
            data.title,
            style: TextStyle(
              fontSize: size.width * 0.06,
              color: colors.secondary,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
              fontFamily: 'LeagueSpartan',
            ),
          ),
        ),
        SizedBox(height: size.height * 0.02),
        Image.asset(
          'assets/images/logo-1.png',
          width: size.width * 0.5,
          fit: BoxFit.fitWidth,
        ),
        SizedBox(height: size.height * 0.015),
        Image.asset(
          'assets/images/logo-2.png',
          width: size.width * 0.6,
          fit: BoxFit.fitWidth,
        ),
      ],
    );
  }

  Widget _buildInfoPage(BuildContext context, AppColorScheme colors, Size size, bool isLastPage, OnboardingPageData data, int pageIndex) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          height: size.height * 0.22,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.06,
              vertical: size.height * 0.02,
            ),
            color: colors.primary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: size.width * 0.15,
                  child: Image.asset(
                    data.imagePath!,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Text(
                  data.title,
                  style: TextStyle(
                    fontSize: size.width * 0.06,
                    fontWeight: FontWeight.bold,
                    color: colors.onPrimary,
                    fontFamily: 'LeagueSpartan',
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: size.height * 0.01),
                _buildDots(colors, pageIndex),
              ],
            ),
          ),
        ),
        SizedBox(height: size.height * 0.03),
        _buildButton(context, colors, isLastPage),
      ],
    );
  }

  Widget _buildButton(BuildContext context, AppColorScheme colors, bool isLastPage) {
    final size = MediaQuery.sizeOf(context);
    return SizedBox(
      width: size.width * 0.53,
      height: size.height * 0.058,
      child: ElevatedButton(
        onPressed: _goNext,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.onPrimary.withValues(alpha: 0.25),
          foregroundColor: colors.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: colors.onPrimary, width: 1),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        child: Text(
          isLastPage ? 'Get Started' : 'Next',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDots(AppColorScheme colors, int pageIndex) {
    final dotCount = _pages.length - 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        dotCount,
        (index) {
          final isSelected = index == pageIndex - 1;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 24,
            height: 4,
            decoration: BoxDecoration(
              color: isSelected ? colors.onPrimary : colors.tertiary,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        },
      ),
    );
  }
}
