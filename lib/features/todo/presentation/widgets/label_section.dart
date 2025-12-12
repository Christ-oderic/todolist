import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/cubit/labelsCubit/label_cubit.dart';
import 'package:todolist/cubit/labelsCubit/label_state.dart';
import 'package:todolist/features/todo/domain/models/label_model.dart';
import 'package:todolist/features/todo/presentation/widgets/app_button.dart';
import 'package:todolist/theme/app_colors.dart';
import 'package:todolist/theme/app_typography.dart';

class LabelSection extends StatefulWidget {
  const LabelSection({super.key});

  @override
  State<LabelSection> createState() => _LabelSectionState();
}

class _LabelSectionState extends State<LabelSection> {
  bool isOpen = true;

  void _showAddLabelDialog(LabelCubit cubit) {
    String name = '';
    Color color = Colors.blue;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.background.withValues(alpha: 0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Ajouter un label", style: AppTypography.titre3),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(labelText: 'Nom du label'),
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
                AppButton(
                  onPressed: () {
                    if (name.isNotEmpty) {
                      cubit.addLabel(name: name, color: color);
                      Navigator.pop(context);
                    }
                  },
                  width: 100.0,
                  isCircular: false,
                  borderRadius: 20,
                  text: 'Ajouter',
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
    return BlocBuilder<LabelCubit, LabelState>(
      builder: (context, state) {
        List<LabelModel> labels = [];
        if (state is LabelLoaded) labels = state.labels;
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
                        onPressed: () =>
                            _showAddLabelDialog(context.read<LabelCubit>()),
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
              if (state is LabelLoading)
                const Center(child: CircularProgressIndicator())
              else if (state is LabelError)
                Text("Erreur: ${state.message}")
              else if (labels.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Ajouter un label",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    spacing: 10, // espace horizontal
                    runSpacing: 10, // espace vertical
                    children: labels.map((label) {
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
                              Icon(Icons.note_alt_outlined, color: label.color),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  label.name,
                                  style: AppTypography.body.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                label.labelCounts.toString(),
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
      },
    );
  }
}
