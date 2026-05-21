import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fitbody/core/constants/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:fitbody/features/auth/presentation/providers/user_provider.dart';
import 'package:fitbody/services/storage_service.dart';

class FillProfileScreen extends StatefulWidget {
  const FillProfileScreen({super.key});

  @override
  State<FillProfileScreen> createState() => _FillProfileScreenState();
}

class _FillProfileScreenState extends State<FillProfileScreen> {
  File? _profileImage;
  final _fullnameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadSignupData();
  }

  Future<void> _loadSignupData() async {
    final storage = await StorageService.getInstance();
    _fullnameController.text = storage.getString('signup_name') ?? '';
    _nicknameController.text = storage.getString('signup_nickname') ?? '';
    _emailController.text = storage.getString('signup_email') ?? '';
    _phoneController.text = storage.getString('signup_phone') ?? '';
    final imagePath = storage.getString('signup_profile_image');
    if (imagePath != null) {
      _profileImage = File(imagePath);
    }
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _nicknameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
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
        child: SingleChildScrollView(
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
              SizedBox(height: size.height * 0.04),

              // Title text
              Center(
                child: Text(
                  "Fill Your Profile",
                  style: TextStyle(
                    fontSize: size.width * 0.07,
                    fontFamily: 'Poppins',
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.04),

              // 2 line dummy text
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

              // Banner with profile image
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                color: colors.primary,
                child: Center(
                  child: _buildProfileImage(size, colors),
                ),
              ),

              SizedBox(height: size.height * 0.04),

              // Form fields
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  _buildLabel('Full Name', colors),
                  _buildTextField(_fullnameController, colors),
                  SizedBox(height: size.height * 0.02),
                  _buildLabel('Nick Name', colors),
                  _buildTextField(_nicknameController, colors),
                  SizedBox(height: size.height * 0.02),
                  _buildLabel('Email', colors),
                  _buildTextField(_emailController, colors),
                  SizedBox(height: size.height * 0.02),
                  _buildLabel('Phone Number', colors),
                  _buildTextField(_phoneController, colors),
                  ],
                ),
              ),

              SizedBox(height: size.height * 0.04),

              // Start button (green)
              Center(
                child: _buildStartButton(size, colors),
              ),
              SizedBox(height: size.height * 0.04),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(Size size, AppColorScheme colors) {
    return Stack(
      children: [
        Container(
          width: size.width * 0.28,
          height: size.width * 0.28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: _profileImage != null
                  ? FileImage(_profileImage!)
                  : const AssetImage('assets/images/women.png') as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: size.width * 0.08,
              height: size.width * 0.08,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.secondary,
              ),
              child: Icon(
                Icons.edit,
                size: size.width * 0.04,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text, AppColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: colors.primary,
          fontSize: 20,
          fontFamily: 'LeagueSpartan',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, AppColorScheme colors) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: colors.surface),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildStartButton(Size size, AppColorScheme colors) {
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
            await storage.setString('signup_nickname', _nicknameController.text.trim());
            if (_profileImage != null) {
              await storage.setString('signup_profile_image', _profileImage!.path);
            }
            if (mounted) {
              final userProvider = context.read<UserProvider>();
              userProvider.updateProfile(
                name: _fullnameController.text,
                email: _emailController.text,
                phone: _phoneController.text,
              );
              Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.secondary,
            foregroundColor: colors.surface,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          child: const Text('Start'),
        ),
      ),
    );
  }
}
