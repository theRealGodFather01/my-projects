import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/app_provider.dart';
import '../widgets/weather_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider =
    context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/settings',
              );
            },
          ),
        ],
      ),

      body: provider.isLoading
          ? const Center(
        child:
        CircularProgressIndicator(),
      )
          : RefreshIndicator(
        onRefresh:
        provider.initialize,
        child: ListView(
          padding:
          const EdgeInsets.all(16),
          children: [
            const WeatherCard(),

            const SizedBox(height: 20),

            if (provider.tasks.isEmpty)
              const Padding(
                padding:
                EdgeInsets.only(
                  top: 80,
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.task_alt,
                      size: 72,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No tasks yet',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap + to create your first task.',
                      textAlign:
                      TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ...provider.tasks.map(
                    (task) => _buildTaskCard(
                  context,
                  task,
                  provider,
                ),
              ),
          ],
        ),
      ),

      floatingActionButton:
      FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/add-task',
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskCard(
      BuildContext context,
      Task task,
      AppProvider provider,
      ) {
    final priorityColor =
    switch (task.priority) {
      TaskPriority.high => Colors.red,
      TaskPriority.medium => Colors.amber,
      TaskPriority.low => Colors.green,
    };

    return Card(
      margin:
      const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius:
        BorderRadius.circular(12),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/task-detail',
            arguments: task,
          );
        },
        child: Padding(
          padding:
          const EdgeInsets.all(16),
          child: Row(
            children: [
              Checkbox(
                value: task.isComplete,
                onChanged: (_) {
                  provider
                      .toggleTaskCompletion(
                    task,
                  );
                },
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight:
                        FontWeight.bold,
                        decoration:
                        task.isComplete
                            ? TextDecoration
                            .lineThrough
                            : null,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      DateFormat(
                        'dd MMM yyyy',
                      ).format(
                        task.dueDate,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      padding:
                      const EdgeInsets
                          .symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration:
                      BoxDecoration(
                        color: priorityColor
                            .withValues(
                          alpha: 0.15,
                        ),
                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),
                      ),
                      child: Text(
                        task.priority.name
                            .toUpperCase(),
                        style: TextStyle(
                          color:
                          priorityColor,
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}