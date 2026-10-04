import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/app_provider.dart';

class TaskDetailScreen
    extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({
    super.key,
    required this.task,
  });

  Future<void> _deleteTask(
      BuildContext context,
      ) async {
    final confirmed =
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
          const Text('Delete Task?'),
          content: const Text(
            'Are you sure you want to delete this task?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true ||
        !context.mounted) {
      return;
    }

    await context
        .read<AppProvider>()
        .deleteTask(task.id);

    if (!context.mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider =
    context.watch<AppProvider>();

    final currentTask =
    provider.tasks.firstWhere(
          (item) => item.id == task.id,
      orElse: () => task,
    );

    return Scaffold(
      appBar: AppBar(
        title:
        const Text('Task Details'),
      ),

      body: ListView(
        padding:
        const EdgeInsets.all(20),
        children: [
          Text(
            currentTask.title,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(
              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          _detail(
            context,
            'Description',
            currentTask.description ??
                'No description',
          ),

          _detail(
            context,
            'Due Date',
            DateFormat(
              'dd MMMM yyyy',
            ).format(
              currentTask.dueDate,
            ),
          ),

          _detail(
            context,
            'Priority',
            currentTask.priority.name
                .toUpperCase(),
          ),

          _detail(
            context,
            'Status',
            currentTask.isComplete
                ? 'Completed'
                : 'Incomplete',
          ),

          const SizedBox(height: 24),

          FilledButton.icon(
            onPressed: () async {
              await provider
                  .toggleTaskCompletion(
                currentTask,
              );
            },
            icon: Icon(
              currentTask.isComplete
                  ? Icons.undo
                  : Icons.check,
            ),
            label: Text(
              currentTask.isComplete
                  ? 'Mark Incomplete'
                  : 'Mark Complete',
            ),
          ),

          const SizedBox(height: 12),

          OutlinedButton.icon(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/add-task',
                arguments: currentTask,
              );
            },
            icon:
            const Icon(Icons.edit),
            label:
            const Text('Edit'),
          ),

          const SizedBox(height: 12),

          TextButton.icon(
            onPressed: () =>
                _deleteTask(context),
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            label: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detail(
      BuildContext context,
      String title,
      String value,
      ) {
    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 20,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .labelLarge,
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .bodyLarge,
          ),
        ],
      ),
    );
  }
}