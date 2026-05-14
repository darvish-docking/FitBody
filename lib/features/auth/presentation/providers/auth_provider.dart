import 'package:flutter/material.dart';
import 'package:fitbody/services/biometric_service.dart';
import 'package:fitbody/services/storage_service.dart';

enum AuthStatus { uninitialized, authenticated, unauthenticated, loading }

class AuthProvider extends ChangeNotifier {
  final BiometricService _biometricService = BiometricService();
  StorageService? _storageService;

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
    _storageService = await StorageService.getInstance();
    _isBiometricAvailable = await _biometricService.isBiometricAvailable();
    _isBiometricEnabled = _storageService!.getBool('biometric_enabled') ?? false;
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

  Future<void> toggleBiometric(bool value) async {
    _isBiometricEnabled = value;
    await _storageService!.setBool('biometric_enabled', value);
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
}
