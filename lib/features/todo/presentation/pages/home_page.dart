import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:todolist/theme/app_colors.dart';
import 'package:todolist/theme/app_theme.dart';
import 'package:todolist/theme/app_typography.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme,
      child: Scaffold(
        body: Container(
          height: 230,
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
                    icon: const Icon(
                      Symbols.person,
                      size: 40,
                      color: Colors.white,
                    ),
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
                      Symbols.settings,
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
        ),
      ),
    );
  }
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
