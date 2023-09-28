import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MyFonts {
  List<String> fonts;
  String selectedFont;
  String selectedFontforApp;

  MyFonts({
    List<String>? fonts,
    String? selectedFont,
    String? selectedFontforApp,
  })  : fonts = fonts ?? ['Lora', 'RobotoSlab', 'FreeSans', 'Roboto'],
        selectedFont = selectedFont ?? 'Lora',
        selectedFontforApp = selectedFontforApp ?? 'Roboto';

  Map<String, dynamic> toJson() {
    return {
      'fonts': fonts,
      'selectedFont': selectedFont,
      'selectedFontForApp': selectedFontforApp,
    };
  }

  // Save the MyFonts instance to SharedPreferences
  Future<void> saveToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('myFonts', jsonEncode(toJson()));
  }

  // Load a MyFonts instance from SharedPreferences
  static Future<MyFonts?> loadFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('myFonts');
    if (jsonString != null) {
      final jsonData = jsonDecode(jsonString);
      return MyFonts.fromJson(jsonData);
    }
    return null;
  }

  // Update the selectedFont and save it to SharedPreferences
  Future<void> updateSelectedFont(String newFont) async {
    selectedFont = newFont;
    await saveToSharedPreferences();
  }

  Future<void> updateSelectedFontForApp(String newFont) async {
    selectedFontforApp = newFont;
    await saveToSharedPreferences();
  }

  factory MyFonts.fromJson(Map<String, dynamic> json) {
    return MyFonts(
      fonts: List<String>.from(json['fonts'] ?? []),
      selectedFont: json['selectedFont'] ?? 'Lora',
      selectedFontforApp: json['selectedFontForApp'] ?? 'Roboto',
    );
  }
}
