import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/login_screen.dart';
import '../user/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.90,
      end: 1.08,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _startApp();
  }

  Future<void> _startApp() async {
    // Keep the splash screen visible for 3 seconds.
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Check whether a user is already signed in.
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is already logged in.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } else {
      // User is not logged in.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primaryContainer,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _pulseAnimation,
                child: Image.asset(
                  'assets/images/servelink_logo.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'ServeLink',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Connect. Request. Serve.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 40),

              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}