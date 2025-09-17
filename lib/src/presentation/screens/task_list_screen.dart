import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_managemnet/src/application/providers/task_provider.dart';
import 'package:task_managemnet/src/presentation/screens/add_edit_task_screen.dart';
import 'package:task_managemnet/src/presentation/widgets/animated_task_tile.dart';
import 'package:task_managemnet/src/presentation/widgets/custom_button.dart';

enum TaskFilter { all, completed, pending }

enum TaskSort { dueDateAsc, dueDateDesc }

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  TaskFilter _filter = TaskFilter.all;
  TaskSort _sort = TaskSort.dueDateAsc;

  void _openAddTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddEditTaskScreen()),
    );
  }

  void _openEditTask(BuildContext context, task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditTaskScreen(task: task)),
    );
  }

  List filteredAndSortedTasks(List tasks) {
    var filtered = tasks;
    if (_filter == TaskFilter.completed) {
      filtered = tasks.where((t) => t.completed).toList();
    } else if (_filter == TaskFilter.pending) {
      filtered = tasks.where((t) => !t.completed).toList();
    }

    if (_sort == TaskSort.dueDateAsc) {
      filtered.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    } else {
      filtered.sort((a, b) => b.dueDate.compareTo(a.dueDate));
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final tasksToShow = filteredAndSortedTasks(provider.tasks);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task Manager',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          PopupMenuButton<TaskFilter>(
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.black54),
            tooltip: "Filter Tasks",
            onSelected: (value) => setState(() => _filter = value),
            itemBuilder:
                (context) => const [
                  PopupMenuItem(value: TaskFilter.all, child: Text("All")),
                  PopupMenuItem(
                    value: TaskFilter.completed,
                    child: Text("Completed"),
                  ),
                  PopupMenuItem(
                    value: TaskFilter.pending,
                    child: Text("Pending"),
                  ),
                ],
          ),
          PopupMenuButton<TaskSort>(
            icon: const Icon(Icons.sort_rounded, color: Colors.black54),
            tooltip: "Sort Tasks",
            onSelected: (value) => setState(() => _sort = value),
            itemBuilder:
                (context) => const [
                  PopupMenuItem(
                    value: TaskSort.dueDateAsc,
                    child: Text("Due ↑"),
                  ),
                  PopupMenuItem(
                    value: TaskSort.dueDateDesc,
                    child: Text("Due ↓"),
                  ),
                ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child:
                tasksToShow.isEmpty
                    ? const Center(
                      child: Text(
                        'No tasks yet.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: tasksToShow.length,
                      itemBuilder: (context, index) {
                        final task = tasksToShow[index];
                        return AnimatedTaskTile(
                          task: task,
                          onTap: () => _openEditTask(context, task),
                          onEdit: () => _openEditTask(context, task),
                          onDelete: () => provider.deleteTask(task.id),
                          onToggleComplete:
                              () => provider.toggleTaskCompleted(task.id),
                          index: index,
                        );
                      },
                    ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: CustomButton(
              label: "Add Task",
              onPressed: () => _openAddTask(context),
            ),
          ),
        ],
      ),
    );
  }
}
