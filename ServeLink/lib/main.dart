import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ServeLinkApp());
}

class ServeLinkApp extends StatelessWidget {
  const ServeLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ServeLink',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}