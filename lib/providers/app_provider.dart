import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/database_helper.dart';
import '../models/task.dart';

class AppProvider extends ChangeNotifier {
  final DatabaseHelper _database = DatabaseHelper.instance;

  List<Task> _tasks = [];

  bool _isLoading = true;

  bool _isDarkMode = false;

  List<Task> get tasks => List.unmodifiable(_tasks);

  bool get isLoading => _isLoading;

  bool get isDarkMode => _isDarkMode;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    final preferences = await SharedPreferences.getInstance();

    _isDarkMode = preferences.getBool('darkMode') ?? false;

    _tasks = await _database.getTasks();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _database.insertTask(task);

    _tasks.add(task);

    _sortTasks();

    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    await _database.updateTask(task);

    final index = _tasks.indexWhere(
          (item) => item.id == task.id,
    );

    if (index != -1) {
      _tasks[index] = task;
    }

    _sortTasks();

    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    await _database.deleteTask(id);

    _tasks.removeWhere(
          (task) => task.id == id,
    );

    notifyListeners();
  }

  Future<void> toggleTaskCompletion(Task task) async {
    final updatedTask = task.copyWith(
      isComplete: !task.isComplete,
    );

    await updateTask(updatedTask);
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;

    final preferences = await SharedPreferences.getInstance();

    await preferences.setBool(
      'darkMode',
      value,
    );

    notifyListeners();
  }

  void _sortTasks() {
    _tasks.sort(
          (a, b) => a.dueDate.compareTo(b.dueDate),
    );
  }
}