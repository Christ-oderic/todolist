import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/cubit/labelsCubit/label_cubit.dart';
import 'package:todolist/cubit/labelsCubit/label_state.dart';
import 'package:todolist/cubit/projectCubit/project_cubit.dart';
import 'package:todolist/cubit/projectCubit/project_state.dart';
import 'package:todolist/cubit/tasksCubit/tasks_cubit.dart';
import 'package:todolist/features/todo/domain/models/task_model.dart';
import 'package:todolist/theme/app_colors.dart';
import 'package:todolist/core/utils/enum.dart';
import 'package:todolist/theme/app_theme.dart';

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

  /// PRIORITY OVERLAY
  final LayerLink _priorityLayerLink = LayerLink();
  OverlayEntry? _priorityOverlay;

  /// LABELS OVERLAY
  OverlayEntry? _labelsOverlay;
  final LayerLink _labelsLayerLink = LayerLink();

  @override
  void dispose() {
    _controller.dispose();
    _removePriorityOverlay();
    _removeLabelsOverlay();
    super.dispose();
  }

  void _removePriorityOverlay() {
    _priorityOverlay?.remove();
    _priorityOverlay = null;
  }

  void _removeLabelsOverlay() {
    if (_labelsOverlay != null && _labelsOverlay!.mounted) {
      _labelsOverlay!.remove();
    }
    _labelsOverlay = null;
  }

  void _refreshPriorityOverlay() {
    _priorityOverlay?.markNeedsBuild();
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

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _iconButton(Icons.calendar_today, _pickDate),

                /// PRIORITY BUTTON (ANCHOR)
                CompositedTransformTarget(
                  link: _priorityLayerLink,
                  child: _iconButton(
                    Icons.warning_amber_rounded,
                    _togglePriorityOverlay,
                  ),
                ),

                CompositedTransformTarget(
                  link: _labelsLayerLink,
                  child: _iconButton(
                    Icons.label_outline_sharp,
                    _toggleLabelsOverlay,
                  ),
                ),

                _iconButton(Icons.note_alt_outlined, _pickProject),
                _iconButton(Icons.check_circle, _submit),
              ],
            ),
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

  /* =======================
      PRIORITY OVERLAY
     ======================= */

  void _togglePriorityOverlay() {
    if (_priorityOverlay != null) {
      _removePriorityOverlay();
      return;
    }

    _priorityOverlay = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Background pour fermer
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _removePriorityOverlay,
              ),
            ),

            // Menu ancré
            CompositedTransformFollower(
              link: _priorityLayerLink,
              showWhenUnlinked: false,
              offset: const Offset(-70, 48), // centre sous le dialog
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(18),
                color: Theme.of(context).cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: TaskPriority.values.map((p) {
                      final selected = _priority == p;
                      final color = _priorityColor(p);

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {
                            setState(() => _priority = p);
                            _refreshPriorityOverlay();
                            // ❌ pas de fermeture
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutCubic,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? color.withAlpha((0.9 * 255).toInt())
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: color,
                                width: selected ? 2 : 1,
                              ),
                            ),
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: TextStyle(
                                color: selected ? Colors.white : color,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              child: Text(p.name),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_priorityOverlay!);
  }

  /* =======================
        DATE / LABEL / PROJECT
     ======================= */

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

  void _toggleLabelsOverlay() {
    if (_labelsOverlay != null) {
      _removeLabelsOverlay();
      return;
    }

    final overlay = Overlay.of(context);
    final labelCubit = context.read<LabelCubit>();

    _labelsOverlay = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Background pour fermer
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _removeLabelsOverlay,
              ),
            ),
            CompositedTransformFollower(
              link: _labelsLayerLink,
              showWhenUnlinked: false,
              offset: const Offset(-110, 48),
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(18),
                color: AppTheme.lightTheme.cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: BlocBuilder<LabelCubit, LabelState>(
                    bloc: labelCubit,
                    builder: (context, state) {
                      if (state is! LabelLoaded) {
                        return const SizedBox(
                          child: Text("Aucun label dispo ajoute un label"),
                        );
                      }
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: state.labels.map((label) {
                          final selected = _selectedLabels.contains(label.id);
                          final color = AppColors.primary;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () {
                                setState(() {
                                  if (selected) {
                                    _selectedLabels.remove(label.id);
                                  } else if (_selectedLabels.length < 2) {
                                    _selectedLabels.add(label.id);
                                  }
                                });
                                _labelsOverlay?.markNeedsBuild();
                              },
                              child: AnimatedScale(
                                scale: selected ? 1.05 : 1.0,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOutCubic,
                                alignment: Alignment.center,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? color.withAlpha((0.9 * 255).toInt())
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: color,
                                      width: selected ? 2 : 1,
                                    ),
                                  ),
                                  child: TweenAnimationBuilder<double>(
                                    duration: const Duration(milliseconds: 260),
                                    curve: Curves.easeOut,
                                    tween: Tween(
                                      begin: 0,
                                      end: selected ? 1 : 0,
                                    ),
                                    builder: (context, value, _) {
                                      return Text(
                                        label.name,
                                        style: TextStyle(
                                          color: Color.lerp(
                                            color,
                                            Colors.white,
                                            value,
                                          ),
                                          fontWeight: value > 0.5
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(_labelsOverlay!);
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

Color _priorityColor(TaskPriority p) {
  switch (p) {
    case TaskPriority.urgent:
      return Colors.redAccent;
    case TaskPriority.normal:
      return Colors.orangeAccent;
    case TaskPriority.faible:
      return Colors.green;
  }
}
