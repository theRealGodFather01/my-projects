import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';

class SettingsScreen
    extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider =
    context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        title:
        const Text('Settings'),
      ),

      body: ListView(
        children: [
          SwitchListTile(
            title:
            const Text('Dark Mode'),
            subtitle: const Text(
              'Use a dark appearance throughout the app.',
            ),
            value:
            provider.isDarkMode,
            onChanged:
            provider.setDarkMode,
          ),
        ],
      ),
    );
  }
}