import 'dart:math';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static SecureStorageService? _instance;
  late final FlutterSecureStorage _storage;

  SecureStorageService._() {
    _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    );
  }

  static SecureStorageService getInstance() {
    _instance ??= SecureStorageService._();
    return _instance!;
  }

  Future<bool> isBiometricEnabled() async {
    final value = await _storage.read(key: _Keys.biometricEnabled);
    return value == 'true';
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(key: _Keys.biometricEnabled, value: enabled.toString());
  }

  Future<String?> getBiometricToken() async {
    return await _storage.read(key: _Keys.biometricToken);
  }

  Future<String> generateBiometricToken() async {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    final token = base64Url.encode(bytes);
    await _storage.write(key: _Keys.biometricToken, value: token);
    return token;
  }

  Future<void> clearBiometricData() async {
    await _storage.delete(key: _Keys.biometricEnabled);
    await _storage.delete(key: _Keys.biometricToken);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}

abstract class _Keys {
  static const biometricEnabled = 'biometric_enabled';
  static const biometricToken = 'biometric_token';
}
