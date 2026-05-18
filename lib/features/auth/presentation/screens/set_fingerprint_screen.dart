import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitbody/core/constants/colors.dart';
import 'package:fitbody/features/auth/presentation/providers/auth_provider.dart';
import 'package:fitbody/features/auth/presentation/screens/setup_screen.dart';

class SetFingerprintScreen extends StatefulWidget {
  const SetFingerprintScreen({super.key});

  @override
  State<SetFingerprintScreen> createState() => _SetFingerprintScreenState();
}

class _SetFingerprintScreenState extends State<SetFingerprintScreen> {
  bool _isLoading = false;
  bool _biometricVerified = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _autoScan());
  }

  Future<void> _autoScan() async {
    setState(() => _isLoading = true);
    try {
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.setupBiometric();
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _biometricVerified = success;
      });
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No biometric or device credentials set up. Please set a screen lock in your device settings.'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _onContinue() async {
    if (_biometricVerified) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      return;
    }
    setState(() => _isLoading = true);
    try {
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.setupBiometric();
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _biometricVerified = success;
      });
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No biometric or device credentials set up. Please set a screen lock in your device settings.'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _onSkip() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SetupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
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
                  SizedBox(height: size.height * 0.04),
                  _buildBanner(colors, size),
                  SizedBox(height: size.height * 0.06),
                  _buildButtons(colors, size),
                  SizedBox(height: size.height * 0.03),
                ],
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black26,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
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
            'Set Your Fingerprint',
            style: TextStyle(
              fontFamily: 'LeagueSpartan',
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
        horizontal: size.width * 0.13,
      ),
      decoration: BoxDecoration(
        color: colors.primary,
      ),
      child: Center(
        child: Image.asset(
          'assets/images/fingerprint_large.png',
          width: size.width * 0.6,
          height: size.width * 0.6,
        ),
      ),
    );
  }

  Widget _buildButtons(AppColorScheme colors, Size size) {
    return Column(
      children: [
        Center(
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
                onPressed: _isLoading ? null : _onSkip,
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
                child: const Text('Skip'),
              ),
            ),
          ),
        ),
        SizedBox(height: size.height * 0.02),
        Center(
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
                onPressed: _isLoading ? null : _onContinue,
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
        ),
      ],
    );
  }
}
