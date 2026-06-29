import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class Prefs {
  ///
  /// Pref Keys
  
  static const String _kUser = "user";
  // static const String _kUserSecrets = "userSecrets";
  static const String clockStatus = "clockStatus";
  static const String kAttendanceId = "attendanceId";
  static const String kAccessToken = "accessToken";
  static const String kDownloadedFiles = "downloadFiles";

  final _secureStorage = FlutterSecureStorage();

  Future<void> store(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }

  ///
  /// Here we manage app configs
  ///
  Future<void> storeToken(String? token) async {
    try {
      await store(kAccessToken, token!);
      print("Store token complete");
    } catch (e) {
      // appPrint('Failed to store token');
    }
  }

  Future<String?> fetchToken() async {
    try {
      return await read(kAccessToken);
    } catch (e) {
      throw ('Token not found');
    }
  }

  Future<void> deleteToken() async {
    try {
      await delete(kAccessToken);
    } catch (e) {
      // appPrint('Failed to delete token');
    }
  }

  Future<void> storeUser(User? user) async {
    try {
      await store(_kUser, jsonEncode(user));
    } catch (e) {
      // appPrint('User found null');
    }
  }

  Future<User?> fetchUser() async {
    try {
      String? user = await read(_kUser);
      return User.fromJson(jsonDecode(user!));
    } catch (e) {
      throw ('User not found');
    }
  }

  Future<void> deleteUser() async {
    try {
      await _secureStorage.delete(key: _kUser);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearStorage() async {
    await _secureStorage.deleteAll();
  }

  Future<void> storeList(String key, List<String> values) async {
    await _secureStorage.write(key: key, value: values.join(';'));
  }

  Future<List<String>?> readList(String key) async {
    String? value = await _secureStorage.read(key: key);
    return value?.split(';');
  }
}


class User {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;

  User({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      email: json['email'],
      displayName: json['displayName'],
      photoURL: json['photoURL'],
    );
  }

 Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
    };
  }
}