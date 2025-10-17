import 'package:google_sign_in/google_sign_in.dart';
import '../domain/auth_user.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn;

  GoogleSignInService({GoogleSignIn? googleSignIn}) : _googleSignIn = googleSignIn ?? GoogleSignIn();

  Future<AuthUser> signIn() async {
    final account = await _googleSignIn.signIn();
    if (account == null) throw Exception('Login cancelled or failed');

    return AuthUser(
      id: account.id,
      name: account.displayName ?? account.email.split('@').first,
      email: account.email,
      photoUrl: account.photoUrl,
    );
  }

  Future<void> signOut() => _googleSignIn.signOut();
}
