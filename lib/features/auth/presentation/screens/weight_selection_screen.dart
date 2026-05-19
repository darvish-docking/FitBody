import 'package:flutter/material.dart';
import 'package:fitbody/core/constants/colors.dart';

class WeightSelectionScreen extends StatefulWidget {
  const WeightSelectionScreen({super.key});

  @override
  State<WeightSelectionScreen> createState() => _WeightSelectionScreenState();
}

class _WeightSelectionScreenState extends State<WeightSelectionScreen> {
  bool _isKg = true;
  int _selectedWeight = 75;
  late ScrollController _scrollController;
  final double _itemWidth = 80.0;
  bool _isSnapping = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
      initialScrollOffset: (_selectedWeight - 30) * _itemWidth,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleUnit(bool toKg) {
    if (_isKg == toKg) return;
    setState(() {
      _isKg = toKg;
      if (_isKg) {
        _selectedWeight = (_selectedWeight / 2.20462).round().clamp(30, 200);
        _scrollController.jumpTo((_selectedWeight - 30) * _itemWidth);
      } else {
        _selectedWeight = (_selectedWeight * 2.20462).round().clamp(66, 440);
        _scrollController.jumpTo((_selectedWeight - 66) * _itemWidth);
      }
    });
  }

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
                "What Is Your Weight?",
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
            
            // KG/LB Toggle
            Center(
              child: Container(
                width: size.width * 0.6,
                height: size.height * 0.06,
                decoration: BoxDecoration(
                  color: colors.secondary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(child: _buildToggleOption('KG', _isKg)),
                    VerticalDivider(
                      color: Colors.black,
                      thickness: 3,
                      width: 1,
                      indent: 10,
                      endIndent: 10,
                    ),
                    Expanded(child: _buildToggleOption('LB', !_isKg)),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: size.height * 0.06),
            
            // Horizontal Scroll Panel with Numbers and Ruler Banner
            SizedBox(
              height: size.height * 0.26,
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  if (notification is ScrollUpdateNotification) {
                    final offset = _scrollController.offset;
                    final index = (offset / _itemWidth).round();
                    final minW = _isKg ? 30 : 66;
                    final maxW = _isKg ? 200 : 440;
                    final weight = index + minW;
                    if (weight != _selectedWeight && weight >= minW && weight <= maxW) {
                      setState(() {
                        _selectedWeight = weight;
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
                  itemCount: _isKg ? (200 - 30 + 1) : (440 - 66 + 1), 
                  itemBuilder: (context, index) {
                    final weight = index + (_isKg ? 30 : 66);
                    
                    return SizedBox(
                      width: _itemWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Number with scaling
                          AnimatedBuilder(
                            animation: _scrollController,
                            builder: (context, child) {
                              double itemPosition = index * _itemWidth;
                              double currentOffset = _scrollController.hasClients 
                                  ? _scrollController.offset 
                                  : (_selectedWeight - (_isKg ? 30 : 66)) * _itemWidth;
                              double distance = (currentOffset - itemPosition).abs();
                              
                              double maxDistance = _itemWidth * 2.5;
                              double scale = 1.0 - (distance / maxDistance).clamp(0.0, 1.0);
                              
                              return Text(
                                weight.toString(),
                                style: TextStyle(
                                  fontSize: 18 + (22 * scale), 
                                  color: Color.lerp(Colors.grey[700], Colors.white, scale),
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          // Ruler Banner Segment
                          Container(
                            height: size.height * 0.15,
                            color: colors.primary,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildStick(isTall: false),
                                _buildStick(isTall: false),
                                _buildStick(
                                  isTall: true,
                                  color: (weight == _selectedWeight) ? colors.secondary : Colors.white,
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
            
            // Upward Arrow
            Center(
              child: Image.asset(
                'assets/images/upward_arrow.png',
                color: colors.secondary,
                width: size.width * 0.12,
              ),
            ),
            
            SizedBox(height: size.height * 0.02),
            
            // Selected Weight Display
            Center(
              child: RichText(
                text: TextSpan(
                  text: '$_selectedWeight ',
                  style: TextStyle(
                    fontSize: size.width * 0.12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  children: [
                    TextSpan(
                      text: _isKg ? 'kg' : 'lb',
                      style: TextStyle(
                        fontSize: size.width * 0.06,
                        color: Colors.grey,
                      ),
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

  Widget _buildToggleOption(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => _toggleUnit(label == 'KG'),
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildStick({required bool isTall, Color color = Colors.white}) {
    return Container(
      width: 3,
      height: isTall ? 50 : 25,
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
          onPressed: () {
            Navigator.of(context).pushNamed('/height-selection');
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
