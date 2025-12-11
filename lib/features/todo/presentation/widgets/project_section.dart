import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/cubit/projectCubit/project_cubit.dart';
import 'package:todolist/cubit/projectCubit/project_state.dart';
import 'package:todolist/features/todo/data/datasources/models/projects_model.dart';
import 'package:todolist/theme/app_colors.dart';
import 'package:todolist/theme/app_typography.dart';

class ProjectSection extends StatefulWidget {
  const ProjectSection({super.key});

  @override
  State<ProjectSection> createState() => _ProjectSectionState();
}

class _ProjectSectionState extends State<ProjectSection> {
  bool isOpen = true;

  void _showAddProjectDialog(ProjectCubit cubit) {
    String name = '';
    Color color = Colors.blue;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white.withValues(alpha: 0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Ajouter un projet", style: AppTypography.titre3),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(labelText: 'Nom du projet'),
                  onChanged: (val) => name = val,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<Color>(
                  initialValue: color,
                  items: const [
                    DropdownMenuItem(value: Colors.blue, child: Text('Bleu')),
                    DropdownMenuItem(
                      value: Colors.orange,
                      child: Text('Orange'),
                    ),
                    DropdownMenuItem(value: Colors.red, child: Text('Rouge')),
                  ],
                  onChanged: (val) {
                    if (val != null) color = val;
                  },
                  decoration: const InputDecoration(labelText: 'Couleur'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (name.isNotEmpty) {
                      cubit.addProject(name: name, color: color);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Ajouter'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectCubit, ProjectState>(
      builder: (context, state) {
        List<ProjectModel> projects = [];
        if (state is ProjectLoaded) projects = state.projects;
        return Column(
          children: [
            // ----- TITLE ROW -----
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Projects", style: AppTypography.titre3),

                  Row(
                    children: [
                      // Toggle open/close
                      IconButton(
                        onPressed: () {
                          setState(() => isOpen = !isOpen);
                        },
                        icon: Icon(
                          isOpen
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.grey[700],
                        ),
                      ),

                      // Add project
                      IconButton(
                        onPressed: () =>
                            _showAddProjectDialog(context.read<ProjectCubit>()),
                        icon: Icon(Icons.add, color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 5),

            // ----- PROJECT LIST -----
            if (isOpen)
              if (state is ProjectLoading)
                const Center(child: CircularProgressIndicator())
              else if (state is ProjectError)
                Text("Erreur: ${state.message}")
              else
                Column(
                  children: projects.map((project) {
                    return Container(
                      width: 390,
                      height: 60,
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45,
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Icon
                          Icon(Icons.work_outline, color: project.color),

                          const SizedBox(width: 10),

                          // Title
                          Expanded(
                            child: Text(
                              project.name,
                              style: AppTypography.body.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),

                          // Counter
                          Text(
                            project.taskCount.toString(),
                            style: AppTypography.body.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
          ],
        );
      },
    );
  }
}
