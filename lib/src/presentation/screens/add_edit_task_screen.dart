import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_managemnet/src/application/providers/task_provider.dart';
import 'package:task_managemnet/src/domain/entities/task_entity.dart';
import 'package:task_managemnet/src/core/utils/id_generator.dart';
import '../widgets/custom_button.dart';

class AddEditTaskScreen extends StatefulWidget {
  final TaskEntity? task;
  const AddEditTaskScreen({super.key, this.task});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _dueDate;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    _dueDate = widget.task?.dueDate;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFFA0D8F1),
                onPrimary: Colors.white,
                onSurface: Colors.black87,
              ),
              dialogTheme: DialogThemeData(backgroundColor: Color(0xFFFDF6EC)),
            ),
            child: child!,
          ),
    );
    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime:
          _dueDate != null
              ? TimeOfDay.fromDateTime(_dueDate!)
              : TimeOfDay.now(),
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFFA0D8F1),
                onPrimary: Colors.white,
                onSurface: Colors.black87,
              ),
            ),
            child: child!,
          ),
    );
    if (pickedTime == null) return;

    setState(() {
      _dueDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_dueDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a due date')));
      return;
    }

    final provider = Provider.of<TaskProvider>(context, listen: false);
    final task = TaskEntity(
      id: widget.task?.id ?? generateId(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      dueDate: _dueDate!,
      completed: widget.task?.completed ?? false,
    );

    if (widget.task == null) {
      await provider.addTask(task);
    } else {
      await provider.updateTask(task);
    }

    if (mounted) Navigator.pop(context);
  }

  Widget _buildField(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade300,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.task == null ? 'Add Task' : 'Edit Task',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black87,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildField(
                              'Title',
                              TextFormField(
                                controller: _titleController,
                                decoration: inputDecoration,
                                validator:
                                    (v) =>
                                        v == null || v.isEmpty
                                            ? 'Enter a title'
                                            : null,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildField(
                              'Description',
                              TextFormField(
                                controller: _descriptionController,
                                minLines: 3,
                                maxLines: 5,
                                decoration: inputDecoration,
                                validator:
                                    (v) =>
                                        v == null || v.isEmpty
                                            ? 'Enter a description'
                                            : null,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildField(
                              'Due Date & Time',
                              GestureDetector(
                                onTap: _pickDateTime,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Text(
                                    _dueDate == null
                                        ? 'Pick Date & Time'
                                        : 'Due: ${_dueDate!.toLocal()}'.split(
                                          '.',
                                        )[0],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    label: widget.task == null ? 'Add Task' : 'Update Task',
                    onPressed: _save,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
