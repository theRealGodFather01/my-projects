import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/task.dart';
import '../providers/app_provider.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;

  const AddEditTaskScreen({
    super.key,
    this.task,
  });

  @override
  State<AddEditTaskScreen> createState() =>
      _AddEditTaskScreenState();
}

class _AddEditTaskScreenState
    extends State<AddEditTaskScreen> {
  final _formKey =
  GlobalKey<FormState>();

  late final TextEditingController
  _titleController;

  late final TextEditingController
  _descriptionController;

  DateTime? _dueDate;

  TaskPriority _priority =
      TaskPriority.medium;

  bool _saving = false;

  bool get _isEditing =>
      widget.task != null;

  @override
  void initState() {
    super.initState();

    _titleController =
        TextEditingController(
          text: widget.task?.title ?? '',
        );

    _descriptionController =
        TextEditingController(
          text: widget.task?.description ?? '',
        );

    _dueDate = widget.task?.dueDate;

    _priority =
        widget.task?.priority ??
            TaskPriority.medium;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  Future<void> _selectDate() async {
    final selected =
    await showDatePicker(
      context: context,
      initialDate:
      _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selected != null) {
      setState(() {
        _dueDate = selected;
      });
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_dueDate == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a due date.',
          ),
        ),
      );

      return;
    }

    setState(() {
      _saving = true;
    });

    final provider =
    context.read<AppProvider>();

    try {
      final task = Task(
        id:
        widget.task?.id ??
            const Uuid().v4(),
        title:
        _titleController.text.trim(),
        description:
        _descriptionController.text
            .trim()
            .isEmpty
            ? null
            : _descriptionController
            .text
            .trim(),
        dueDate: _dueDate!,
        priority: _priority,
        isComplete:
        widget.task?.isComplete ??
            false,
      );

      if (_isEditing) {
        await provider.updateTask(task);
      } else {
        await provider.addTask(task);
      }

      if (!mounted) return;

      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Unable to save task: $error',
          ),
        ),
      );

      setState(() {
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing
              ? 'Edit Task'
              : 'Add Task',
        ),
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          padding:
          const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller:
              _titleController,
              decoration:
              const InputDecoration(
                labelText: 'Title',
                border:
                OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Task title is required.';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller:
              _descriptionController,
              maxLines: 5,
              decoration:
              const InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true,
                border:
                OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            ListTile(
              contentPadding:
              EdgeInsets.zero,
              title:
              const Text('Due Date'),
              subtitle: Text(
                _dueDate == null
                    ? 'No date selected'
                    : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
              ),
              trailing:
              const Icon(
                Icons.calendar_month,
              ),
              onTap: _selectDate,
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<
                TaskPriority>(
              initialValue: _priority,
              decoration:
              const InputDecoration(
                labelText: 'Priority',
                border:
                OutlineInputBorder(),
              ),
              items: TaskPriority.values
                  .map(
                    (priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(
                      priority.name
                          .toUpperCase(),
                    ),
                  );
                },
              )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _priority = value;
                  });
                }
              },
            ),

            const SizedBox(height: 28),

            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed:
                _saving
                    ? null
                    : _saveTask,
                child: _saving
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child:
                  CircularProgressIndicator(),
                )
                    : Text(
                  _isEditing
                      ? 'Update Task'
                      : 'Save Task',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}