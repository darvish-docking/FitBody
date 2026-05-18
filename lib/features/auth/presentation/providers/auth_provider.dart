import 'package:flutter/material.dart';
import 'package:fitbody/services/biometric_service.dart';
import 'package:fitbody/services/storage_service.dart';
import 'package:fitbody/services/secure_storage_service.dart';

enum AuthStatus { uninitialized, authenticated, unauthenticated, loading }

class AuthProvider extends ChangeNotifier {
  final BiometricService _biometricService = BiometricService();
  StorageService? _storageService;
  late final SecureStorageService _secureStorage;

  AuthStatus _status = AuthStatus.uninitialized;
  bool _isBiometricEnabled = false;
  bool _isBiometricAvailable = false;
  String? _error;

  AuthStatus get status => _status;
  bool get isBiometricEnabled => _isBiometricEnabled;
  bool get isBiometricAvailable => _isBiometricAvailable;
  String? get error => _error;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    _secureStorage = SecureStorageService.getInstance();
    _storageService = await StorageService.getInstance();
    _isBiometricAvailable = await _biometricService.isBiometricAvailable();
    _isBiometricEnabled = await _secureStorage.isBiometricEnabled();
    final isLoggedIn = _storageService!.getBool('is_logged_in') ?? false;

    if (isLoggedIn) {
      await Future.delayed(const Duration(seconds: 1));
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      await _storageService!.setBool('is_logged_in', true);
      await _storageService!.setString('user_email', email);
      _status = AuthStatus.authenticated;
      notifyListeners();
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      await _storageService!.setBool('is_logged_in', true);
      await _storageService!.setString('user_email', email);
      _status = AuthStatus.authenticated;
      notifyListeners();
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> authenticateWithBiometric() async {
    final authenticated = await _biometricService.authenticate(
      reason: 'Authenticate to access your FitBody account',
    );
    if (authenticated) {
      await _storageService!.setBool('is_logged_in', true);
      _status = AuthStatus.authenticated;
      notifyListeners();
    }
    return authenticated;
  }

  Future<bool> setupBiometric() async {
    final authenticated = await _biometricService.authenticate(
      reason: 'Set up fingerprint to secure your FitBody account',
    );
    if (authenticated) {
      await _secureStorage.setBiometricEnabled(true);
      await _secureStorage.generateBiometricToken();
      _isBiometricEnabled = true;
      notifyListeners();
    }
    return authenticated;
  }

  Future<void> toggleBiometric(bool value) async {
    _isBiometricEnabled = value;
    if (value) {
      await _secureStorage.setBiometricEnabled(true);
      await _secureStorage.generateBiometricToken();
    } else {
      await _secureStorage.clearBiometricData();
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await _storageService!.setBool('is_logged_in', false);
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  static String? validateName(String value) {
    if (value.trim().isEmpty) return 'Full name is required';
    if (value.trim().length < 3) return 'Name must be at least 3 characters';
    return null;
  }

  static String? validatePhone(String value) {
    if (value.trim().isEmpty) return 'Phone number is required';
    if (value.trim().length < 10) return 'Enter a valid phone number';
    if (!RegExp(r'^\+?\d{10,15}$').hasMatch(value.trim())) return 'Enter a valid phone number';
    return null;
  }

  static String? validateConfirmPassword(String value, String password) {
    if (value.isEmpty) return 'Please confirm your password';
    if (value != password) return 'Passwords do not match';
    return null;
  }

  static String? validateEmail(String value) {
    if (value.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Must contain an uppercase letter';
    if (!RegExp(r'[a-z]').hasMatch(value)) return 'Must contain a lowercase letter';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Must contain a digit';
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_]').hasMatch(value)) return 'Must contain a special character';
    return null;
  }
}
