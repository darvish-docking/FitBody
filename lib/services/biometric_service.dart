import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> isBiometricAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics || await _localAuth.isDeviceSupported();
    } on PlatformException {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException {
      return [];
    }
  }

  Future<bool> authenticate({
    String reason = 'Authenticate to access FitBody',
    String? localizedReason,
  }) async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isSupported = await _localAuth.isDeviceSupported();
      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      debugPrint('[BiometricService] canCheckBiometrics: $canCheck');
      debugPrint('[BiometricService] isDeviceSupported: $isSupported');
      debugPrint('[BiometricService] availableBiometrics: $availableBiometrics');
      return await _localAuth.authenticate(
        localizedReason: localizedReason ?? reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } on PlatformException catch (e) {
      debugPrint('[BiometricService] PlatformException code=${e.code} message=${e.message}');
      return false;
    }
  }

  Future<void> stopAuthentication() async {
    await _localAuth.stopAuthentication();
  }
}
