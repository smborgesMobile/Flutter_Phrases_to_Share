import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../domain/auth_user.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn;

  GoogleSignInService({GoogleSignIn? googleSignIn}) : _googleSignIn = googleSignIn ?? GoogleSignIn();

  Future<AuthUser> signIn() async {
    final account = await _googleSignIn.signIn();
    if (account == null) throw Exception('Login cancelled or failed');

    final auth = await account.authentication;
    try {
      // ignore: avoid_print
      print('[GoogleSignInService] auth runtimeType: ${auth.runtimeType}');
      final idToken = auth.idToken;
      final accessToken = auth.accessToken;
      // ignore: avoid_print
      print('[GoogleSignInService] idToken type: ${idToken?.runtimeType}, accessToken type: ${accessToken?.runtimeType}');

      if (idToken == null || accessToken == null) {
        // If tokens are missing, fall back to Google-only info
        return AuthUser(
          id: account.id,
          name: account.displayName ?? account.email.split('@').first,
          email: account.email,
          photoUrl: account.photoUrl,
        );
      }

      // Try to sign in to Firebase with the Google credentials. If this fails due to
      // platform/pigeon mismatches or missing native config, fall back to returning
      // an AuthUser built from the Google account so the app can continue to work.
      try {
        final credential = fb.GoogleAuthProvider.credential(idToken: idToken, accessToken: accessToken);
        final userCredential = await fb.FirebaseAuth.instance.signInWithCredential(credential);
        final user = userCredential.user;
        if (user != null) {
          return AuthUser(
            id: user.uid,
            name: user.displayName ?? user.email?.split('@').first ?? 'Usuário',
            email: user.email ?? '',
            photoUrl: user.photoURL,
          );
        }
        // If Firebase returned null user, fall back to Google account
        return AuthUser(
          id: account.id,
          name: account.displayName ?? account.email.split('@').first,
          email: account.email,
          photoUrl: account.photoUrl,
        );
      } catch (firebaseError, firebaseStack) {
        // ignore: avoid_print
        print('[GoogleSignInService] Firebase signIn failed: $firebaseError');
        // ignore: avoid_print
        print(firebaseStack);
        return AuthUser(
          id: account.id,
          name: account.displayName ?? account.email.split('@').first,
          email: account.email,
          photoUrl: account.photoUrl,
        );
      }
    } catch (e, st) {
      // ignore: avoid_print
      print('[GoogleSignInService] signIn error: $e');
      // ignore: avoid_print
      print(st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    // Attempt to sign out from Firebase if configured, but don't fail if Firebase
    // isn't initialized or signOut throws due to platform issues.
    try {
      await fb.FirebaseAuth.instance.signOut();
    } catch (_) {
      // ignore errors from Firebase native side
    }

    await _googleSignIn.signOut();
  }
}
