import 'package:flutter/material.dart';
import 'package:todolist/theme/app_colors.dart';
import 'package:todolist/theme/app_typography.dart';

class AppButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback onPressed;

  final bool isCircular;
  final double? width;
  final double? height;
  final double borderRadius;
  final Color bgColors;

  const AppButton({
    super.key,
    this.text,
    this.icon,
    required this.onPressed,
    required this.isCircular,
    this.width,
    this.height,
    required this.borderRadius,
    this.bgColors = AppColors.secondary,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconTextColor = Colors.white;

    final double finalWidth = isCircular
        ? (width ?? height ?? 55)
        : (width ?? double.infinity);
    final double finalHeight = height ?? 55;
    return Material(
      color: bgColors,
      borderRadius: BorderRadius.circular(
        isCircular ? finalWidth / 2 : borderRadius,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(
          isCircular ? finalWidth / 2 : borderRadius,
        ),
        onTap: onPressed,
        child: Container(
          width: finalWidth,
          height: finalHeight,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildContent(iconTextColor),
        ),
      ),
    );
  }

  Widget _buildContent(Color iconTextColor) {
    if (icon != null) {
      return Icon(icon, color: iconTextColor);
    }
    return Text(
      text!,
      style: AppTypography.titre3.copyWith(color: iconTextColor),
    );
  }
}
