import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_managemnet/src/data/models/task_model.dart';
import 'package:task_managemnet/src/domain/entities/task_entity.dart';
import 'package:task_managemnet/src/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  static const _storageKey = 'tasks_v1';
  final SharedPreferences prefs;

  TaskRepositoryImpl(this.prefs);

  List<TaskModel> _decodeTasks(String? raw) {
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => TaskModel.fromJson(e)).toList();
  }

  Future<void> _saveTasks(List<TaskModel> tasks) async {
    final encoded = jsonEncode(tasks.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  @override
  Future<List<TaskEntity>> getTasks() async {
    final tasks = _decodeTasks(prefs.getString(_storageKey));
    return tasks
        .map(
          (e) => TaskEntity(
            id: e.id,
            title: e.title,
            description: e.description,
            dueDate: e.dueDate,
            completed: e.completed,
          ),
        )
        .toList();
  }

  @override
  Future<void> addTask(TaskEntity task) async {
    final tasks = _decodeTasks(prefs.getString(_storageKey));
    tasks.insert(
      0,
      TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        completed: task.completed,
      ),
    );
    await _saveTasks(tasks);
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    final tasks = _decodeTasks(prefs.getString(_storageKey));
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index >= 0) {
      tasks[index] = TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        completed: task.completed,
      );
      await _saveTasks(tasks);
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    final tasks = _decodeTasks(prefs.getString(_storageKey));
    tasks.removeWhere((t) => t.id == id);
    await _saveTasks(tasks);
  }

  @override
  Future<void> toggleTaskCompleted(String id) async {
    final tasks = _decodeTasks(prefs.getString(_storageKey));
    final index = tasks.indexWhere((t) => t.id == id);
    if (index >= 0) {
      final task = tasks[index];
      tasks[index] = TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        completed: !task.completed,
      );
      await _saveTasks(tasks);
    }
  }
}
