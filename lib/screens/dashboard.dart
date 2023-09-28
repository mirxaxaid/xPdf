import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xpdf/screens/settings.dart';
import '../api/shared_prefs.dart';
import '../utils/app_colors.dart';
import 'bill_reference.dart';
import 'instructions/invoice_instructions.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isFirstLaunch = true;

  Future<void> checkFirstLaunch() async {
    isFirstLaunch = await SharedPrefs.isFirstAppLaunch();
  }

  @override
  void initState() {
    super.initState();
    checkFirstLaunch();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          PopupMenuButton<String>(
            color: AppColors.settingCardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 5,
            offset: const Offset(-20, 40),
            onSelected: (value) {
              if (value == 'option1') {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return const InvoiceInstructions();
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          // Slide in from the right
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                  ),
                );
              } else if (value == 'option2') {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return const Settings();
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          // Slide in from the right
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                  ),
                );
              } else if (value == 'option3') {
                Fluttertoast.showToast(
                  msg: "Coming soon...",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.SNACKBAR,
                  timeInSecForIosWeb: 1,
                  backgroundColor: AppColors.settingCardColor,
                  textColor: AppColors.settingTextColor,
                  // fontSize: 16.0,
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'option1',
                  child: ListTile(
                    leading: Icon(Icons.info_outline_rounded,
                        color: AppColors.settingTextColor),
                    title: Text(
                      'Instructions',
                      style: TextStyle(color: AppColors.settingTextColor),
                    ),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'option2',
                  child: ListTile(
                    leading:
                        Icon(Icons.settings, color: AppColors.settingTextColor),
                    title: Text(
                      'Settings',
                      style: TextStyle(color: AppColors.settingTextColor),
                    ),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'option3',
                  child: ListTile(
                    leading: Icon(Icons.construction,
                        color: AppColors.settingTextColor),
                    title: Text(
                      'Coming Soon',
                      style: TextStyle(color: AppColors.settingTextColor),
                    ),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints.tightForFinite(height: screenHeight / 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: screenWidth * 0.07),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return const BillReference();
                                  },
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(1.0, 0.0),
                                        // Slide in from the right
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            height: 150,
                            color: AppColors.settingCardColor,
                            padding: const EdgeInsets.all(50),
                            elevation: 10,
                            hoverElevation: 20,
                            focusElevation: 20,
                            highlightElevation: 20,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            enableFeedback: true,
                            visualDensity: VisualDensity.comfortable,
                            splashColor: AppColors.buttonSplashColorAlt,
                            highlightColor: AppColors.buttonSplashColorAlt,
                            child: const Icon(
                              // FontAwesomeIcons.fileInvoice,
                              CupertinoIcons.doc_text,
                              size: 50,
                              color: AppColors.settingTextColor,
                            ),
                          ),
                          const Positioned(
                            bottom: 5,
                            child: Text(
                              "Invoice",
                              style: TextStyle(
                                color: AppColors.settingTextColor,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: screenWidth * 0.07),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              Fluttertoast.showToast(
                                msg: "Coming soon...",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.SNACKBAR,
                                timeInSecForIosWeb: 1,
                                backgroundColor: AppColors.settingCardColor,
                                textColor: AppColors.settingTextColor,
                                // fontSize: 16.0,
                              );
                            },
                            height: 150,
                            color: AppColors.settingCardColor,
                            padding: const EdgeInsets.all(50),
                            elevation: 10,
                            hoverElevation: 20,
                            focusElevation: 20,
                            highlightElevation: 20,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            enableFeedback: true,
                            visualDensity: VisualDensity.comfortable,
                            splashColor: AppColors.buttonSplashColorAlt,
                            highlightColor: AppColors.buttonSplashColorAlt,
                            child: const Icon(
                              // FontAwesomeIcons.fileInvoiceDollar,
                              CupertinoIcons.doc_richtext,
                              size: 50,
                              color: AppColors.settingTextColor,
                            ),
                          ),
                          const Positioned(
                            bottom: 5,
                            child: Text(
                              "Quotation",
                              style: TextStyle(
                                color: AppColors.settingTextColor,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: screenWidth * 0.07),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
