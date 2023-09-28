import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:xpdf/api/shared_prefs.dart';
import 'package:xpdf/screens/dashboard.dart';
import 'package:xpdf/utils/navigation_utils.dart';

import '../../models/footer_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/fonts.dart';
import '../../utils/reuseable_widgets.dart';

class MyFooter extends StatefulWidget {
  final bool isFirstLaunch;
  final GlobalKey<FormState> footerFormKey;

  MyFooter({Key? key, required this.isFirstLaunch})
      : footerFormKey = GlobalKey<FormState>(),
        super(key: key);

  @override
  State<MyFooter> createState() => _MyFooterState();
}

class _MyFooterState extends State<MyFooter> {

  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController signedByController = TextEditingController();

  String street = 'Your Company Address / Street';
  String city = 'City';
  String zipCode = 'ZipCode';
  String name = 'Your Name';
  String number = 'Your Number';
  String signedBy = 'Your Name';

  late bool isFirstLaunch;

  Color selectedAddressColor = Colors.black;
  Color selectedContactColor = Colors.black;

  bool isUnderlined = false;
  Color underlineColor = Colors.red;

  FooterModel footerModel = FooterModel();

  MyFonts myFonts = MyFonts();

  List<String> fonts = ['Lora', 'RobotoSlab', 'FreeSans', 'Roboto'];
  String selectedFont = 'RobotoSlab';

  @override
  void initState() {
    super.initState();
    isFirstLaunch = widget.isFirstLaunch;
    getFonts();
    loadFromSharedPrefs();
  }

  Future<void> getFonts() async {
    await MyFonts.loadFromSharedPreferences().then((loadedFonts) {
      if (loadedFonts != null) {
        setState(() {
          myFonts = loadedFonts;
          fonts = myFonts.fonts;
          selectedFont = myFonts.selectedFont;
        });
      } else {
        fonts = ['Lora', 'RobotoSlab', 'FreeSans', 'Roboto'];
        selectedFont = 'RobotoSlab';
      }
    });
  }

  void loadFromSharedPrefs() {
    FooterModel.loadFromSharedPreferences().then((loadedModel) {
      if (loadedModel != null) {
        setState(() {
          footerModel = loadedModel;
          streetController.text = loadedModel.street;
          cityController.text = loadedModel.city;
          zipCodeController.text = loadedModel.zipCode;
          nameController.text = loadedModel.name;
          numberController.text = loadedModel.number;
          selectedAddressColor = loadedModel.selectedAddressColor;
          selectedContactColor = loadedModel.selectedContactColor;
          signedByController.text = loadedModel.signedBy;
          isUnderlined = loadedModel.isUnderlined;
          underlineColor = loadedModel.underlineColor;
          selectedFont = loadedModel.selectedFont;

          street = loadedModel.street;
          city = loadedModel.city;
          zipCode = loadedModel.zipCode;
          name = loadedModel.name;
          number = loadedModel.number;
          signedBy = loadedModel.signedBy;
        });
      }
    });
  }

