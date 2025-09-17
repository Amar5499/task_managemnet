import 'package:task_managemnet/src/domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  TaskModel({
    required super.id,
    required super.title,
    required super.description,
    super.dueDate,
    super.completed,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    dueDate:
        json['dueDate'] != null
            ? DateTime.parse(json['dueDate'] as String)
            : null,
    completed: json['completed'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'dueDate': dueDate?.toIso8601String(),
    'completed': completed,
  };
}
