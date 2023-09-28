import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/utils.dart';
import 'bill_items.dart';
import 'instructions/invoice_instructions.dart';

class CustomerDetails extends StatefulWidget {
  const CustomerDetails({
    super.key,
    required this.billRef,
    required this.dated,
  });

  final String billRef;
  final DateTime dated;

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  final GlobalKey<FormState> customerFormKey = GlobalKey<FormState>();

  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerCompanyNameController = TextEditingController();
  TextEditingController customerAddressController = TextEditingController();
  TextEditingController customerCityController = TextEditingController();
  TextEditingController customerNumberController = TextEditingController();

  List<String> liftTypes = ['Passenger Lift', 'Cargo Lift', 'Hospital Lift'];

  String selectedLiftType = 'Passenger Lift';

  late String _billRef;
  late DateTime _dated;

  TextStyle textStyle = const TextStyle(
    color: AppColors.settingCardColor,
  );

  @override
  void initState() {
    super.initState();
    _billRef = widget.billRef;
    _dated = widget.dated;
  }

  String customerName = "Customer Name";
  String customerNumber = "Customer Number";
  String companyName = "Company Name";
  String customerAddress = "Customer Address";
  String customerCity = "Customer City";

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    TextStyle transitionStyle = const TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.normal,
      decoration: TextDecoration.none,
      fontStyle: FontStyle.normal,
      overflow: TextOverflow.ellipsis,
      fontFamily: 'RobotoSlab',
      // fontFamily: 'Lora',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Details"),
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
        key: customerFormKey,
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
                        controller: customerNameController,
                        decoration: const InputDecoration(
                          label: Text("Customer Name: "),
                          icon: Icon(
                            CupertinoIcons.person_solid,
                            color: AppColors.settingCardColor,
                            size: 25,
                          ),
                        ),
                        onTapOutside: (event) {
                          primaryFocus!.unfocus();
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              customerName = value.trim();
                            });
                          } else if (value.isEmpty) {
                            setState(() {
                              customerName = "Customer Name";
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null) {
                            return "Please enter Customer name";
                          } else if (value.isEmpty) {
                            return "Please enter Customer name";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        style: textStyle,
                        controller: customerNumberController,
                        decoration: const InputDecoration(
                          label: Text("Contact # (Optional): "),
                          icon: Icon(
                            CupertinoIcons.phone_fill,
                            color: AppColors.settingCardColor,
                            size: 25,
                          ),
                        ),
                        onTapOutside: (event) {
                          primaryFocus!.unfocus();
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              customerNumber = value.trim();
                            });
                          } else if (value.isEmpty) {
                            setState(() {
                              customerNumber = "Customer Number";
                            });
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        style: textStyle,
                        controller: customerCompanyNameController,
                        decoration: const InputDecoration(
                          label: Text("Company Name: "),
                          icon: Icon(
                            CupertinoIcons.building_2_fill,
                            color: AppColors.settingCardColor,
                            size: 25,
                          ),
                        ),
                        onTapOutside: (event) {
                          primaryFocus!.unfocus();
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              companyName = value.trim();
                            });
                          } else if (value.isEmpty) {
                            setState(() {
                              companyName = "Company Name";
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null) {
                            return "Please enter Company name";
                          } else if (value.isEmpty) {
                            return "Please enter Company name";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        style: textStyle,
                        controller: customerAddressController,
                        decoration: const InputDecoration(
                          label: Text("Customer Address: "),
                          icon: Icon(
                            CupertinoIcons.location_solid,
                            color: AppColors.settingCardColor,
                            size: 25,
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              customerAddress = value.trim();
                            });
                          } else if (value.isEmpty) {
                            setState(() {
                              customerAddress = "Customer Address";
                            });
                          }
                        },
                        onTapOutside: (event) {
                          primaryFocus!.unfocus();
                        },
                        validator: (value) {
                          if (value == null) {
                            return "Please enter Customer address";
                          } else if (value.isEmpty) {
                            return "Please enter Customer address";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        style: textStyle,
                        controller: customerCityController,
                        decoration: const InputDecoration(
                          label: Text("City: "),
                          icon: Icon(
                            CupertinoIcons.map_pin_ellipse,
                            color: AppColors.settingCardColor,
                            size: 25,
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              customerCity = value.trim();
                            });
                          } else if (value.isEmpty) {
                            setState(() {
                              customerCity = "City";
                            });
                          }
                        },
                        onTapOutside: (event) {
                          primaryFocus!.unfocus();
                        },
                        validator: (value) {
                          if (value == null) {
                            return "Please enter City";
                          } else if (value.isEmpty) {
                            return "Please enter City";
                          }
                          return null;
                        },
                      ),
                    ),
                    DropdownButton<String>(
                      value: selectedLiftType,
                      style: const TextStyle(
                          color: AppColors.settingCardColor, fontSize: 16),
                      dropdownColor: AppColors.settingBgColor,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedLiftType = newValue!;
                        });
                      },
                      items: liftTypes
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Hero(
                                  tag: 'refTag',
                                  transitionOnUserGestures: true,
                                  child: Container(
                                    width: screenWidth,
                                    color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Our Ref: $_billRef,",
                                          style: transitionStyle,
                                        ),
                                        Text(
                                          "Dated: ${Utils.formatDate(_dated)}",
                                          style: transitionStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  "To,",
                                  style: transitionStyle,
                                ),
                                Text(
                                  companyName,
                                  style: transitionStyle,
                                ),
                                Text(
                                  customerAddress,
                                  style: transitionStyle,
                                ),
                                Text(
                                  "$customerCity.",
                                  style: transitionStyle,
                                ),
                                Text(
                                  customerNumber,
                                  style: transitionStyle,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  "Attention. C/o $customerName,",
                                  style: transitionStyle,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  "Type: $selectedLiftType.",
                                  style: transitionStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
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
            //       if (customerFormKey.currentState!.validate()) {
            //         customerName = customerNameController.text.trim();
            //         customerNumber = customerNumberController.text.trim();
            //         companyName = customerCompanyNameController.text.trim();
            //         customerAddress = customerAddressController.text.trim();
            //         customerCity = customerCityController.text.trim();
            //         Navigator.push(
            //           context,
            //           PageRouteBuilder(
            //             pageBuilder: (context, animation, secondaryAnimation) {
            //               return BillItems(
            //                 customerName: customerName,
            //                 companyName: companyName,
            //                 customerAddress: customerAddress,
            //                 customerCity: customerCity,
            //                 billRef: _billRef,
            //                 liftType: selectedLiftType,
            //                 customerNumber: customerNumber,
            //                 dated: _dated,
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
        focusColor: AppColors.buttonSplashColor,
        foregroundColor: AppColors.buttonSplashColor,
        hoverColor: AppColors.buttonSplashColor,
        child: const Icon(
          CupertinoIcons.chevron_right_2,
          color: AppColors.settingTextColor,
          size: 40,
        ),
        onPressed: () {
          if (customerFormKey.currentState!.validate()) {
            customerName = customerNameController.text.trim();
            customerNumber = customerNumberController.text.trim();
            companyName = customerCompanyNameController.text.trim();
            customerAddress = customerAddressController.text.trim();
            customerCity = customerCityController.text.trim();
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return BillItems(
                    customerName: customerName,
                    companyName: companyName,
                    customerAddress: customerAddress,
                    customerCity: customerCity,
                    billRef: _billRef,
                    liftType: selectedLiftType,
                    customerNumber: customerNumber,
                    dated: _dated,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}
