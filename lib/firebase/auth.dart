import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/*
  google、apple 登录
 */
class GoogleAndAppleAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late final GoogleSignIn _googleAuth;

  GoogleAndAppleAuth() {
    _googleAuth = GoogleSignIn(
      scopes: ['email'],
    );
  }

  // google 登录
  Future<String?> signInGoogle() async {
    try {
      GoogleSignInAccount? account = await _googleAuth.signIn();
      GoogleSignInAuthentication? googleAuth = await account?.authentication;
      if (googleAuth != null) {
        OAuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
        UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        return userCredential.user?.getIdToken();
      }
    } catch (error) {
      if (error is PlatformException) {
        Util.showToast(error.code);
      }
      return null;
    }
    return null;
  }

  // apple 登录
  Future<String?> signInApple() async {
    try {
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);
      AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
      OAuthCredential oAuthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(oAuthCredential);
      return userCredential.user?.getIdToken();
    } catch (error) {
      if (error is PlatformException) {
        Util.showToast(error.code);
      }
      return null;
    }
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
