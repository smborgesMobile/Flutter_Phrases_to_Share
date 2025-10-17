import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../data/google_sign_in_service.dart';
import '../../domain/auth_user.dart';

class LoginPage extends StatefulWidget {
  final void Function(AuthUser user)? onSignedIn;
  const LoginPage({super.key, this.onSignedIn});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _service = GoogleSignInService();
  bool _loading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _loading = true);
    try {
      final user = await _service.signIn();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bem-vindo!')));
      widget.onSignedIn?.call(user);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro no login: ${e.toString()}')));
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 160, height: 160, child: Lottie.network('https://assets3.lottiefiles.com/packages/lf20_jcikwtux.json')),
                const SizedBox(height: 18),
                Text('Entrar', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Use sua conta Google para começar a compartilhar frases', textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          'G',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    label: _loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Continuar com Google'),
                    onPressed: _loading ? null : _handleGoogleSignIn,
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {},
                  child: const Text('Entrar como visitante'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
