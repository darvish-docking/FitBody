import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitbody/core/constants/app_constants.dart';
import 'package:fitbody/core/constants/colors.dart';
import 'package:fitbody/providers/theme_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(AppConstants.splashDuration);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: colors.splashBackground,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLogo(size , 'assets/images/logo-1.png'),
              // SizedBox(height: size.height * 0.001),
              _buildLogo(size , 'assets/images/logo-2.png'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(Size size, String assetPath) {
    final logoSize = size.width * 0.28;
    return Image.asset(
      assetPath,
      width: logoSize * 0.9,
      height: logoSize * 0.4,
      // color: Theme.of(context).colorScheme.primary,
    );
  }

 
}