  Future<void> saveFooterData() async {
    footerModel.street = streetController.text;
    footerModel.city = cityController.text;
    footerModel.zipCode = zipCodeController.text;
    footerModel.name = nameController.text;
    footerModel.number = numberController.text;
    footerModel.selectedFont = selectedFont;
    footerModel.isUnderlined = isUnderlined;
    footerModel.selectedAddressColor = selectedAddressColor;
    footerModel.selectedContactColor = selectedContactColor;
    footerModel.underlineColor = underlineColor;
    footerModel.signedBy = signedByController.text;

    // Save footerModel to SharedPreferences
    await footerModel.saveToSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    TextStyle textStyle = const TextStyle(
      color: AppColors.settingCardColor,
    );

    TextStyle footerContactStyle = TextStyle(
      color: selectedContactColor,
      fontSize: 8,
      fontFamily: selectedFont,
    );
    TextStyle footerContactStyleBold = TextStyle(
      color: selectedContactColor,
      fontSize: 8,
      fontWeight: FontWeight.w700,
      fontFamily: selectedFont,
    );
    TextStyle footerAddressStyle = TextStyle(
      color: selectedAddressColor,
      fontSize: 8,
      fontFamily: selectedFont,
    );
    TextStyle footerAddressStyleBold = TextStyle(
      color: selectedAddressColor,
      fontSize: 8,
      fontWeight: FontWeight.w700,
      fontFamily: selectedFont,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Footer"),
        leading: !isFirstLaunch
            ? IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            CupertinoIcons.chevron_back,
            color: AppColors.settingCardColor,
          ),
        )
            : const SizedBox(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: widget.footerFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Your Company Address:",
                style: TextStyle(
                  color: AppColors.settingCardColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              Column(
                children: [
                  ReUsableWidgets.buildTextFormFieldWithTextColor(
                    controller: streetController,
                    labelText: 'Street:',
                    icon: Icons.streetview_rounded,
                    onTap: () {
                      materialColorPicker(true);
                    },
                    onChanged: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          street = "Your Company Address / Street";
                        });
                      } else {
                        setState(() {
                          street = streetController.text.trim();
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        return "Please enter your company address";
                      } else if (value.isEmpty) {
                        return "Please enter your company address";
                      }
                      return null;
                    },
                    textStyle: textStyle,
                    labelColor: AppColors.settingCardColor,
                    iconColor: AppColors.settingCardColor,
                    suffixContainerColor: selectedAddressColor,
                    suffixIconBorderColor: AppColors.settingCardColor,
                    suffixIconBorderRadius: BorderRadius.circular(10),
                  ),
                  ReUsableWidgets.buildTextFormFieldWithTextColor(
                    controller: cityController,
                    labelText: 'City:',
                    icon: CupertinoIcons.building_2_fill,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          city = "City";
                        });
                      } else {
                        setState(() {
                          city = cityController.text.trim();
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        return "Please enter your city";
                      } else if (value.isEmpty) {
                        return "Please enter your city";
                      }
                      return null;
                    },
                    textStyle: textStyle,
                    labelColor: AppColors.settingCardColor,
                    iconColor: AppColors.settingCardColor,
                  ),
                  ReUsableWidgets.buildTextFormFieldWithTextColor(
                    controller: zipCodeController,
                    labelText: 'ZipCode:',
                    icon: CupertinoIcons.number_square,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          zipCode = "";
                        });
                      } else {
                        setState(() {
                          zipCode = zipCodeController.text.trim();
                        });
                      }
                    },
                    textStyle: textStyle,
                    labelColor: AppColors.settingCardColor,
                    iconColor: AppColors.settingCardColor,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Divider(
                  color: AppColors.settingCardColor,
                  thickness: 1.2,
                ),
              ),
              ReUsableWidgets.buildTextFormFieldWithTextColor(
                controller: signedByController,
                labelText: 'Signed By:',
                icon: CupertinoIcons.signature,
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      signedBy = "Your Name";
                    });
                  } else {
                    setState(() {
                      signedBy = signedByController.text.trim();
                    });
                  }
                },
                validator: (value) {
                  if (value == null) {
                    return "Please enter signer name";
                  } else if (value.isEmpty) {
                    return "Please enter signer name";
                  }
                  return null;
                },
                textStyle: textStyle,
                labelColor: AppColors.settingCardColor,
                iconColor: AppColors.settingCardColor,
              ),
              ReUsableWidgets.buildTextFormFieldWithTextColor(
                controller: nameController,
                labelText: 'Contact Name:',
                icon: CupertinoIcons.person_fill,
                onTap: () {
                  materialColorPicker(false);
                },
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      name = "Your Name";
                    });
                  } else {
                    setState(() {
                      name = nameController.text.trim();
                    });
                  }
                },
                validator: (value) {
                  if (value == null) {
                    return "Please enter your name";
                  } else if (value.isEmpty) {
                    return "Please enter your name";
                  }
                  return null;
                },
                textStyle: textStyle,
                labelColor: AppColors.settingCardColor,
                iconColor: AppColors.settingCardColor,
                suffixContainerColor: selectedContactColor,
                suffixIconBorderColor: AppColors.settingCardColor,
                suffixIconBorderRadius: BorderRadius.circular(10),
              ),
              ReUsableWidgets.buildTextFormFieldWithTextColor(
                controller: numberController,
                labelText: 'Contact Number:',
                icon: CupertinoIcons.phone_fill,
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      number = "Your Number";
                    });
                  } else {
                    setState(() {
                      number = numberController.text.trim();
                    });
                  }
                },
                validator: (value) {
                  if (value == null) {
                    return "Please enter your number";
                  } else if (value.isEmpty) {
                    return "Please enter your number";
                  }
                  return null;
                },
                textStyle: textStyle,
                labelColor: AppColors.settingCardColor,
                iconColor: AppColors.settingCardColor,
              ),
              SizedBox(
                width: screenWidth,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          CupertinoIcons.underline,
                          color: AppColors.settingCardColor,
                          size: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CupertinoSwitch(
                            value: isUnderlined,
                            onChanged: (value) {
                              setState(() {
                                isUnderlined = value;
                              });
                            },
                          ),
                        ),
                        const Icon(
                          Icons.color_lens_rounded,
                          color: AppColors.settingCardColor,
                          size: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              materialColorPickerForUnderLine();
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.settingCardColor,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10)),
                                color: underlineColor,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.font_download_rounded,
                            color: AppColors.settingCardColor,
                            size: 30,
                          ),
                        ),
                        DropdownButton<String>(
                          value: selectedFont,
                          style: const TextStyle(
                              color: AppColors.settingCardColor,
                              fontSize: 16),
                          dropdownColor: AppColors.settingBgColor,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedFont = newValue!;
                            });
                          },
                          items: fonts
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ]),
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
                          horizontal: 20.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.text_alignleft,
                              color: AppColors.settingCardColorA,
                              size: screenWidth / 3),
                          Text(
                            "   Thanks,\n\n   $signedBy",
                            style: TextStyle(
                              fontFamily: selectedFont,
                              fontSize: 8,
                            ),
                          ),
                          isUnderlined
                              ? Divider(
                                  color: underlineColor,
                                  thickness: 1,
                                )
                              : const SizedBox(height: 15),
                          Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Contact Info: ",
                                          style: footerContactStyleBold),
                                      Text(
                                        "$name : $number",
                                        style: footerContactStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints.loose(
                                      const Size.fromWidth(150)),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Address: ",
                                          style: footerAddressStyleBold),
                                      Text(
                                        street,
                                        softWrap: true,
                                        maxLines: 3,
                                        style: footerAddressStyle,
                                      ),
                                      Text(
                                        "$city, $zipCode",
                                        softWrap: true,
                                        maxLines: 1,
                                        style: footerAddressStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                  onPressed: () {
                    if (widget.footerFormKey.currentState!.validate()) {
                      saveFooterData();
                      Fluttertoast.showToast(
                        msg: "Saved",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 1,
                        backgroundColor: AppColors.settingCardColor,
                        textColor: AppColors.settingTextColor,
                      );
                      !isFirstLaunch
                          ? Navigator.pop(context)
                          : {
                              SharedPrefs.firstAppLaunched(),
                              NavigationUtils
                                  .navigateWithSlideTransition_Replacement(
                                      context, const Dashboard()),
                            };
                    }
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: AppColors.settingCardColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> materialColorPicker(bool isAddress) async {
    Color pickedColor = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: MaterialPicker(
              enableLabel: true,
              portraitOnly: true,
              pickerColor:
                  isAddress ? selectedAddressColor : selectedContactColor,
              onColorChanged: (Color color) {
                if (isAddress) {
                  selectedAddressColor = color;
                } else if (!isAddress) {
                  selectedContactColor = color;
                }
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(
                  isAddress ? selectedAddressColor : selectedContactColor,
                );
              },
            ),
          ],
        );
      },
    );
    if (isAddress) {
      setState(() {
        selectedAddressColor = pickedColor;
      });
    } else if (!isAddress) {
      setState(() {
        selectedContactColor = pickedColor;
      });
    }
  }

  Future<void> materialColorPickerForUnderLine() async {
    Color pickedColor = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: MaterialPicker(
              enableLabel: true,
              portraitOnly: true,
              pickerColor: underlineColor,
              onColorChanged: (Color color) {
                underlineColor = color;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(underlineColor);
              },
            ),
          ],
        );
      },
    );
    setState(() {
      underlineColor = pickedColor;
    });
  }

  Future<void> hueRingColorPicker(bool isAddress) async {
    Color pickedColor = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: HueRingPicker(
              portraitOnly: true,
              pickerColor:
                  isAddress ? selectedAddressColor : selectedContactColor,
              onColorChanged: (Color color) {
                if (isAddress) {
                  selectedAddressColor = color;
                } else {
                  selectedContactColor = color;
                }
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(
                  isAddress ? selectedAddressColor : selectedContactColor,
                );
              },
            ),
          ],
        );
      },
    );
    if (isAddress) {
      setState(() {
        selectedAddressColor = pickedColor;
      });
    } else {
      setState(() {
        selectedContactColor = pickedColor;
      });
    }
  }
}
