enum TaskPriority {
  low,
  medium,
  high,
}

class Task {
  final String id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final TaskPriority priority;
  final bool isComplete;

  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    this.priority = TaskPriority.medium,
    this.isComplete = false,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    bool? isComplete,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority.name,
      'isComplete': isComplete ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      dueDate: DateTime.parse(map['dueDate'] as String),
      priority: TaskPriority.values.firstWhere(
            (value) => value.name == map['priority'],
        orElse: () => TaskPriority.medium,
      ),
      isComplete: (map['isComplete'] as int) == 1,
    );
  }
}