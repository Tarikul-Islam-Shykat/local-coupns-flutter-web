import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  static const token = 'token';
  static const paymentToken = 'payment_token';
  static const password = 'user_password';
  static const email = 'user_email';
  static const role = 'user_role';
  static const fcmToken = 'fcm_token';

  Future<void> set(String key, String value) =>
      _storage.write(key: key, value: value);
  Future<String?> get(String key) => _storage.read(key: key);
  Future<void> delete(String key) => _storage.delete(key: key);
  Future<void> clearAll() => _storage.deleteAll();
}


/* Usage Example 
// set
await secureStorage.set(SecureStorageService.token, 'mytoken');

// get
final token = await secureStorage.get(SecureStorageService.token);

// delete
await secureStorage.delete(SecureStorageService.token);

// to add a new key. 
static const newKey = 'new_key';
*/
