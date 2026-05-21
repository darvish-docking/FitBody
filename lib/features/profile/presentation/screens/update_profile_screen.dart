import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fitbody/core/constants/colors.dart';
import 'package:fitbody/features/auth/presentation/providers/user_provider.dart';
import 'package:fitbody/services/storage_service.dart';
import 'package:fitbody/widgets/common/bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  String _profileImagePath = '';
  String _userName = '';
  String _userEmail = '';
  int _currentNavIndex = 3;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final storage = await StorageService.getInstance();
    if (!mounted) return;
    final userProvider = context.read<UserProvider>();

    final name = storage.getString('signup_name') ?? '';
    final email = storage.getString('signup_email') ?? '';
    final phone = storage.getString('signup_phone') ?? '';
    final dob = storage.getString('user_dob') ?? '';
    final imagePath = storage.getString('signup_profile_image') ?? '';

    final user = userProvider.user;
    final weight = user?.weight ?? 0;
    final height = user?.height ?? 0;

    if (mounted) {
      setState(() {
        _userName = name;
        _userEmail = email;
        _profileImagePath = imagePath;
        _nameController.text = name;
        _emailController.text = email;
        _phoneController.text = phone;
        _dobController.text = dob;
        _weightController.text = weight > 0 ? weight.toString() : '';
        _heightController.text = height > 0 ? height.toString() : '';
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final storage = await StorageService.getInstance();
      await storage.setString('signup_profile_image', image.path);
      if (mounted) {
        setState(() {
          _profileImagePath = image.path;
        });
      }
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      _dobController.text = '${date.day}/${date.month}/${date.year}';
    }
  }

  int _calculateAge(String dob) {
    final parts = dob.split('/');
    if (parts.length != 3) return 0;
    try {
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final birthDate = DateTime(year, month, day);
      final today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (_) {
      return 0;
    }
  }

  String _formatDob(String dob) {
    final parts = dob.split('/');
    if (parts.length != 3) return dob;
    try {
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
      if (month < 1 || month > 12) return dob;
      String suffix = 'th';
      if (day == 1 || day == 21 || day == 31) suffix = 'st';
      else if (day == 2 || day == 22) suffix = 'nd';
      else if (day == 3 || day == 23) suffix = 'rd';
      return '${months[month - 1]} $day$suffix';
    } catch (_) {
      return dob;
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final storage = await StorageService.getInstance();
    if (!mounted) return;
    final userProvider = context.read<UserProvider>();

    await storage.setString('signup_name', _nameController.text.trim());
    await storage.setString('signup_email', _emailController.text.trim());
    await storage.setString('signup_phone', _phoneController.text.trim());
    await storage.setString('user_dob', _dobController.text.trim());

    final weight = double.tryParse(_weightController.text.trim()) ?? 0;
    final height = double.tryParse(_heightController.text.trim()) ?? 0;
    final age = _calculateAge(_dobController.text.trim());

    await userProvider.updateProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      weight: weight,
      height: height,
      age: age,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.of(context).pop();
    }
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
            children: [
              _buildBannerSection(size, colors),
              SizedBox(height: size.height * 0.08),
              _buildForm(size, colors),
              SizedBox(height: size.height * 0.03),
              _buildUpdateButton(size, colors),
              SizedBox(height: size.height * 0.03),
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

  Widget _buildBannerSection(Size size, AppColorScheme colors) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;
    final weight = user?.weight ?? 0;
    final age = user?.age ?? 0;
    final height = user?.height ?? 0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: size.height * 0.02,
            bottom: size.height * 0.08,
          ),
          color: colors.primary,
          child: Column(
            children: [
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
                      'My Profile',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: size.width * 0.055,
                        fontWeight: FontWeight.w600,
                        color: colors.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  CircleAvatar(
                    radius: size.width * 0.15,
                    backgroundColor: colors.cardBackground,
                    backgroundImage: _profileImagePath.isNotEmpty
                        ? FileImage(File(_profileImagePath))
                        : const AssetImage('assets/images/women.png') as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: colors.secondary,
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.surface, width: 2),
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
              ),
              SizedBox(height: size.height * 0.01),
              Text(
                _userName,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: colors.onPrimary,
                ),
              ),
              Text(
                _userEmail,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: size.width * 0.03,
                  color: colors.onPrimary,
                ),
              ),
              Text.rich(
                TextSpan(
                  text: 'Birthday: ',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: size.width * 0.03,
                    color: colors.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: _dobController.text.isNotEmpty ? _formatDob(_dobController.text) : 'Not set',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: size.width * 0.03,
                        color: colors.onPrimary,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: size.width * 0.05,
          right: size.width * 0.05,
          bottom: -size.height * 0.04,
          child: _buildStatsCard(weight, age, height, size, colors),
        ),
      ],
    );
  }

  Widget _buildStatsCard(double weight, int age, double height, Size size, AppColorScheme colors) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
      decoration: BoxDecoration(
        color: colors.statusCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _buildStatItem('${weight.toInt()} kg', 'Weight', size, colors)),
          Container(width: 1, height: size.height * 0.05, color: colors.onSurface),
          Expanded(child: _buildStatItem('$age', 'Years old', size, colors)),
          Container(width: 1, height: size.height * 0.05, color: colors.onSurface),
          Expanded(child: _buildStatItem('${height.toInt()} cm', 'Height', size, colors)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Size size, AppColorScheme colors) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'LeagueSpartan',
            fontSize: size.width * 0.04,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        SizedBox(height: size.height * 0.001),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'LeagueSpartan',
            fontSize: size.width * 0.04,
            color: colors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildForm(Size size, AppColorScheme colors) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildTextField('Full Name', _nameController, size, colors),
            SizedBox(height: size.height * 0.02),
            _buildTextField('Email', _emailController, size, colors),
            SizedBox(height: size.height * 0.02),
            _buildTextField(
              'Mobile Number', _phoneController, size, colors,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
            ),
            SizedBox(height: size.height * 0.02),
            _buildTextField(
              'Date of Birth', _dobController, size, colors,
              readOnly: true,
              onTap: _pickDate,
            ),
            SizedBox(height: size.height * 0.02),
            _buildTextField(
              'Weight', _weightController, size, colors,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
            ),
            SizedBox(height: size.height * 0.02),
            _buildTextField(
              'Height', _heightController, size, colors,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    Size size,
    AppColorScheme colors, {
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'LeagueSpartan',
            fontSize: size.width * 0.04,
            color: colors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: size.height * 0.006),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          readOnly: readOnly,
          onTap: onTap,
          style: TextStyle(
            fontFamily: 'LeagueSpartan',
            fontSize: size.width * 0.05,
            color: colors.surface,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.onPrimary,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: size.width * 0.04,
              vertical: size.height * 0.01,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateButton(Size size, AppColorScheme colors) {
    return SizedBox(
      width: size.width * 0.5,
      height: size.height * 0.06,
      child: ElevatedButton(
        onPressed: _updateProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.secondary,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(
          'Update Profile',
          style: TextStyle(
            fontFamily: 'LeagueSpartan',
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
