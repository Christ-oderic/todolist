import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/cubit/labelsCubit/label_cubit.dart';
import 'package:todolist/cubit/labelsCubit/label_state.dart';
import 'package:todolist/cubit/projectCubit/project_cubit.dart';
import 'package:todolist/cubit/projectCubit/project_state.dart';
import 'package:todolist/cubit/tasksCubit/tasks_cubit.dart';
import 'package:todolist/features/todo/domain/models/task_model.dart';
import 'package:todolist/theme/app_colors.dart';

import '../../../../core/utils/enum.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _controller = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TaskPriority _priority = TaskPriority.normal;

  List<String> _selectedLabels = [];
  String? _selectedProject;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        "What would you like to do?",
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: "Enter your task",
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _iconButton(Icons.calendar_today, _pickDate),
              _iconButton(Icons.priority_high, _pickPriority),
              _iconButton(Icons.label_outline, _pickLabels),
              _iconButton(Icons.folder_open, _pickProject),
              _iconButton(Icons.check_circle, _submit),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, color: AppColors.primary),
      onPressed: onTap,
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  void _pickPriority() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Wrap(
          children: TaskPriority.values.map((p) {
            return ChoiceChip(
              label: Text(p.name),
              selected: _priority == p,
              onSelected: (_) {
                setState(() => _priority = p);
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _pickLabels() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return BlocProvider.value(
          value: context.read<LabelCubit>(),
          child: BlocBuilder<LabelCubit, LabelState>(
            builder: (context, state) {
              if (state is! LabelLoaded) return const SizedBox();

              return Wrap(
                children: state.labels.map((l) {
                  final selected = _selectedLabels.contains(l.id);

                  return FilterChip(
                    label: Text(l.name),
                    selected: selected,
                    onSelected: (value) {
                      if (value && _selectedLabels.length >= 2) return;

                      setState(() {
                        value
                            ? _selectedLabels.add(l.id)
                            : _selectedLabels.remove(l.id);
                      });
                    },
                  );
                }).toList(),
              );
            },
          ),
        );
      },
    );
  }

  void _pickProject() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return BlocProvider.value(
          value: context.read<ProjectCubit>(),
          child: BlocBuilder<ProjectCubit, ProjectState>(
            builder: (context, state) {
              if (state is! ProjectLoaded) return const SizedBox();

              return ListView(
                shrinkWrap: true,
                children: state.projects.map((p) {
                  return ListTile(
                    title: Text(p.name),
                    onTap: () {
                      setState(() => _selectedProject = p.id);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              );
            },
          ),
        );
      },
    );
  }

  void _submit() {
    if (_controller.text.trim().isEmpty) return;

    final task = TaskModel(
      id: '',
      libelle: _controller.text.trim(),
      date: _selectedDate,
      createdAt: DateTime.now(),
      statut: TaskStatus.todo,
      priorite: _priority,
      labelIds: _selectedLabels,
      projectId: _selectedProject,
      userId: '',
    );

    context.read<TaskCubit>().addTask(task);
    Navigator.pop(context);
  }
}
