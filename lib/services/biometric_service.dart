// lib/services/biometric_service.dart
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static const String _biometricRegisteredKey = 'biometric_registered';

  Future<bool> checkBiometricSupport() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return isAvailable || isDeviceSupported;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isBiometricRegistered() async {
    final registered = await _secureStorage.read(key: _biometricRegisteredKey);
    return registered == 'true';
  }

  Future<bool> registerBiometric() async {
    try {
      final isSupported = await checkBiometricSupport();
      if (!isSupported) return false;

      final authenticated = await _localAuth.authenticate(
        localizedReason: 'سجل بصمتك لحماية كلمات المرور الخاصة بك',
        options: const AuthenticationOptions(
          stickyAuth: false,
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        // ✅ الحل: حفظ حالة التسجيل في secure storage
        await _secureStorage.write(key: _biometricRegisteredKey, value: 'true');
        print("تم تسجيل البصمة بنجاح وحفظ الحالة");
        return true;
      }
      return false;
    } catch (e) {
      print('Error registering biometric: $e');
      return false;
    }
  }

  bool _isAuthenticating = false;

  Future<bool> authenticate() async {
    if (_isAuthenticating) return false;

    _isAuthenticating = true;

    try {
      final result = await _localAuth.authenticate(
        localizedReason: 'الرجاء المصادقة للوصول إلى كلمات المرور',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: false,
        ),
      );

      return result;
    } finally {
      _isAuthenticating = false;
    }
  }

  // ✅ دالة لإعادة تعيين البصمة (لتغيير الإعدادات)
  Future<void> resetBiometric() async {
    await _secureStorage.delete(key: _biometricRegisteredKey);
  }
}