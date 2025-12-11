import 'package:flutter/material.dart';
import 'package:todolist/theme/app_colors.dart';
import 'package:todolist/theme/app_typography.dart';

class LabelSection extends StatefulWidget {
  const LabelSection({super.key});

  @override
  State<LabelSection> createState() => _LabelSectionState();
}

class _LabelSectionState extends State<LabelSection> {
  bool isOpen = true;

  final List<Map<String, dynamic>> labels = [
    {"color": Colors.blue, "title": "study", "count": 5},
    {"color": Colors.orange, "title": "Sport", "count": 2},
    {"color": Colors.yellow, "title": "Work", "count": 2},
    {"color": Colors.black, "title": "Personal", "count": 2},
    {"color": Colors.green, "title": "Habit", "count": 2},
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
              Text("Labels", style: AppTypography.titre3),

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              spacing: 10, // espace horizontal
              runSpacing: 10, // espace vertical
              children: labels.map((item) {
                return SizedBox(
                  width:
                      (MediaQuery.of(context).size.width - 60) /
                      2, // 2 par ligne
                  child: Container(
                    height: 60,
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
                        Icon(Icons.note_alt_outlined, color: item["color"]),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item["title"],
                            style: AppTypography.body.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          item["count"].toString(),
                          style: AppTypography.body.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
