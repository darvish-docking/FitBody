import 'package:flutter/material.dart';
import 'package:fitbody/core/constants/colors.dart';

class GoalSelectionScreen extends StatefulWidget {
  const GoalSelectionScreen({super.key});

  @override
  State<GoalSelectionScreen> createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  final List<String> _goals = [
    'Loss Weight',
    'Gain Weight',
    'Muscle Mass Gain',
    'Shape Body',
    'Others',
  ];
  String _selectedGoal = 'Loss Weight';

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
            SizedBox(height: size.height * 0.01),
            
            // Title text
            Center(
              child: Text(
                "What Is Your Goal?",
                style: TextStyle(
                  fontSize: size.width * 0.07,
                  fontFamily: 'Poppins',
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            
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
            
            SizedBox(height: size.height * 0.04),
            
            // Banner (Purple Container)
            Container(
              width: double.infinity,
              color: colors.primary,
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.08,
                vertical: size.height * 0.03,
              ),
              child: Column(
                children: _goals.map((goal) => _buildGoalPill(goal, size)).toList(),
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

  Widget _buildGoalPill(String goal, Size size) {
    final isSelected = _selectedGoal == goal;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGoal = goal;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 14),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35), // Pill shaped
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Label at left end
            Text(
              goal,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.black,
                fontFamily: 'LeagueSpartan',
              ),
            ),
            // Custom Radio Button at right end
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
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
            Navigator.of(context).pushNamed('/activity-level');
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
