import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:todolist/bloc/authBloc/auth_bloc.dart';
import 'package:todolist/features/todo/presentation/pages/Auth/sign_up.dart';
import 'package:todolist/features/todo/presentation/widgets/app_button.dart';
import 'package:todolist/features/todo/presentation/widgets/onboard/onboarding_item.dart';
import 'package:todolist/theme/app_colors.dart';
import 'package:todolist/theme/app_theme.dart';
import 'package:todolist/theme/app_typography.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme,
      child: Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: OnboardingItem(
                    paddingValue: 100,
                    icon: Symbols.check_circle_outline_rounded,
                    title: "Welcome Back!!",
                  ),
                ),
                const SizedBox(height: 40),
                // --- EMAIL LABEL ---
                Text("EMAIL ADDRESS", style: AppTypography.body),

                const SizedBox(height: 5),
                // --- EMAIL INPUT ---
                SizedBox(
                  width: 350,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 15,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: AppColors.secondary),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // --- PASSWORD LABEL ---
                Text("PASSWORD", style: AppTypography.body),
                const SizedBox(height: 5),
                // --- PASSWORD ---
                SizedBox(
                  width: 350,
                  child: TextField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // --- SIGN UP BUTTON ---
                AppButton(
                  text: "Log in",
                  width: 150,
                  onPressed: () {
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();

                    context.read<AuthBloc>().add(
                      LogInWithEmailEvent(email, password),
                    );
                  },
                  isCircular: false,
                  borderRadius: 20,
                ),
                const SizedBox(height: 40),

                // --- OR SIGNUP WITH ---
                Text("or log in with", style: AppTypography.body),

                const SizedBox(height: 20),

                // --- SOCIAL BUTTONS ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppButton(
                      onPressed: () {},
                      isCircular: true,
                      borderRadius: 2,
                      icon: Icons.facebook,
                      bgColors: AppColors.support1,
                    ),
                    const SizedBox(width: 15),
                    AppButton(
                      onPressed: () {},
                      isCircular: true,
                      borderRadius: 2,
                      icon: Icons.g_mobiledata,
                      bgColors: AppColors.support2,
                    ),
                    const SizedBox(width: 15),
                    AppButton(
                      onPressed: () {},
                      isCircular: true,
                      borderRadius: 2,
                      icon: Icons.apple,
                      bgColors: AppColors.text,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // --- LOGIN FOOTER ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ", style: AppTypography.body),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => const Signup(),
                          ),
                        );
                      },
                      child: Text(
                        "Get Started",
                        style: AppTypography.hyperlink.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
