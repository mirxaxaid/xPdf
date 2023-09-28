import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/fonts.dart';
import '../utils/utils.dart';
import 'customer_details.dart';
import 'instructions/invoice_instructions.dart';

class BillReference extends StatefulWidget {
  const BillReference({super.key});

  @override
  State<BillReference> createState() => _BillReferenceState();
}

class _BillReferenceState extends State<BillReference> {
  final GlobalKey<FormState> billRefFormKey = GlobalKey<FormState>();

  TextEditingController billRefController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  String billRef = "Invoice Reference";

  MyFonts myFonts = MyFonts();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _loadData() async {
    myFonts = (await MyFonts.loadFromSharedPreferences())!;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;

    String formattedDate = Utils.formatDate(selectedDate);
    TextStyle textStyle = const TextStyle(
      color: AppColors.settingCardColor,
    );

    TextStyle transitionStyle = TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.normal,
      decoration: TextDecoration.none,
      fontStyle: FontStyle.normal,
      overflow: TextOverflow.ellipsis,
      fontFamily: myFonts != null ? myFonts.selectedFont : 'RobotoSlab',
      // fontFamily: 'Lora',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bill Reference"),
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
            },
            icon: const Icon(
              Icons.info_outline_rounded,
              color: AppColors.settingCardColor,
            ),
          ),
        ],
      ),
      body: Form(
        key: billRefFormKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        style: textStyle,
                        controller: billRefController,
                        decoration: const InputDecoration(
                          label: Text("Bill Reference: "),
                          icon: Icon(
                            CupertinoIcons.doc_fill,
                            color: AppColors.settingCardColor,
                            size: 25,
                          ),
                        ),
                        onTapOutside: (event) {
                          primaryFocus!.unfocus();
                        },
                        onChanged: (value) {
                          if (billRef == "") {
                            setState(() {
                              billRef = "Invoice Reference";
                            });
                          } else if (billRef.isEmpty) {
                            setState(() {
                              billRef = "Invoice Reference";
                            });
                          } else if (value.isEmpty) {
                            setState(() {
                              billRef = "Invoice Reference";
                            });
                          } else {
                            setState(() {
                              billRef =
                                  billRefController.text.toUpperCase().trim();
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null) {
                            return "Please enter Bill Reference";
                          } else if (value.isEmpty) {
                            return "Please enter Bill Reference";
                          }
                          return null;
                        },
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.settingCardColor,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                CupertinoIcons.calendar_today,
                                color: AppColors.settingCardColor,
                              ),
                              Text(
                                " ${Utils.formatDate(selectedDate)}",
                                style: const TextStyle(
                                  color: AppColors.settingCardColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Container(
                          width: screenWidth,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.settingCardColor,
                              width: 2,
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 18.0),
                            child: Hero(
                              tag: 'refTag',
                              transitionOnUserGestures: true,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Our Ref: $billRef,",
                                    style: transitionStyle,
                                  ),
                                  Text(
                                    "Dated: $formattedDate",
                                    style: transitionStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: IconButton(
            //     icon: const Icon(
            //       CupertinoIcons.chevron_right_2,
            //       color: AppColors.settingButtonColor,
            //       size: 40,
            //     ),
            //     onPressed: () {
            //       if (billRefFormKey.currentState!.validate()) {
            //         //String billRef = billRefController.text.trim();
            //         Navigator.push(
            //           context,
            //           PageRouteBuilder(
            //             pageBuilder: (context, animation, secondaryAnimation) {
            //               return CustomerDetails(
            //                 billRef: billRef,
            //                 dated: selectedDate,
            //               );
            //             },
            //             transitionsBuilder:
            //                 (context, animation, secondaryAnimation, child) {
            //               return SlideTransition(
            //                 position: Tween<Offset>(
            //                   begin: const Offset(1.0, 0.0),
            //                   // Slide in from the right
            //                   end: Offset.zero,
            //                 ).animate(animation),
            //                 child: child,
            //               );
            //             },
            //           ),
            //         );
            //       }
            //     },
            //   ),
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Next",
        backgroundColor: AppColors.settingCardColor,
        // elevation: 0.0,
        // disabledElevation: 0.0,
        // focusElevation: 0.0,
        // highlightElevation: 0.0,
        // hoverElevation: 0.0,
        heroTag: 'floating_button',
        mini: false,
        enableFeedback: true,
        focusColor: AppColors.buttonSplashColorAlt,
        foregroundColor: AppColors.buttonSplashColorAlt,
        hoverColor: AppColors.buttonSplashColorAlt,
        child: const Icon(
          CupertinoIcons.chevron_right_2,
          color: AppColors.settingTextColor,
          size: 40,
        ),
        onPressed: () {
          if (billRefFormKey.currentState!.validate()) {
            //String billRef = billRefController.text.trim();
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return CustomerDetails(
                    billRef: billRef,
                    dated: selectedDate,
                  );
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
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}
