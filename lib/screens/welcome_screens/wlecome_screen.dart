import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xpdf/api/shared_prefs.dart';
import 'package:xpdf/screens/dashboard.dart';
import 'package:xpdf/screens/settings_screens/header.dart';
import 'package:xpdf/utils/app_colors.dart';
import 'package:xpdf/utils/navigation_utils.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  double opacity = 0.0;
  bool fadeIn = true;
  bool showWelcomeText = true;
  int fadeInCount = 0;

  @override
  void initState() {
    super.initState();
    fadeText();
  }

  void fadeText() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        fadeIn = !fadeIn;
        opacity = fadeIn ? 1.0 : 0.0;
        if (fadeIn) {
          if (fadeInCount < 1) {
            showWelcomeText = true;
          } else if (fadeInCount >= 1 && fadeInCount < 2) {
            showWelcomeText = false;
          } else {
            redirectToNextScreen();
            return;
          }
          fadeInCount++;
        }
      });
      if (fadeInCount < 3) {
        // Continue fading text
        fadeText();
      }
    });
  }


  // Function to redirect to the next screen
  void redirectToNextScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) {
        return const MyHeader(isFirstLaunch: true,);
      },)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: opacity,
          duration: const Duration(seconds: 2),
          child: Text(
            showWelcomeText ? "Welcome" : "Let's add some info",
            style: const TextStyle(
              fontSize: 40,
              color: AppColors.settingCardColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
