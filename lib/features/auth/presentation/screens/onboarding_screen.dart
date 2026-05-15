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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_currentPage < OnboardingPageData.pages.length - 1) {
      _pageController.nextPage(
        duration: AppConstants.defaultAnimationDuration,
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
    final pages = OnboardingPageData.pages;
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: pages.length,
            itemBuilder: (context, index) => _OnboardingPage(
              data: pages[index],
              currentIndex: index,
              totalPages: pages.length,
              isLastPage: index == pages.length - 1,
              onNext: _onNextPressed,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 5,
            right: 10,
            child: _currentPage > 0 && _currentPage < pages.length - 1
                ? TextButton(
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
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;
  final int currentIndex;
  final int totalPages;
  final bool isLastPage;
  final VoidCallback onNext;

  const _OnboardingPage({
    required this.data,
    required this.currentIndex,
    required this.totalPages,
    required this.isLastPage,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final size = MediaQuery.sizeOf(context);

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            data.backgroundImage,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          color: Colors.black.withValues(alpha: 0.4), // overlay for better text visibility
        ),
        SafeArea(
          child: GestureDetector(
            onTap: data.isWelcome ? onNext : null,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: size.height * 0.08),
                  _buildBanner(context, colors, size, currentIndex),
                  if (!data.isWelcome) ...[
                    SizedBox(height: size.height * 0.03),
                    _buildButton(context, colors),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBanner(BuildContext context, AppColorScheme colors, Size size, int currentIndex) {
    if (data.isWelcome) {
      return _buildWelcomeContent(colors, size);
    }
    return _buildInfoBanner(context, size, colors, currentIndex);
  }

  Widget _buildWelcomeContent(AppColorScheme colors, Size size) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          data.title,
          style: TextStyle(
            fontSize: size.width * 0.06,
            color: colors.secondary,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
            fontFamily: 'LeagueSpartan',
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

  Widget _buildInfoBanner(BuildContext context, Size size, AppColorScheme colors, int currentIndex) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.06,
        vertical: size.height * 0.02,
      ),
      decoration: BoxDecoration(
        color: colors.primary,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            data.imagePath!,
            width: size.width * 0.15,
            fit: BoxFit.fitWidth,
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
          ),
          SizedBox(height: size.height * 0.01),
          _buildDots(colors, currentIndex),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, AppColorScheme colors) {
    final size = MediaQuery.sizeOf(context);
    return SizedBox(
      width: size.width * 0.53,
      height: size.height * 0.058,
      child: ElevatedButton(
        onPressed: onNext,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.onPrimary.withValues(alpha: 0.25),
          foregroundColor: colors.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: colors.onPrimary, width: 1),
          ),
          textStyle: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        child: Text(isLastPage ? 'Get Started' : 'Next'),
      ),
    );
  }

  Widget _buildDots(AppColorScheme colors, int currentIndex) {
    final dotCount = totalPages - 1;
    final selectedIndex = currentIndex - 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        dotCount,
        (index) {
          final isSelected = index == selectedIndex;
          return AnimatedContainer(
            duration: AppConstants.defaultAnimationDuration,
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
