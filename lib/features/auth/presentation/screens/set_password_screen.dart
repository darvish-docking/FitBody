import 'package:flutter/material.dart';
import 'package:fitbody/core/constants/colors.dart';
import 'package:fitbody/features/auth/presentation/providers/auth_provider.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _passwordError;
  String? _confirmError;
  bool _submitted = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onPasswordChanged(String value) {
    if (!_submitted) return;
    setState(() => _passwordError = AuthProvider.validatePassword(value));
  }

  void _onConfirmChanged(String value) {
    if (!_submitted) return;
    setState(() {
      _confirmError = AuthProvider.validateConfirmPassword(value, _passwordController.text);
    });
  }

  void _onReset() {
    setState(() => _submitted = true);
    final passwordError = AuthProvider.validatePassword(_passwordController.text);
    final confirmError = AuthProvider.validateConfirmPassword(_confirmController.text, _passwordController.text);
    setState(() {
      _passwordError = passwordError;
      _confirmError = confirmError;
    });
    if (passwordError == null && confirmError == null) {
      Navigator.of(context).pushReplacementNamed('/set-fingerprint');
    }
  }

  bool get _isFormValid {
    return _passwordController.text.isNotEmpty
        && _confirmController.text.isNotEmpty
        && _passwordError == null
        && _confirmError == null;
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: size.height * 0.025),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: _buildTopRow(context, colors, size),
              ),
              SizedBox(height: size.height * 0.08),
              _buildDescription(colors, size),
              SizedBox(height: size.height * 0.06),
              _buildBanner(colors, size),
              SizedBox(height: size.height * 0.06),
              _buildResetButton(colors, size),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopRow(BuildContext context, AppColorScheme colors, Size size) {
    return Row(
      children: [
        SizedBox(
          width: size.width * 0.12,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Image.asset(
              'assets/images/left_arrow.png',
              width: size.width * 0.05,
              height: size.width * 0.05,
            ),
          ),
        ),
        Expanded(
          child: Text(
            'Set Password',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: size.width * 0.05,
              color: colors.secondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(width: size.width * 0.12),
      ],
    );
  }

  Widget _buildDescription(AppColorScheme colors, Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Text(
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        style: TextStyle(
          fontFamily: 'LeagueSpartan',
          fontSize: size.width * 0.037,
          color: colors.textSecondary,
          height: 1,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildBanner(AppColorScheme colors, Size size) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.03,
        horizontal: size.width * 0.09,
      ),
      decoration: BoxDecoration(
        color: colors.primary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password',
            style: TextStyle(
              fontFamily: 'LeagueSpartan',
              fontSize: size.width * 0.045,
              color: colors.surface,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: size.height * 0.01),
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            obscuringCharacter: '*',
            onChanged: _onPasswordChanged,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: size.width * 0.04,
              color: colors.surface,
              letterSpacing: 3,
            ),
            decoration: _inputDecoration(size, colors, _passwordError),
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            'Confirm Password',
            style: TextStyle(
              fontFamily: 'LeagueSpartan',
              fontSize: size.width * 0.045,
              color: colors.surface,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: size.height * 0.01),
          TextField(
            controller: _confirmController,
            obscureText: _obscureConfirm,
            obscuringCharacter: '*',
            onChanged: _onConfirmChanged,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: size.width * 0.04,
              color: colors.surface,
              letterSpacing: 3,
            ),
            decoration: _inputDecoration(size, colors, _confirmError),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(Size size, AppColorScheme colors, String? errorText) {
    return InputDecoration(
      filled: true,
      fillColor: colors.onBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.012,
      ),
      errorText: errorText,
      errorStyle: TextStyle(
        color: colors.error,
        fontSize: size.width * 0.03,
        fontFamily: 'Poppins',
      ),
    );
  }

  Widget _buildResetButton(AppColorScheme colors, Size size) {
    return Center(
      child: Container(
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
            onPressed: !_isFormValid && _submitted ? null : _onReset,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.onPrimary.withValues(alpha: 0.1),
              foregroundColor: colors.onPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(color: colors.onPrimary, width: 1),
              ),
              textStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            child: const Text('Reset Password'),
          ),
        ),
      ),
    );
  }
}
