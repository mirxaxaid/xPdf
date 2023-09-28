import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xpdf/api/shared_prefs.dart';
import 'package:xpdf/screens/dashboard.dart';
import 'package:xpdf/screens/welcome_screens/wlecome_screen.dart';
import 'package:xpdf/utils/app_colors.dart';
import 'package:xpdf/utils/fonts.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await requestPermissions();

  bool isFirstLaunch = await SharedPrefs.isFirstAppLaunch();

  runApp(
    MyApp(isFirstLaunch),
  );
}

MyFonts myFonts = MyFonts();

Future<void> loadFonts() async {
  myFonts = (await MyFonts.loadFromSharedPreferences())!;
}

Future<void> requestPermissions() async {
  final statusStorage = await Permission.storage.request();
  if (statusStorage != PermissionStatus.granted) {
    SystemChannels.platform
        .invokeMethod('SystemNavigator.pop'); // Close the app
    Fluttertoast.showToast(
      msg: "PERMISSION NOT GRANTED!!!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.settingCardColor,
      textColor: AppColors.settingTextColor,
    );
  }
}

class MyApp extends StatelessWidget {
  final bool isFirstLaunch;

  const MyApp(this.isFirstLaunch, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bill Generator',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: AppColors.settingCardColor),
        useMaterial3: true,
        // fontFamily: myFonts.selectedFontforApp,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: AppColors.settingBgColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.settingBgColor,
          surfaceTintColor: AppColors.settingBgColorA,
          scrolledUnderElevation: 10.0,
          titleTextStyle: TextStyle(
            color: AppColors.settingCardColor,
            fontSize: 20,
          ),
        ),
        cardColor: AppColors.settingCardColor,
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            side: MaterialStateProperty.all<BorderSide>(
              const BorderSide(
                color: AppColors.settingCardColor,
              ),
            ),
          ),
        ),
      ),
      home: isFirstLaunch ? const WelcomeScreen() : const Dashboard(),
      // home: true ? const WelcomeScreen() : const Dashboard(),
    );
  }
}
