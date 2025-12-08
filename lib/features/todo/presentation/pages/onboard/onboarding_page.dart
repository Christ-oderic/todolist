import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import 'package:todolist/bloc/onboardBloc/onboarding_bloc.dart';
import 'package:todolist/features/todo/presentation/pages/Auth/sign_up.dart';
import 'package:todolist/features/todo/presentation/widgets/onboard/onboarding_indicator.dart';
import 'package:todolist/features/todo/presentation/widgets/onboard/onboarding_item.dart';
import 'package:todolist/theme/app_colors.dart';

class OnboardingPage extends StatelessWidget {
  OnboardingPage({super.key});

  final List<Map<String, dynamic>> pages = [
    {
      "icon": Symbols.verified_rounded,
      "text": "Organisez vos tâches facilement",
    },
    {
      "icon": Symbols.notification_sound_rounded,
      "text": "Recevez des rappels intelligents",
    },
    {
      "icon": Symbols.check_circle_outline_rounded,
      "text": "Suivez vos progrès au quotidien",
      "sous": "just a click away from planning your tasks",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingBloc(),
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          final bloc = context.read<OnboardingBloc>();

          return Scaffold(
            body: Stack(
              children: [
                // --- PageView ---
                PageView.builder(
                  controller: bloc.controller,
                  itemCount: pages.length,
                  onPageChanged: (i) => bloc.add(PageChangedEvent(i)),
                  itemBuilder: (context, index) => OnboardingItem(
                    icon: pages[index]["icon"],
                    title: pages[index]["text"],
                    subtitle: pages[index]["sous"],
                  ),
                ),

                // --- Indicateur ---
                OnboardingIndicator(
                  pageCount: pages.length,
                  currentPage: state.currentPage,
                  bottom: 300,
                  left: 0,
                  right: 200,
                ),

                // --- Bouton navigation ---
                Positioned(
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
                          if (state.currentPage < pages.length - 1) {
                            bloc.controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (context) => const Signup(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
