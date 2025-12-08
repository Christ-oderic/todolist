import 'package:flutter/material.dart';
import 'package:todolist/theme/app_theme.dart';

import 'features/todo/presentation/pages/onboard/onboarding_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      home: OnboardingPage(),
    );
  }
}
