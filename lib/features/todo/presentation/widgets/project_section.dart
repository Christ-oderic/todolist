import 'package:flutter/material.dart';
import 'package:todolist/theme/app_colors.dart';
import 'package:todolist/theme/app_typography.dart';

class ProjectSection extends StatefulWidget {
  const ProjectSection({super.key});

  @override
  State<ProjectSection> createState() => _ProjectSectionState();
}

class _ProjectSectionState extends State<ProjectSection> {
  bool isOpen = true;

  final List<Map<String, dynamic>> projects = [
    {"color": Colors.blue, "title": "CareerFoundry Course", "count": 5},
    {"color": Colors.orange, "title": "App Design Project", "count": 2},
  ];

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () {
                      // action: open modal, page, etc.
                    },
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
          Column(
            children: projects.map((item) {
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
                    Icon(Icons.work_outline, color: item["color"]),

                    const SizedBox(width: 10),

                    // Title
                    Expanded(
                      child: Text(
                        item["title"],
                        style: AppTypography.body.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    // Counter
                    Text(
                      item["count"].toString(),
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
  }
}
