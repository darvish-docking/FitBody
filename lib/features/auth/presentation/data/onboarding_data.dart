class OnboardingPageData {
  final String backgroundImage;
  final String? imagePath;
  final String title;
  final bool isWelcome;

  const OnboardingPageData({
    required this.backgroundImage,
    this.imagePath,
    required this.title,
    this.isWelcome = false,
  });

  static  List<OnboardingPageData> pages = [
    OnboardingPageData(
      backgroundImage: 'assets/images/onboarding_1.png',
      isWelcome: true,
      title: 'Welcome to',
    ),
    OnboardingPageData(
      backgroundImage: 'assets/images/onboarding_2.png',
      imagePath: 'assets/images/run.png',
      title: 'Start Your Journey Towards a More Active Lifestyle',
    ),
    OnboardingPageData(
      backgroundImage: 'assets/images/onboarding_3.png',
      imagePath: 'assets/images/onboarding_center_3.png',
      title: 'Track Your Progress',
    ),
    OnboardingPageData(
      backgroundImage: 'assets/images/onboarding_4.png',
      imagePath: 'assets/images/onboarding_center_4.png',
      title: 'Join the Community',
    ),
  ];
}
