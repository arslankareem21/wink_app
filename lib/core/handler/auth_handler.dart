
// import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:wink_app/service/secure_storage.dart' ;

class AuthHandler {
  AuthHandler._instance();
  static final AuthHandler ref = AuthHandler._instance();

  // factory AuthHandler() => ref;
  User? user;
  String? acessToken;
  bool didLogOut = false;

  Prefs prefs = Prefs();
  Future<bool> get isLoggedIn async {
    try {
      String? token = await prefs.fetchToken();
      return token != null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setupUser(User? user, bool isRemember) async {
    this.user = user;
    if (isRemember) {
      await prefs.storeUser(user);
    }
    didLogOut = false;
  }

  Future<void> storeToken(String? acessToken, bool isRemember) async {
    this.acessToken = acessToken;
    if (isRemember) {
      await prefs.storeToken(acessToken);
    }
  }
  

  Future<void> init() async {
    try {
      
      didLogOut = false;
      // user = await prefs.fetchUser();
      acessToken = await prefs.fetchToken();

      // appPrint('[User]: $user');
      // appPrint('[AccessToken]: $acessToken');

    } catch (e) {
      debugPrint("Local init");
      // appPrint(e);
    }
  }

  void resetAuth() {
    didLogOut = false;
  }

  Future<void> logout() async {
    /// UseCase [didLogOut]: Avoid re-logouts on multiple Ghost login attempts.
    try {
      if (didLogOut) return;
      await prefs.deleteUser();
      await prefs.deleteToken();

      didLogOut = true;
      // AppRouterGo.pushRemoveUntil(loginScreen);
    } catch (e) {
      // appPrint(e);
    }
  }

}