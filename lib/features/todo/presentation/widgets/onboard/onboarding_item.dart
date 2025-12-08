import 'package:flutter/material.dart';
import 'package:todolist/theme/app_colors.dart';
import 'package:todolist/theme/app_typography.dart';

class OnboardingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final double paddingValue;

  const OnboardingItem({
    super.key,
    required this.icon,
    required this.title,
    this.paddingValue = 200,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: paddingValue),
      child: Column(
        children: [
          Icon(icon, size: 150, color: AppColors.secondary),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(title, style: AppTypography.titre1),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(subtitle!, style: AppTypography.body),
            ),
          ],
        ],
      ),
    );
  }
}
