import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
 
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF7B2CBF),
              Color(0xFFFF6B6B),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fade,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: Lottie.network(
                      'https://assets7.lottiefiles.com/packages/lf20_tll0j4bb.json',
                      fit: BoxFit.contain,
                      repeat: true,
                      
                      frameBuilder: (context, child, composition) {
                        if (composition == null) return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white70)));
                        return child;
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Frases para compartilhar',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      )),
                  const SizedBox(height: 8),
                  Text('Palavras que conectam',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      )),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: 140,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white24,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text('Feito com ❤️', style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
