import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:fitbody/core/constants/colors.dart';
import 'package:fitbody/features/auth/presentation/providers/auth_provider.dart';
import 'package:fitbody/services/storage_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _nameError;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  String? _confirmError;
  bool _submitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onFieldChanged(String? field) {
    if (!_submitted) return;
    setState(() {
      if (field == null || field == 'name') {
        _nameError = AuthProvider.validateName(_nameController.text);
      }
      if (field == null || field == 'email') {
        _emailError = AuthProvider.validateEmail(_emailController.text);
      }
      if (field == null || field == 'phone') {
        _phoneError = AuthProvider.validatePhone(_phoneController.text);
      }
      if (field == null || field == 'password') {
        _passwordError = AuthProvider.validatePassword(_passwordController.text);
      }
      if (field == null || field == 'confirm') {
        _confirmError = AuthProvider.validateConfirmPassword(_confirmPasswordController.text, _passwordController.text);
      }
    });
  }

  Future<void> _onSignUp() async {
    setState(() => _submitted = true);
    final nameError = AuthProvider.validateName(_nameController.text);
    final emailError = AuthProvider.validateEmail(_emailController.text);
    final phoneError = AuthProvider.validatePhone(_phoneController.text);
    final passwordError = AuthProvider.validatePassword(_passwordController.text);
    final confirmError = AuthProvider.validateConfirmPassword(_confirmPasswordController.text, _passwordController.text);
    setState(() {
      _nameError = nameError;
      _emailError = emailError;
      _phoneError = phoneError;
      _passwordError = passwordError;
      _confirmError = confirmError;
    });
    if (nameError == null && emailError == null && phoneError == null && passwordError == null && confirmError == null) {
      await _saveSignupData();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  Future<void> _saveSignupData() async {
    final storage = await StorageService.getInstance();
    await storage.setString('signup_name', _nameController.text.trim());
    await storage.setString('signup_email', _emailController.text.trim());
    await storage.setString('signup_phone', _phoneController.text.trim());
    await storage.setString('signup_password', _passwordController.text);
  }

  bool get _isFormValid {
    return _nameController.text.trim().isNotEmpty
        && _emailController.text.trim().isNotEmpty
        && _phoneController.text.trim().isNotEmpty
        && _passwordController.text.isNotEmpty
        && _confirmPasswordController.text.isNotEmpty
        && _nameError == null
        && _emailError == null
        && _phoneError == null
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
              SizedBox(height: size.height * 0.04),
              _buildTitleSection(colors, size),
              SizedBox(height: size.height * 0.04),
              _buildBanner(colors, size),
              SizedBox(height: size.height * 0.025),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: _buildTermsText(colors, size),
              ),
              SizedBox(height: size.height * 0.03),
              _buildSignUpButton(colors, size),
              SizedBox(height: size.height * 0.025),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: _buildSocialSection(colors, size),
              ),
              SizedBox(height: size.height * 0.04),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: _buildLoginRow(colors, size),
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
            'Create Account',
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
        "Let's start!",
        style: TextStyle(
          fontFamily: 'LeagueSpartan',
          fontWeight: FontWeight.bold,
          fontSize: size.width * 0.07,
          color: colors.textPrimary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildBanner(AppColorScheme colors, Size size) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.025,
        horizontal: size.width * 0.09,
      ),
      decoration: BoxDecoration(
        color: colors.primary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('Full name', colors, size),
          SizedBox(height: size.height * 0.008),
          _buildTextField(_nameController, 'name', size, colors),
          SizedBox(height: size.height * 0.016),
          _buildLabel('Email', colors, size),
          SizedBox(height: size.height * 0.008),
          _buildTextField(_emailController, 'email', size, colors),
          SizedBox(height: size.height * 0.016),
          _buildLabel('Phone number', colors, size),
          SizedBox(height: size.height * 0.008),
          _buildTextField(_phoneController, 'phone', size, colors,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
          ),
          SizedBox(height: size.height * 0.016),
          _buildLabel('Password', colors, size),
          SizedBox(height: size.height * 0.008),
          _buildPasswordField(_passwordController, 'password', size, colors),
          SizedBox(height: size.height * 0.016),
          _buildLabel('Confirm password', colors, size),
          SizedBox(height: size.height * 0.008),
          _buildPasswordField(_confirmPasswordController, 'confirm', size, colors, isConfirm: true),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, AppColorScheme colors, Size size) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'LeagueSpartan',
        fontSize: size.width * 0.045,
        color: colors.surface,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String field,
    Size size,
    AppColorScheme colors, {
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      onChanged: (_) => _onFieldChanged(field),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: size.width * 0.04,
        color: colors.surface,
      ),
      decoration: _inputDecoration(size, colors, field),
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    String field,
    Size size,
    AppColorScheme colors, {
    bool isConfirm = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isConfirm ? _obscureConfirm : _obscurePassword,
      obscuringCharacter: '*',
      onChanged: (_) => _onFieldChanged(field),
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: size.width * 0.04,
        color: colors.surface,
        letterSpacing: 3,
      ),
      decoration: _inputDecoration(size, colors, field),
    );
  }

  InputDecoration _inputDecoration(Size size, AppColorScheme colors, String field) {
    String? errorText;
    if (field == 'name') {
      errorText = _nameError;
    } else if (field == 'email') {
      errorText = _emailError;
    } else if (field == 'phone') {
      errorText = _phoneError;
    } else if (field == 'password') {
      errorText = _passwordError;
    } else if (field == 'confirm') {
      errorText = _confirmError;
    }

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

  Widget _buildTermsText(AppColorScheme colors, Size size) {
    return Text.rich(
      TextSpan(
        text: 'By continuing, you agree to \n',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: size.width * 0.032,
          color: colors.textSecondary,
        ),
        children: [
          TextSpan(
            text: 'Terms of Use',
            style: TextStyle(
              color: colors.secondary,
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {},
          ),
          TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy.',
            style: TextStyle(
              color: colors.secondary,
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {},
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSignUpButton(AppColorScheme colors, Size size) {
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
            onPressed: !_isFormValid && _submitted ? null : _onSignUp,
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
            child: const Text('Sign Up'),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialSection(AppColorScheme colors, Size size) {
    return Column(
      children: [
        Text(
          'or Sign Up with',
          style: TextStyle(
            fontFamily: 'LeagueSpartan',
            fontSize: size.width * 0.035,
            color: colors.textSecondary,
          ),
        ),
        SizedBox(height: size.height * 0.015),
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

  Widget _buildLoginRow(AppColorScheme colors, Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(
            fontFamily: 'LeagueSpartan',
            fontSize: size.width * 0.04,
            color: colors.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).pushReplacementNamed('/login'),
          child: Text(
            'Log In',
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
