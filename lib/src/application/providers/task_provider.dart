import 'package:flutter/material.dart';
import 'package:task_managemnet/src/domain/entities/task_entity.dart';
import 'package:task_managemnet/src/domain/repositories/task_repository.dart';

class TaskProvider with ChangeNotifier {
  final TaskRepository repository;
  List<TaskEntity> _tasks = [];

  TaskProvider(this.repository) {
    loadTasks();
  }

  List<TaskEntity> get tasks => _tasks;

  Future<void> loadTasks() async {
    _tasks = await repository.getTasks();
    notifyListeners();
  }

  Future<void> addTask(TaskEntity task) async {
    await repository.addTask(task);
    await loadTasks();
  }

  Future<void> updateTask(TaskEntity task) async {
    await repository.updateTask(task);
    await loadTasks();
  }

  Future<void> deleteTask(String id) async {
    await repository.deleteTask(id);
    await loadTasks();
  }

  Future<void> toggleTaskCompleted(String id) async {
    await repository.toggleTaskCompleted(id);
    await loadTasks();
  }
}
