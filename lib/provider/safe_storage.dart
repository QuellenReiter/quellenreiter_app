import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Interface for the [SafeStoragePlugin] and [SafeStorageTesting]
abstract class SafeStorageInterface {
  Future<void> write({required String key, required String value});
  Future<String?> read({required String key});
  Future<void> delete({required String key});
}

/// implements the [SafeStorageInterface] and saves in a secure way using
/// the SecureStorage Plugin for iOS and Android.
class SafeStoragePlugin implements SafeStorageInterface {
  const SafeStoragePlugin();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  Future<void> delete({required String key}) {
    return _storage.delete(key: key);
  }

  @override
  Future<String?> read({required String key}) {
    return _storage.read(key: key);
  }

  @override
  Future<void> write({required String key, required String value}) {
    return _storage.write(key: key, value: value);
  }
}

/// implements the [SafeStorageInterface] but does not save in a secure
/// way. Used ONLY for testing.
/// This is a singleton.
class SafeStorageTesting implements SafeStorageInterface {
  final Map<String, String> _storage = {};
  // A factory constructor, that make sure, that there always is only one instance of this class.
  factory SafeStorageTesting() {
    return _instance;
  }

  SafeStorageTesting._internal();

  static final SafeStorageTesting _instance = SafeStorageTesting._internal();

  @override
  Future<void> delete({required String key}) {
    _storage.remove(key);
    return Future.value();
  }

  @override
  Future<String?> read({required String key}) {
    return Future.value(_storage[key]);
  }

  @override
  Future<void> write({required String key, required String value}) {
    _storage[key] = value;
    return Future.value();
  }
}
