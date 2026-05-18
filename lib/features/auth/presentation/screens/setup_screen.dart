import 'package:flutter/material.dart';
import 'package:fitbody/core/constants/colors.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final size = MediaQuery.sizeOf(context);

    // Background color based on theme
    // final backgroundColor = isDark ? Colors.black : Colors.white;
    // final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Column(
        children: [
          // Top half: Image
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Image.asset(
                'assets/images/squats.png', // Placeholder asset from onboarding
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Lower half
          SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 15 word sentence
                SizedBox(height: size.height * 0.03),
                Text(
                  "Consistency Is",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.width * 0.07,
                    fontFamily: 'Poppins',
                    color: colors.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "The Key To Progress.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.width * 0.07,
                    fontFamily: 'Poppins',
                    color: colors.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Don't Give Up!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.width * 0.07,
                    fontFamily: 'Poppins',
                    color: colors.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                // Banner with 'Lorem ipsum' text of 2 lines
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.06,
                    vertical: size.height * 0.02,
                  ),
                  color: colors.primary,
                  child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: size.width * 0.04,
                      color: colors.cardBackground,
                      fontFamily: 'LeagueSpartan',
                      height: 1.1,
                    ),
                    
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                // 'Next' button similar to onboarding
                Container(
                  decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: colors.button.withValues(alpha: 0.25),
                  offset: const Offset(0, 9),
                  blurRadius: 9,
                ),
              ],
            ),
                  child: SizedBox(
                    width: size.width * 0.53,
                    height: size.height * 0.058,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/gender-selection');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.textPrimary.withValues(alpha: 0.1),
                        foregroundColor: colors.textPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                          side: BorderSide(color: colors.textPrimary, width: 1),
                        ),
                        textStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      child:  Text('Next',
                      style: TextStyle(
                        color: colors.textPrimary
                      ),),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.04),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
