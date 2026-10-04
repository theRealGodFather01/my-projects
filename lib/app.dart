import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/task.dart';
import 'providers/app_provider.dart';
import 'screens/add_edit_task_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/task_detail_screen.dart';

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider =
    context.watch<AppProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',

      themeMode:
      provider.isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.indigo,
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
      ),

      initialRoute: '/',

      routes: {
        '/': (_) =>
        const SplashScreen(),

        '/home': (_) =>
        const HomeScreen(),

        '/add-task': (context) {
          final task =
          ModalRoute.of(context)
              ?.settings
              .arguments as Task?;

          return AddEditTaskScreen(
            task: task,
          );
        },

        '/settings': (_) =>
        const SettingsScreen(),
      },

      onGenerateRoute: (settings) {
        if (settings.name ==
            '/task-detail') {
          final task =
          settings.arguments as Task;

          return MaterialPageRoute(
            builder: (_) =>
                TaskDetailScreen(
                  task: task,
                ),
          );
        }

        return null;
      },
    );
  }
}