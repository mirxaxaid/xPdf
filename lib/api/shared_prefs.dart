import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {

  static Future<bool> isFirstAppLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('first_launch') ?? true;

    return isFirstLaunch;
  }

  // static Future<bool> isHeaderAdded() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool isHeaderAdded = prefs.getBool('header_added') ?? false;
  //
  //   return isHeaderAdded;
  // }

  // static Future<bool> isFooterAdded() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool isFooterAdded = prefs.getBool('footer_added') ?? false;
  //
  //   return isFooterAdded;
  // }

  static Future<bool> isTermsAdded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isTermsAdded = prefs.getBool('terms_added') ?? false;

    return isTermsAdded;
  }

  static Future<void> termsAdded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isTermsAdded = prefs.getBool('terms_added') ?? false;

    if (!isTermsAdded) {
      // Update the flag to indicate that the app has been opened
      await prefs.setBool('terms_added', true);
    }
  }

  static Future<void> firstAppLaunched() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('first_launch') ?? true;

    if (isFirstLaunch) {
      // Update the flag to indicate that the app has been opened
      await prefs.setBool('first_launch', false);
    }
  }

  // static Future<void> headerAdded() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool isHeaderAdded = prefs.getBool('header_added') ?? false;
  //
  //   if (!isHeaderAdded) {
  //     // Update the flag to indicate that the app has been opened
  //     await prefs.setBool('header_added', true);
  //   }
  // }

  // static Future<void> footerAdded() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool isFooterAdded = prefs.getBool('footer_added') ?? false;
  //
  //   if (!isFooterAdded) {
  //     // Update the flag to indicate that the app has been opened
  //     await prefs.setBool('footer_added', true);
  //   }
  // }

}