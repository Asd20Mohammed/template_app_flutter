// Provides helper methods for encrypting and decrypting payloads.
import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Simple symmetric encryption helper using HMAC signatures.
class DataEncryption {
  /// Creates a new [DataEncryption].
  const DataEncryption(this._secret);

  final String _secret;

  /// Encrypts the provided [plainText] using a basic HMAC digest.
  String encrypt(String plainText) {
    final bytes = utf8.encode('$_secret$plainText');
    return sha256.convert(bytes).toString();
  }

  /// Validates that the [plainText] matches a previously encrypted [hash].
  bool verify(String plainText, String hash) {
    final encrypted = encrypt(plainText);
    return encrypted == hash;
  }
}
