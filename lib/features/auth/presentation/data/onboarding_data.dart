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
      imagePath: 'assets/images/apple.png',
      title: 'Find Nutrition Tips That Fit Your Lifestyle',
    ),
    OnboardingPageData(
      backgroundImage: 'assets/images/onboarding_4.png',
      imagePath: 'assets/images/Community.png',
      title: 'A Community For You, Challenge Yourself',
    ),
  ];
}
