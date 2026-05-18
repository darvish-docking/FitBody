import 'package:flutter/material.dart';
import 'package:fitbody/core/constants/colors.dart';

class GenderSelectionScreen extends StatefulWidget {
  const GenderSelectionScreen({super.key});

  @override
  State<GenderSelectionScreen> createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final size = MediaQuery.sizeOf(context);

    // Explicitly black background as requested
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
              padding: const EdgeInsets.only(left:8.0),
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
            SizedBox(height: size.height * 0.01),
            
            // Title text
            Center(
              child: Text(
                "What's your Gender",
                style: TextStyle(
                  fontSize: size.width * 0.07,
                  fontFamily: 'Poppins',
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            
            // Banner with dummy text
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.06,
                vertical: size.height * 0.02,
              ),
              color: colors.primary,
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size.width * 0.04,
                  color: colors.cardBackground,
                  fontFamily: 'LeagueSpartan',
                  height: 1.1,
                ),
              ),
            ),
            
            // Circular containers for Gender
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildGenderOption('Male', Icons.male, size, colors),
                    SizedBox(height: size.height * 0.04),
                    _buildGenderOption('Female', Icons.female, size, colors),
                  ],
                ),
              ),
            ),
            
            // Next button
            Center(
              child: _buildNextButton(size, colors),
            ),
            SizedBox(height: size.height * 0.04),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderOption(String gender, IconData icon, Size size, AppColorScheme colors) {
    final isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = gender),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: size.width * 0.35,
            height: size.width * 0.35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? colors.secondary : colors.surface,
              border: Border.all(
                color: isSelected ? colors.secondary : colors.textPrimary,
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              size: size.width * 0.15,
              color: isSelected ? colors.cardBackground : colors.textPrimary,
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            gender,
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: size.width * 0.05,
              fontFamily: 'Poppins',
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton(Size size, AppColorScheme colors) {
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
            if (_selectedGender != null) {
              // Navigator.of(context).pushNamed('/next-screen');
            }
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
            'Next',
            style: TextStyle(color: colors.textPrimary),
          ),
        ),
      ),
    );
  }
}
