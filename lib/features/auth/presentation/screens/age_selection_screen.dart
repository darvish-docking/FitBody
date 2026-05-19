import 'package:flutter/material.dart';
import 'package:fitbody/core/constants/colors.dart';

class AgeSelectionScreen extends StatefulWidget {
  const AgeSelectionScreen({super.key});

  @override
  State<AgeSelectionScreen> createState() => _AgeSelectionScreenState();
}

class _AgeSelectionScreenState extends State<AgeSelectionScreen> {
  int _selectedAge = 28;
  late ScrollController _scrollController;
  final double _itemWidth = 80.0;
  bool _isSnapping = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
      initialScrollOffset: (25 - 10) * _itemWidth,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final size = MediaQuery.sizeOf(context);

    // Explicitly black background as requested previously
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
                "How old are you?",
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
            
            // Selected Age Display (The "weight in bold" mentioned in prompt)
            Center(
              child: Text(
                '$_selectedAge',
                style: TextStyle(
                  fontSize: size.width * 0.25,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            
            // Upward Arrow
            Center(
              child: Image.asset(
                'assets/images/upward_arrow.png',
                color: colors.secondary,
                width: size.width * 0.12,
              ),
            ),
            
            SizedBox(height: size.height * 0.02), // Give room after upward arrow
            
            // Horizontal Scroll Panel
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: size.height * 0.15,
                  color: colors.primary,
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  if (notification is ScrollUpdateNotification) {
                    final offset = _scrollController.offset;
                    final index = (offset / _itemWidth).round();
                    final age = index + 10;
                    if (age != _selectedAge && age >= 10 && age <= 99) {
                      setState(() {
                        _selectedAge = age;
                      });
                    }
                  } else if (notification is ScrollEndNotification) {
                    if (!_isSnapping) {
                      _isSnapping = true;
                      final offset = _scrollController.offset;
                      final index = (offset / _itemWidth).round();
                      _scrollController.animateTo(
                        index * _itemWidth,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      ).then((_) {
                        _isSnapping = false;
                      });
                    }
                  }
                  return true;
                },
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: size.width / 2 - _itemWidth / 2),
                  itemCount: 90, // Ages 10 to 99
                  itemBuilder: (context, index) {
                    final age = index + 10;
                    final isSelected = age == _selectedAge;
                    
                    return SizedBox(
                      width: _itemWidth,
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _scrollController,
                          builder: (context, child) {
                            double itemPosition = index * _itemWidth;
                            double currentOffset = _scrollController.hasClients 
                                ? _scrollController.offset 
                                : (25 - 10) * _itemWidth;
                            double distance = (currentOffset - itemPosition).abs();
                            
                            double maxDistance = _itemWidth * 2.5;
                            double scale = 1.0 - (distance / maxDistance).clamp(0.0, 1.0);
                            
                            bool isHighlight = distance < (_itemWidth / 2);

                            return Text(
                              age.toString(),
                              style: TextStyle(
                                fontSize: 18 + (22 * scale), // Scales from 18 to 40
                                color: isHighlight ? Colors.white : Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                ),
                ),
                // Selection Bracket (Two white sticks)
                IgnorePointer(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 3, height: size.height * 0.18, color: Colors.white),
                      SizedBox(width: 75), // Space for the number
                      Container(width: 3, height: size.height * 0.18, color: Colors.white),
                    ],
                  ),
                ),
              ],
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
            Navigator.of(context).pushNamed('/weight-selection');
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
