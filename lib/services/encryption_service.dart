// lib/services/encryption_service.dart
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class EncryptionService {
  static const String _key = "YourSecretKey2024!@#"; // في التطبيق الحقيقي، استخدم مفتاح أكثر أماناً

  // تشفير بسيط باستخدام Base64 + XOR
  static String encrypt(String plainText) {
    if (plainText.isEmpty) return plainText;

    List<int> plainBytes = utf8.encode(plainText);
    List<int> keyBytes = utf8.encode(_key);
    List<int> encryptedBytes = [];

    for (int i = 0; i < plainBytes.length; i++) {
      encryptedBytes.add(plainBytes[i] ^ keyBytes[i % keyBytes.length]);
    }

    return base64.encode(encryptedBytes);
  }

  // فك التشفير
  static String decrypt(String encryptedText) {
    if (encryptedText.isEmpty) return encryptedText;

    List<int> encryptedBytes = base64.decode(encryptedText);
    List<int> keyBytes = utf8.encode(_key);
    List<int> decryptedBytes = [];

    for (int i = 0; i < encryptedBytes.length; i++) {
      decryptedBytes.add(encryptedBytes[i] ^ keyBytes[i % keyBytes.length]);
    }

    return utf8.decode(decryptedBytes);
  }

  // تشفير متقدم باستخدام SHA256
  static String encryptAdvanced(String plainText) {
    if (plainText.isEmpty) return plainText;

    final key = sha256.convert(utf8.encode(_key)).bytes;
    final plainBytes = utf8.encode(plainText);
    final encryptedBytes = <int>[];

    for (int i = 0; i < plainBytes.length; i++) {
      encryptedBytes.add(plainBytes[i] ^ key[i % key.length]);
    }

    return base64.encode(encryptedBytes);
  }

  static String decryptAdvanced(String encryptedText) {
    if (encryptedText.isEmpty) return encryptedText;

    final key = sha256.convert(utf8.encode(_key)).bytes;
    final encryptedBytes = base64.decode(encryptedText);
    final decryptedBytes = <int>[];

    for (int i = 0; i < encryptedBytes.length; i++) {
      decryptedBytes.add(encryptedBytes[i] ^ key[i % key.length]);
    }

    return utf8.decode(decryptedBytes);
  }
}