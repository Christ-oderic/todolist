import 'package:flutter/material.dart';
import 'package:todolist/theme/app_colors.dart';

class OnboardingIndicator extends StatelessWidget {
  final int pageCount;
  final int currentPage;
  final double bottom;
  final double left;
  final double right;

  const OnboardingIndicator({
    super.key,
    required this.pageCount,
    required this.currentPage,
    this.bottom = 400,
    this.left = 0,
    this.right = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      left: left,
      right: right,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          pageCount,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 6),
            width: currentPage == index ? 18 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: currentPage == index ? AppColors.secondary : Colors.grey,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
