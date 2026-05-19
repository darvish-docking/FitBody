import 'package:flutter/material.dart';
import 'package:fitbody/core/constants/colors.dart';

class ActivityLevelScreen extends StatefulWidget {
  const ActivityLevelScreen({super.key});

  @override
  State<ActivityLevelScreen> createState() => _ActivityLevelScreenState();
}

class _ActivityLevelScreenState extends State<ActivityLevelScreen> {
  final List<String> _levels = [
    'Beginner',
    'Intermediate',
    'Advance',
  ];
  String _selectedLevel = 'Beginner';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final size = MediaQuery.sizeOf(context);

    final backgroundColor = colors.surface; 
    final textColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.04),
            // Back Button
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/left_arrow.png',
                      width: size.width * 0.05,
                      color: colors.secondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Back',
                      style: TextStyle(
                        color: colors.secondary,
                        fontFamily: 'LeagueSpartan',
                        fontSize: size.width * 0.045,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: size.height * 0.04),
            
            // Title text
            Center(
              child: Text(
                "Physical Activity Level",
                style: TextStyle(
                  fontSize: size.width * 0.07,
                  fontFamily: 'Poppins',
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.04),
            
            // Dummy text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size.width * 0.04,
                  color: Colors.grey[400],
                  fontFamily: 'LeagueSpartan',
                  height: 1.1,
                ),
              ),
            ),
            
            // Large amount of space
            SizedBox(height: size.height * 0.15),
            
            // Activity Level Options (3 pill-shaped containers)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
              child: Column(
                children: _levels.map((level) => _buildLevelPill(level, colors)).toList(),
              ),
            ),
            
            const Spacer(),
            
            // Continue button
            Center(
              child: _buildContinueButton(size, colors),
            ),
            SizedBox(height: size.height * 0.04),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelPill(String level, AppColorScheme colors) {
    final isSelected = _selectedLevel == level;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLevel = level;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 14),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? colors.secondary : Colors.white,
          borderRadius: BorderRadius.circular(35), // Pill shaped
        ),
        child: Center(
          child: Text(
            level,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.black : colors.primary,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton(Size size, AppColorScheme colors) {
    return Container(
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
            // End of onboarding flow
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
          child: Text(
            'Continue',
            style: TextStyle(color: colors.textPrimary),
          ),
        ),
      ),
    );
  }
}
