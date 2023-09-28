import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xpdf/screens/settings_screens/footer.dart';
import 'package:xpdf/screens/terms_&_conditions_screen.dart';
import 'package:xpdf/utils/fonts.dart';
import '../models/header_model.dart';
import '../utils/app_colors.dart';
import '../utils/navigation_utils.dart';
import 'settings_screens/header.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late HeaderModel? loadedHeader;

  MyFonts myFonts = MyFonts();

  late String title;
  late String font;
  late bool isUnderline;
  late Color titleColor;
  late Color underlineColor;

  @override
  void initState() {
    super.initState();
    loadFonts();
  }

  Future<void> loadFonts() async {
    myFonts = (await MyFonts.loadFromSharedPreferences())!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    TextStyle headingStyle = const TextStyle(
      color: AppColors.settingCardColor,
      fontSize: 16,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            CupertinoIcons.back,
            color: AppColors.settingCardColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              NavigationUtils.navigateWithSlideTransition(
                context,
                const TermsAndConditionsScreen(),
              );
            },
            icon: const Icon(
              CupertinoIcons.square_list,
              color: AppColors.settingCardColor,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                NavigationUtils.navigateWithSlideTransition(
                  context,
                  const MyHeader(isFirstLaunch: false),
                );
              },
              child: Card(
                color: AppColors.settingBgColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Container(
                  width: screenWidth,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Header",
                      style: headingStyle,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                NavigationUtils.navigateWithSlideTransition(
                  context,
                  MyFooter(isFirstLaunch: false),
                );
              },
              child: Card(
                color: AppColors.settingBgColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Container(
                  width: screenWidth,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Footer",
                      style: headingStyle,
                    ),
                  ),
                ),
              ),
            ),
            DropdownButton<String>(
              value: myFonts.selectedFontforApp,
              style: const TextStyle(
                  color: AppColors.settingCardColor, fontSize: 16),
              dropdownColor: AppColors.settingBgColor,
              onChanged: (String? newFont) {
                if (newFont != null) {
                  updateAppFont(newFont);
                  setState(() {
                    myFonts.selectedFontforApp = newFont;
                  });
                  loadFonts();
                }
              },
              items:
                  myFonts.fonts.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> updateAppFont(String newFont) async {
    await myFonts.updateSelectedFontForApp(newFont);
  }
}
