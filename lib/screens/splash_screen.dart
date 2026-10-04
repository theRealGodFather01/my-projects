import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';

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

    // Create the pulse animation.
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.90,
      end: 1.10,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Wait until the first frame has finished building
    // before starting app initialization.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  Future<void> _initialize() async {
    // Load saved tasks and app settings.
    await context.read<AppProvider>().initialize();

    if (!mounted) return;

    // Keep the splash screen visible for 3 seconds
    // after initialization has completed.
    await Future.delayed(
      const Duration(seconds: 3),
    );

    if (!mounted) return;

    // Stop the animation before leaving the splash screen.
    _pulseController.stop();

    Navigator.pushReplacementNamed(
      context,
      '/home',
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pulsing TaskFlow logo.
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: child,
                );
              },
              child: Image.asset(
                'assets/images/taskflow_logo.png',
                width: 120,
                height: 120,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'TaskFlow',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}