import 'package:flutter/material.dart';
import 'package:fitbody/core/constants/colors.dart';
import 'package:fitbody/widgets/common/custom_button.dart';
import 'package:fitbody/features/auth/presentation/providers/auth_provider.dart';
import 'package:fitbody/services/storage_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;
  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged(String value) {
    if (!_submitted) return;
    setState(() => _emailError = AuthProvider.validateEmail(value));
  }

  void _onPasswordChanged(String value) {
    if (!_submitted) return;
    setState(() => _passwordError = AuthProvider.validatePassword(value));
  }

  Future<void> _onLogin() async {
    setState(() => _submitted = true);
    final emailError = AuthProvider.validateEmail(_emailController.text);
    final passwordError = AuthProvider.validatePassword(_passwordController.text);
    setState(() {
      _emailError = emailError;
      _passwordError = passwordError;
    });
    if (emailError == null && passwordError == null) {
      final storage = await StorageService.getInstance();
      final storedEmail = storage.getString('signup_email');
      final storedPassword = storage.getString('signup_password');
      if (_emailController.text.trim() == storedEmail &&
          _passwordController.text == storedPassword) {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/set-fingerprint');
        }
      } else if (mounted) {
        setState(() {
          _passwordError = 'Invalid email or password';
        });
      }
    }
  }

  bool get _isFormValid {
    return _emailController.text.trim().isNotEmpty
        && _passwordController.text.isNotEmpty
        && _emailError == null
        && _passwordError == null;
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: _buildWelcomeSection(colors, size),
              ),
              SizedBox(height: size.height * 0.08),
              _buildBanner(context, colors, size),
              SizedBox(height: size.height * 0.03),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: _buildLoginButton(colors, size),
              ),
              SizedBox(height: size.height * 0.035),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: _buildSocialSection(colors, size),
              ),
              SizedBox(height: size.height * 0.06),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: _buildSignUpRow(colors, size),
              ),
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
            'Log In',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: size.width * 0.06,
              color: colors.secondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(width: size.width * 0.12),
      ],
    );
  }

  Widget _buildWelcomeSection(AppColorScheme colors, Size size) {
    return Column(
      children: [
        Text(
          'Welcome',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: size.width * 0.06,
            color: colors.onBackground,
          ),
        ),
        SizedBox(height: size.height * 0.015),
        Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: size.width * 0.03,
            color: colors.textSecondary,
            height: 1,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBanner(BuildContext context, AppColorScheme colors, Size size) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.02,
        horizontal: size.width * 0.09,
      ),
      decoration: BoxDecoration(
        color: colors.primary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Username or email',
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
          SizedBox(height: size.height * 0.02),
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
              color: Colors.black,
              letterSpacing: 3,
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
              errorText: _passwordError,
              errorStyle: TextStyle(
                color: colors.error,
                fontSize: size.width * 0.03,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          SizedBox(height: size.height * 0.008),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pushNamed('/forgot-password'),
              child: Text(
                'Forgot password?',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: size.width * 0.032,
                  color: colors.surface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(AppColorScheme colors, Size size) {
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
        child: CustomButton(
          width: size.width * 0.5,
          height: size.height * 0.058,
          text: 'Log In',
          onPressed: !_isFormValid && _submitted ? null : _onLogin,
        ),
      ),
    );
  }

  Widget _buildSocialSection(AppColorScheme colors, Size size) {
    return Column(
      children: [
        Text(
          'or Sign In with',
          style: TextStyle(
            fontFamily: 'LeagueSpartan',
            fontSize: size.width * 0.035,
            color: colors.textSecondary,
          ),
        ),
        SizedBox(height: size.height * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _socialButton('assets/images/Gmail.png', size, colors),
            SizedBox(width: size.width * 0.04),
            _socialButton('assets/images/facebook.png', size, colors),
            SizedBox(width: size.width * 0.04),
            _socialButton('assets/images/fingerprint.png', size, colors),
          ],
        ),
      ],
    );
  }

  Widget _socialButton(String image, Size size, AppColorScheme colors) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Container(
          width: size.width * 0.10,
          height: size.width * 0.10,
          decoration: BoxDecoration(
            color: colors.onBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Image.asset(
            image,
            width: size.width * 0.06,
            height: size.width * 0.06,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpRow(AppColorScheme colors, Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(
            fontFamily: 'LeagueSpartan',
            fontSize: size.width * 0.04,
            color: colors.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).pushNamed('/signup'),
          child: Text(
            'Sign Up',
            style: TextStyle(
              fontFamily: 'LeagueSpartan',
              fontSize: size.width * 0.04,
              color: colors.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
