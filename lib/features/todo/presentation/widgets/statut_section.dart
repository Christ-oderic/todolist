import 'package:flutter/material.dart';
import 'package:todolist/theme/app_typography.dart';

class StatutSection extends StatefulWidget {
  const StatutSection({super.key});

  @override
  State<StatutSection> createState() => _StatutSectionState();
}

class _StatutSectionState extends State<StatutSection> {
  bool isOpen = true;

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
              Text("Status", style: AppTypography.titre3),

              Row(
                children: [
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
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 5),

        // ----- STATUS LIST -----
        if (isOpen)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildStatus(context, Colors.red, "À faire"),
                _buildStatus(context, Colors.orange, "En cours"),
                _buildStatus(context, Colors.green, "Fait"),
              ],
            ),
          ),
      ],
    );
  }

  // ----- REUSABLE STATUS CARD -----
  Widget _buildStatus(BuildContext context, Color color, String title) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 60) / 3,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
            // 🔴🟠🟢 Dot
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),

            const SizedBox(width: 10),

            // Title
            Expanded(
              child: Text(
                title,
                style: AppTypography.body.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
