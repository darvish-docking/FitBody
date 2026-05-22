import 'package:flutter/material.dart';
import 'package:fitbody/core/constants/colors.dart';
import 'package:fitbody/features/auth/presentation/providers/auth_provider.dart';
import 'package:fitbody/services/storage_service.dart';
import 'package:fitbody/widgets/common/bottom_nav_bar.dart';

class PasswordSettingsScreen extends StatefulWidget {
  const PasswordSettingsScreen({super.key});

  @override
  State<PasswordSettingsScreen> createState() => _PasswordSettingsScreenState();
}

class _PasswordSettingsScreenState extends State<PasswordSettingsScreen> {
  int _currentNavIndex = 3;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  String? _currentError;
  String? _newError;
  String? _confirmError;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
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
                      'Password settings',
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Password',
                      style: TextStyle(
                        fontFamily: 'LeagueSpartan',
                        fontSize: size.width * 0.045,
                        color: colors.statusCard,
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    TextField(
                      controller: _currentController,
                      onChanged: (_) => setState(() => _currentError = null),
                      obscureText: _obscureCurrent,
                      obscuringCharacter: '*',
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureCurrent ? Icons.visibility_off : Icons.visibility,
                            color: colors.statusCard,
                          ),
                          onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.04,
                          vertical: size.height * 0.012,
                        ),
                      ),
                    ),
                    if (_currentError != null)
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.005),
                        child: Text(
                          _currentError!,
                          style: TextStyle(
                            fontFamily: 'LeagueSpartan',
                            fontSize: size.width * 0.03,
                            color: colors.error,
                          ),
                        ),
                      ),
                    SizedBox(height: size.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontFamily: 'LeagueSpartan',
                              fontSize: size.width * 0.04,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.08),
                    Text(
                      'New Password',
                      style: TextStyle(
                        fontFamily: 'LeagueSpartan',
                        fontSize: size.width * 0.045,
                        color: colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    TextField(
                      controller: _newController,
                      onChanged: (value) {
                        setState(() {
                          _newError = AuthProvider.validatePassword(value);
                          _confirmError = _confirmController.text.isNotEmpty && value != _confirmController.text
                              ? 'Passwords do not match'
                              : null;
                        });
                      },
                      obscureText: _obscureNew,
                      obscuringCharacter: '*',
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureNew ? Icons.visibility_off : Icons.visibility,
                            color: colors.statusCard,
                          ),
                          onPressed: () => setState(() => _obscureNew = !_obscureNew),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.04,
                          vertical: size.height * 0.012,
                        ),
                      ),
                    ),
                    if (_newError != null)
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.005),
                        child: Text(
                          _newError!,
                          style: TextStyle(
                            fontFamily: 'LeagueSpartan',
                            fontSize: size.width * 0.03,
                            color: colors.error,
                          ),
                        ),
                      ),
                    SizedBox(height: size.height * 0.03),
                    Text(
                      'Confirm New Password',
                      style: TextStyle(
                        fontFamily: 'LeagueSpartan',
                        fontSize: size.width * 0.045,
                        color: colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    TextField(
                      controller: _confirmController,
                      onChanged: (value) {
                        setState(() {
                          _confirmError = value.isEmpty
                              ? null
                              : value != _newController.text
                                  ? 'Passwords do not match'
                                  : null;
                        });
                      },
                      obscureText: _obscureConfirm,
                      obscuringCharacter: '*',
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                            color: colors.statusCard,
                          ),
                          onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.04,
                          vertical: size.height * 0.012,
                        ),
                      ),
                    ),
                    if (_confirmError != null)
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.005),
                        child: Text(
                          _confirmError!,
                          style: TextStyle(
                            fontFamily: 'LeagueSpartan',
                            fontSize: size.width * 0.03,
                            color: colors.error,
                          ),
                        ),
                      ),
                    SizedBox(height: size.height * 0.06),
                    Center(
                      child: SizedBox(
                        width: size.width * 0.65,
                        height: size.height * 0.055,
                        child: ElevatedButton(
                          onPressed: _changePassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.secondary,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Text(
                            'Change Password',
                            style: TextStyle(
                              fontFamily: 'LeagueSpartan',
                              fontSize: size.width * 0.05,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (index) => setState(() => _currentNavIndex = index),
      ),
    );
  }

  Future<void> _changePassword() async {
    final current = _currentController.text;
    final newPwd = _newController.text;
    final confirm = _confirmController.text;

    final newPasswordError = AuthProvider.validatePassword(newPwd);

    setState(() {
      _currentError = current.isEmpty ? 'Enter your current password' : null;
      _newError = newPwd.isEmpty ? 'Enter a new password' : newPasswordError;
      _confirmError = confirm.isEmpty ? 'Confirm your new password' : null;
    });

    if (current.isEmpty || newPwd.isEmpty || confirm.isEmpty) return;
    if (newPasswordError != null) return;

    final storage = await StorageService.getInstance();
    final storedPassword = storage.getString('signup_password');

    if (current != storedPassword) {
      setState(() => _currentError = 'Current password is incorrect');
      return;
    }

    if (newPwd != confirm) {
      setState(() => _confirmError = 'Passwords do not match');
      return;
    }

    await storage.setString('signup_password', newPwd);
    if (mounted) Navigator.of(context).pop();
  }
}
