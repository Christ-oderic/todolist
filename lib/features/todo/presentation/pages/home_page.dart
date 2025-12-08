import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/bloc/authBloc/auth_bloc.dart';
import 'package:todolist/features/todo/presentation/pages/Auth/sign_up.dart';
import 'package:todolist/features/todo/presentation/widgets/app_button.dart';
import 'package:todolist/theme/app_theme.dart';
import 'package:todolist/theme/app_typography.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme,
      child: Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()),
              );
            }

            if (state is AuthFailure) {
              Navigator.of(context).pop(); // ferme loader
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error)));
            }

            if (state is AuthLogOutSuccess) {
              Navigator.of(context).pop(); // ferme loader
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (context) => const Signup()),
              );
            }
          },
          child: Center(
            child: Column(
              children: [
                Text("Welcome", style: AppTypography.titre1),
                AppButton(
                  text: "Out",
                  onPressed: () {
                    context.read<AuthBloc>().add(SignOutEvent());
                  },
                  isCircular: true,
                  borderRadius: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
