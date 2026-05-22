import 'package:flutter/material.dart';
import 'package:fitbody/core/constants/colors.dart';
import 'package:fitbody/widgets/common/bottom_nav_bar.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _generalNotification = true;
  bool _sound = true;
  bool _dnd = false;
  bool _vibrate = true;
  bool _lockScreen = true;
  bool _reminders = false;
  int _currentNavIndex = 3;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final size = MediaQuery.sizeOf(context);

    final toggles = [
      {'label': 'General Notification', 'value': _generalNotification},
      {'label': 'Sound', 'value': _sound},
      {'label': "Don't Disturb Mode", 'value': _dnd},
      {'label': 'Vibrate', 'value': _vibrate},
      {'label': 'Lock screen', 'value': _lockScreen},
      {'label': 'Reminders', 'value': _reminders},
    ];

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                        SizedBox(height: size.height * 0.03),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Image.asset(
                      'assets/images/left_arrow.png',
                      width: size.width * 0.05,
                      color: colors.secondary,
                    ),
                  ),
                  SizedBox(width: size.width * 0.03),
                  Text(
                    'Notification settings',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: size.width * 0.055,
                      fontWeight: FontWeight.w600,
                      color: colors.statusCard,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.04),
            ...toggles.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return _buildToggleItem(
                item['label'] as String,
                item['value'] as bool,
                index,
                size,
                colors,
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (index) => setState(() => _currentNavIndex = index),
      ),
    );
  }

  Widget _buildToggleItem(String label, bool value, int index, Size size, AppColorScheme colors) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onToggle(index),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.04,
            vertical: size.height * 0.008,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'LeagueSpartan',
                    fontSize: size.width * 0.045,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              Transform.scale(
                scale: 0.7,
                child: SwitchTheme(
                  data: SwitchThemeData(
                    trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                  ),
                  child: Switch(
                    value: value,
                    onChanged: (_) => _onToggle(index),
                    activeTrackColor: colors.secondary,
                    inactiveTrackColor: colors.primary,
                    activeThumbColor: colors.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onToggle(int index) {
    setState(() {
      switch (index) {
        case 0: _generalNotification = !_generalNotification;
        case 1: _sound = !_sound;
        case 2: _dnd = !_dnd;
        case 3: _vibrate = !_vibrate;
        case 4: _lockScreen = !_lockScreen;
        case 5: _reminders = !_reminders;
      }
    });
  }
}
