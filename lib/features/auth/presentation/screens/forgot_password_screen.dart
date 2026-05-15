import 'package:flutter/material.dart';
import 'package:fitbody/core/constants/colors.dart';
import 'package:fitbody/features/auth/presentation/providers/auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  String? _emailError;
  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onEmailChanged(String value) {
    if (!_submitted) return;
    setState(() => _emailError = AuthProvider.validateEmail(value));
  }

  void _onContinue() {
    setState(() => _submitted = true);
    final emailError = AuthProvider.validateEmail(_emailController.text);
    setState(() => _emailError = emailError);
    if (emailError == null) {
      Navigator.of(context).pushReplacementNamed('/set-password');
    }
  }

  bool get _isFormValid {
    return _emailController.text.trim().isNotEmpty && _emailError == null;
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
              SizedBox(height: size.height * 0.15),
              _buildTitleSection(colors, size),
              SizedBox(height: size.height * 0.04),
              _buildDescription(colors, size),
              SizedBox(height: size.height * 0.06),
              _buildBanner(colors, size),
              SizedBox(height: size.height * 0.04),
              _buildContinueButton(colors, size),
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
            'Forgotten Password',
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

  Widget _buildTitleSection(AppColorScheme colors, Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Text(
        'Forgotten Password?',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: size.width * 0.04,
          color: colors.textPrimary,
        ),
        textAlign: TextAlign.center,
      ),
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
            'Enter your email address',
            style: TextStyle(
              fontFamily: 'LeagueSpartan',
              fontSize: size.width * 0.045,
              color: colors.surface,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: size.height * 0.01),
          TextField(
            controller: _emailController,
            onChanged: _onEmailChanged,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: size.width * 0.04,
              color: colors.surface,
            ),
            decoration: InputDecoration(
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
              errorText: _emailError,
              errorStyle: TextStyle(
                color: colors.error,
                fontSize: size.width * 0.03,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton(AppColorScheme colors, Size size) {
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
            onPressed: !_isFormValid && _submitted ? null : _onContinue,
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
            child: const Text('Continue'),
          ),
        ),
      ),
    );
  }
}
