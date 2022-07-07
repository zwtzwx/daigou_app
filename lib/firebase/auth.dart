import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

/*
  google、facebook 登录
 */
class GoogleAndFacebookAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late final GoogleSignIn _googleAuth;
  late final FacebookAuth _facebookAuth;

  GoogleAndFacebookAuth() {
    _googleAuth = GoogleSignIn(
      scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly'],
    );
    _facebookAuth = FacebookAuth.instance;
  }

  // google 登录
  Future<String?> signInGoogle() async {
    GoogleSignInAccount? account =
        await _googleAuth.signIn().onError((error, stackTrace) {
      print(error.toString());
    });
    GoogleSignInAuthentication? googleAuth = await account?.authentication;
    if (googleAuth != null) {
      OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user?.getIdToken();
    }
    return null;
  }

  // facebook 登录
  Future<String?> signInFacebook() async {
    LoginResult result = await _facebookAuth.login();
    if (result.accessToken != null) {
      OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(facebookAuthCredential);
      return userCredential.user?.getIdToken();
    }
    return null;
  }
}
