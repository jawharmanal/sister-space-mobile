// 🌸 main.dart — Sister Space mobile (Flutter)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/colors.dart';
import 'screens/welcome_screen.dart';
import 'widgets/phone_frame.dart';

void main() {
  runApp(const SisterSpaceApp());
}

class SisterSpaceApp extends StatelessWidget {
  const SisterSpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sister Space',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.rose),
        scaffoldBackgroundColor: AppColors.roseBg,
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      builder: (context, child) =>
          PhoneFrame(child: child ?? const SizedBox()),
      home: const WelcomeScreen(),
    );
  }
}
