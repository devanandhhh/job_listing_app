import 'package:flutter/material.dart';

/// Simple animated splash screen.
/// Location: lib/presentation/screens/splash_screen.dart
///
/// Logo fades + scales in, then after a short delay navigates
/// to nextScreen (pass HomeShell() from main.dart).
class SplashScreen extends StatefulWidget {
  final Widget nextScreen;
  const SplashScreen({super.key, required this.nextScreen});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scale = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
    _goNext();
  }

  Future<void> _goNext() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => widget.nextScreen));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF195119),
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  height: 190,
                  width: 190,
                  "assets/icons/j_icon.png",
                ), //Icon(Icons.work_rounded, size: 90, color: Colors.white),
                SizedBox(height: 16),
                Text(
                  'Jobs Here',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Find your next opportunity',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
