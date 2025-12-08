import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:todolist/theme/app_colors.dart';

class OnboardingNavigationButton extends StatelessWidget {
  final PageController controller;
  final int currentPage;
  final int totalPages;

  const OnboardingNavigationButton({
    super.key,
    required this.controller,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -180,
      right: -180,
      child: Container(
        width: 400,
        height: 400,
        decoration: const BoxDecoration(
          color: AppColors.secondary,
          shape: BoxShape.circle,
        ),
        child: Align(
          alignment: const Alignment(-0.5, -0.5),
          child: IconButton(
            icon: const Icon(
              Symbols.arrow_forward,
              size: 80,
              color: Colors.white,
            ),
            onPressed: () {
              if (currentPage < totalPages - 1) {
                controller.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              } else {
                // TODO : aller à la vraie homepage
              }
            },
          ),
        ),
      ),
    );
  }
}
