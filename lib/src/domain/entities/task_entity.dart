class TaskEntity {
  final String id;
  final String title;
  final String description;
  final DateTime? dueDate;
  final bool completed;

  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    this.dueDate,
    this.completed = false,
  });

  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? completed,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      completed: completed ?? this.completed,
    );
  }
}
