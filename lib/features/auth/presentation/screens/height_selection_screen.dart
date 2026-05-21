import 'package:flutter/material.dart';
import 'package:fitbody/core/constants/colors.dart';
import 'package:fitbody/services/storage_service.dart';

class HeightSelectionScreen extends StatefulWidget {
  const HeightSelectionScreen({super.key});

  @override
  State<HeightSelectionScreen> createState() => _HeightSelectionScreenState();
}

class _HeightSelectionScreenState extends State<HeightSelectionScreen> {
  int _selectedHeight = 160; // in cm
  late ScrollController _scrollController;
  final double _itemHeight = 80.0;
  bool _isSnapping = false;

  @override
  void initState() {
    super.initState();
    // Heights range from 100 to 220 cm.
    // 160 is index 60.
    _scrollController = ScrollController(
      initialScrollOffset: (160 - 100) * _itemHeight,
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

    final backgroundColor = colors.surface; 
    final textColor = Colors.white;

    final containerHeight = size.height * 0.45;

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
                "What Is Your Height?",
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
            
            // Selected Height Display
            Center(
              child: RichText(
                text: TextSpan(
                  text: '$_selectedHeight ',
                  style: TextStyle(
                    fontSize: size.width * 0.12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  children: [
                    TextSpan(
                      text: 'Cm',
                      style: TextStyle(
                        fontSize: size.width * 0.06,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: size.height * 0.04),
            
            // Vertical Height Selector
            Center(
              child: SizedBox(
                height: containerHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Vertical Scroll list of numbers + vertical ruler
                    SizedBox(
                      width: 220,
                      height: containerHeight,
                      child: Stack(
                        children: [
                          // Rounded Ruler Banner Background
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            width: 100,
                            child: Container(
                              decoration: BoxDecoration(
                                color: colors.primary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification notification) {
                          if (notification is ScrollUpdateNotification) {
                            final offset = _scrollController.offset;
                            final index = (offset / _itemHeight).round();
                            final heightVal = index + 100;
                            if (heightVal != _selectedHeight && heightVal >= 100 && heightVal <= 220) {
                              setState(() {
                                _selectedHeight = heightVal;
                              });
                            }
                          } else if (notification is ScrollEndNotification) {
                            if (!_isSnapping) {
                              _isSnapping = true;
                              final offset = _scrollController.offset;
                              final index = (offset / _itemHeight).round();
                              _scrollController.animateTo(
                                index * _itemHeight,
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
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(vertical: containerHeight / 2 - _itemHeight / 2),
                          itemCount: 220 - 100 + 1, // heights 100 to 220
                          itemBuilder: (context, index) {
                            final heightVal = index + 100;
                            
                            return SizedBox(
                              height: _itemHeight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Number (Left side)
                                  Expanded(
                                    child: Center(
                                      child: AnimatedBuilder(
                                        animation: _scrollController,
                                        builder: (context, child) {
                                          double itemPosition = index * _itemHeight;
                                          double currentOffset = _scrollController.hasClients 
                                              ? _scrollController.offset 
                                              : (160 - 100) * _itemHeight;
                                          double distance = (currentOffset - itemPosition).abs();
                                          
                                          double maxDistance = _itemHeight * 2.5;
                                          double scale = 1.0 - (distance / maxDistance).clamp(0.0, 1.0);
                                          
                                          return Text(
                                            heightVal.toString(),
                                            style: TextStyle(
                                              fontSize: 18 + (22 * scale), 
                                              color: Color.lerp(Colors.grey[700], Colors.white, scale),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Vertical Ruler segment (Right side)
                                  Container(
                                    width: 100,
                                    height: _itemHeight,
                                    color: Colors.transparent,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        _buildStick(isTall: false),
                                        _buildStick(isTall: false),
                                        _buildStick(
                                          isTall: true,
                                          color: (heightVal == _selectedHeight) ? colors.secondary : Colors.white,
                                        ),
                                        _buildStick(isTall: false),
                                        _buildStick(isTall: false),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
                    const SizedBox(width: 8),
                    // Pointer arrow pointing left at the ruler
                    Icon(
                      Icons.arrow_left,
                      color: colors.secondary,
                      size: size.width * 0.12,
                    ),
                  ],
                ),
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

  Widget _buildStick({required bool isTall, Color color = Colors.white}) {
    return Container(
      height: 3,
      width: isTall ? 75 : 40,
      color: color,
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
          onPressed: () async {
            final storage = await StorageService.getInstance();
            await storage.setInt('user_height', _selectedHeight);
            if (mounted) Navigator.of(context).pushNamed('/goal-selection');
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
