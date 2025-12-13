import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:todolist/core/utils/enum.dart';
import 'package:todolist/cubit/labelsCubit/label_cubit.dart';
import 'package:todolist/cubit/projectCubit/project_cubit.dart';
import 'package:todolist/features/todo/domain/models/task_model.dart';
import 'package:todolist/features/todo/presentation/widgets/add_task_dialog.dart';
import 'package:todolist/theme/app_colors.dart';
import 'package:todolist/theme/app_theme.dart';
import 'package:todolist/theme/app_typography.dart';

import '../../../../cubit/labelsCubit/label_state.dart';
import '../../../../cubit/tasksCubit/tasks_cubit.dart';
import '../../domain/models/label_model.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text("Vous devez être connecté")),
      );
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TaskCubit(userId: userId)),
        BlocProvider(create: (_) => LabelCubit()),
        BlocProvider(create: (_) => ProjectCubit()),
      ],
      child: _TasksView(),
    );
  }
}

class _TasksView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: context.read<LabelCubit>()),
                    BlocProvider.value(value: context.read<ProjectCubit>()),
                    BlocProvider.value(value: context.read<TaskCubit>()),
                  ],
                  child: const AddTaskDialog(),
                );
              },
            );
          },
        ),
        bottomNavigationBar: _bottomNav(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _header(),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: _taskContent(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------- TASK CONTENT ----------------------
Widget _taskContent(BuildContext context) {
  return BlocBuilder<TaskCubit, TaskState>(
    builder: (context, state) {
      if (state is TaskLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state is TaskError) {
        return Center(child: Text("Erreur : ${state.message}"));
      }

      if (state is TaskLoaded) {
        final grouped = _groupTasks(state.tasks);
        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection("Today", grouped["today"]!),
              const SizedBox(height: 15),
              _buildSection("Tomorrow", grouped["tomorrow"]!),
              const SizedBox(height: 15),
              _buildSection("This Week", grouped["week"]!),

              const SizedBox(height: 15),

              _buildSection("Delayed", grouped["delay"]!),
            ],
          ),
        );
      }

      return const SizedBox.shrink();
    },
  );
}

// ---------------------- GROUPING LOGIC ----------------------
Map<String, List<TaskModel>> _groupTasks(List<TaskModel> tasks) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(const Duration(days: 1));

  List<TaskModel> todayList = [];
  List<TaskModel> tomorrowList = [];
  List<TaskModel> weekList = [];
  List<TaskModel> delayList = [];

  for (var t in tasks) {
    final date = DateTime(t.date.year, t.date.month, t.date.day);
    if (date.isAtSameMomentAs(today)) {
      todayList.add(t);
    } else if (date.isAtSameMomentAs(tomorrow)) {
      tomorrowList.add(t);
    } else if (date.isAfter(tomorrow) &&
        date.isBefore(today.add(const Duration(days: 7)))) {
      weekList.add(t);
    } else if (date.isBefore(today)) {
      delayList.add(t);
    }
  }

  return {
    "today": todayList,
    "tomorrow": tomorrowList,
    "week": weekList,
    "delay": delayList,
  };
}

// ---------------------- SECTION ----------------------
Widget _buildSection(String title, List<TaskModel> tasks) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: AppTypography.titre3),
      const SizedBox(height: 8),

      tasks.isEmpty
          ? Text(
              "Aucune tâche",
              style: AppTypography.body.copyWith(color: Colors.grey[600]),
            )
          : Column(children: tasks.map((t) => _taskItem(t)).toList()),
    ],
  );
}

Widget _taskItem(TaskModel task) {
  Color dotColor = {
    TaskStatus.todo: Colors.red,
    TaskStatus.doing: Colors.orange,
    TaskStatus.done: Colors.green,
  }[task.statut]!;

  final dateStr = DateFormat("d MMM", "fr_FR").format(task.date);

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.libelle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: BlocBuilder<LabelCubit, LabelState>(
                      builder: (context, labelState) {
                        if (labelState is! LabelLoaded ||
                            (task.labelIds ?? []).isEmpty) {
                          return const SizedBox.shrink();
                        }

                        final labelsMap = {
                          for (final l in labelState.labels) l.id: l,
                        };

                        final taskLabels = task.labelIds!
                            .map((id) => labelsMap[id])
                            .whereType<LabelModel>()
                            .toList();

                        if (taskLabels.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Align(
                          alignment: Alignment.centerRight,
                          child: Wrap(
                            spacing: 6,
                            runSpacing: -6,
                            children: taskLabels.map((label) {
                              return Chip(
                                label: Text(
                                  label.name,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: label.color,
                                visualDensity: VisualDensity.compact,
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              Text(
                dateStr,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _header() {
  return Container(
    height: 200,
    color: AppColors.secondary,
    child: Stack(
      children: [
        Positioned(
          bottom: -55,
          left: -55,
          child: Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          bottom: 70,
          left: 10,
          child: Align(
            alignment: Alignment(-0.25, -0.5),
            child: IconButton(
              icon: const Icon(Symbols.person, size: 40, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ),
        Positioned(
          bottom: 45,
          left: 10,
          right: 0,
          child: Text(
            "Today - ${DateTime.now().day} ${_monthName(DateTime.now().month)}",
            style: AppTypography.body.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          bottom: 15,
          left: 10,
          right: 0,
          child: Text(
            "Dashboard",
            style: AppTypography.titre3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          top: 85,
          right: 15,
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.more_horiz_rounded,
                size: 40,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 90),
              child: Container(
                height: 35,
                width: 240,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search tasks...",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _bottomNav() {
  return BottomAppBar(
    shape: const CircularNotchedRectangle(),
    notchMargin: 8,
    child: SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.list_rounded, size: 40, color: AppColors.primary),
            onPressed: () {},
          ),
          const SizedBox(width: 40),
          IconButton(
            icon: Icon(Icons.calendar_today, size: 28, color: Colors.grey[400]),
            onPressed: () {},
          ),
        ],
      ),
    ),
  );
}

String _monthName(int month) {
  const months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];
  return months[month - 1];
}
