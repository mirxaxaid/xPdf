import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:xpdf/models/header_model.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:xpdf/screens/settings_screens/footer.dart';
import 'package:xpdf/utils/navigation_utils.dart';
import '../../utils/app_colors.dart';
import '../../utils/fonts.dart';

class MyHeader extends StatefulWidget {
  final bool isFirstLaunch;

  const MyHeader({super.key, required this.isFirstLaunch});

  @override
  State<MyHeader> createState() => _MyHeaderState();
}

class _MyHeaderState extends State<MyHeader> {
  final GlobalKey<FormState> headerFormKey = GlobalKey<FormState>();

  TextEditingController companyNameController = TextEditingController();

  bool isUnderlined = false;
  Color underlineColor = Colors.red;
  String companyName = "Company Name";
  Color textSelectedColor = Colors.black;
  XFile? imageFile;

  MyFonts myFonts = MyFonts();

  late bool isFirstLaunch;

  final _scrollController = ScrollController();

  List<String> fonts = ['Lora', 'RobotoSlab', 'FreeSans', 'Roboto'];
  String selectedFont = 'RobotoSlab';

  late HeaderModel? loadedHeader;

  late String loadedTitle;
  late String loadedFont;
  late bool loadedIsUnderline;
  late Color loadedTitleColor;
  late Color loadedUnderlineColor;
  File? loadedFile;

  @override
  void initState() {
    super.initState();
    isFirstLaunch = widget.isFirstLaunch;
    getFonts();
    getHeader();
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

  Future<void> getHeader() async {
    XFile? convertedXFile;
    loadedHeader = await HeaderModel.loadFromSharedPreferences();
    if (loadedHeader != null) {
      loadedTitle = loadedHeader!.title;
      loadedFont = loadedHeader!.font;
      loadedIsUnderline = loadedHeader!.isUnderline;
      loadedTitleColor = loadedHeader!.titleColor;
      loadedUnderlineColor = loadedHeader!.underlineColor;
      loadedFile = loadedHeader!.imageFile;
      convertedXFile = await convertFileToXFile(loadedFile);
      setState(() {
        companyName = loadedTitle;
        companyNameController.text = loadedTitle;
        selectedFont = loadedFont;
        isUnderlined = loadedIsUnderline;
        textSelectedColor = loadedTitleColor;
        underlineColor = loadedUnderlineColor;
        imageFile = convertedXFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double getFontSize() {
      if (screenWidth > 300) {
        return 24;
      } else if (screenWidth < 300 && screenWidth > 200) {
        return 18;
      } else {
        return 14;
      }
    }

    double fontSize = getFontSize();

    TextStyle textStyle = const TextStyle(
      color: AppColors.settingCardColor,
    );

    TextStyle headingStyle = TextStyle(
      color: textSelectedColor,
      fontSize: fontSize,
      fontFamily: selectedFont,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Header"),
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: headerFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      style: textStyle,
                      maxLines: null,
                      controller: companyNameController,
                      decoration: InputDecoration(
                        label: const Text('Title / Company Name: '),
                        labelStyle: textStyle,
                        icon: const Icon(
                          CupertinoIcons.building_2_fill,
                          color: AppColors.settingCardColor,
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              materialColorPicker(true);
                              //hueRingPicker(true);
                            },
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.settingCardColor,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10)),
                                color: textSelectedColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTapOutside: (event) {
                        primaryFocus!.unfocus();
                      },
                      onChanged: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            companyName = "Company Name";
                          });
                        } else {
                          setState(() {
                            companyName = companyNameController.text.trim();
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null) {
                          return "Please enter your company name";
                        } else if (value.isEmpty) {
                          return "Please enter your company name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      width: screenWidth,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _scrollController,
                        child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
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
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.color_lens_rounded,
                                    color: AppColors.settingCardColor,
                                    size: 30,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        materialColorPicker(false);
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppColors
                                                .settingCardColor,
                                          ),
                                          borderRadius:
                                              const BorderRadius.all(
                                                  Radius.circular(10)),
                                          color: underlineColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
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
                                    dropdownColor:
                                        AppColors.settingBgColor,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedFont = newValue!;
                                      });
                                    },
                                    items: fonts
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                  onPressed: () async {
                                    _getFromGallery();
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.photo_fill,
                                    color: AppColors.settingCardColor,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                    Card(
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
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  imageFile != null
                                      ? Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Image.file(
                                              File(imageFile!.path),
                                              width: fontSize * 2,
                                              height: fontSize * 2,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  Expanded(
                                    flex: 7,
                                    child: Container(
                                      alignment: imageFile == null
                                          ? Alignment.center
                                          : Alignment.centerLeft,
                                      child: Text(
                                        companyName,
                                        style: headingStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              isUnderlined
                                  ? Divider(
                                      thickness: 2,
                                      color: isUnderlined
                                          ? underlineColor
                                          : Colors.white,
                                    )
                                  : const SizedBox(),
                              Icon(
                                CupertinoIcons.text_alignleft,
                                color: AppColors.settingCardColorA,
                                size: screenWidth / 3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: OutlinedButton(
              onPressed: () {
                if (headerFormKey.currentState!.validate()) {
                  saveHeaderinSharedPref();
                  Fluttertoast.showToast(
                    msg: "Saved",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 1,
                    backgroundColor: AppColors.settingCardColor,
                    textColor: AppColors.settingTextColor,
                  );
                  !isFirstLaunch
                      ? Navigator.of(context).pop()
                      : NavigationUtils.navigateWithSlideTransition_Replacement(
                          context,
                          MyFooter(
                            isFirstLaunch: isFirstLaunch,
                          ));
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
    );
  }

  Future<void> saveHeaderinSharedPref() async {
    String title = companyNameController.text.trim();
    File? fileImage = await convertXFileToFile(imageFile);
    HeaderModel header = HeaderModel(
      title: title,
      font: selectedFont,
      isUnderline: isUnderlined,
      titleColor: textSelectedColor,
      underlineColor: underlineColor,
      imageFile: fileImage,
    );
    await header.saveToSharedPreferences();
  }

  Future<File?> convertXFileToFile(XFile? xFile) async {
    if (xFile == null) {
      return null;
    }

    // Use the File constructor to create a File object from the XFile's path
    File file = File(xFile.path);

    // Now you have a File object that you can work with
    return file;
  }

  Future<XFile?> convertFileToXFile(File? file) async {
    if (file == null) {
      return null;
    }

    // Use the File constructor to create a File object from the XFile's path
    XFile xFile = XFile(file.path);

    // Now you have a File object that you can work with
    return xFile;
  }

  Future<void> hueRingPicker(bool isText) async {
    Color pickedColor = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: HueRingPicker(
              pickerColor: isText ? textSelectedColor : underlineColor,
              onColorChanged: (Color color) {
                if (isText) {
                  textSelectedColor = color;
                } else {
                  underlineColor = color;
                }
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context)
                    .pop(isText ? textSelectedColor : underlineColor);
              },
            ),
          ],
        );
      },
    );
    if (isText) {
      setState(() {
        textSelectedColor = pickedColor;
      });
    } else {
      setState(() {
        underlineColor = pickedColor;
      });
    }
  }

  Future<void> materialColorPicker(bool isText) async {
    Color pickedColor = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: MaterialPicker(
              enableLabel: true,
              portraitOnly: true,
              pickerColor: isText ? textSelectedColor : underlineColor,
              onColorChanged: (Color color) {
                if (isText) {
                  textSelectedColor = color;
                } else {
                  underlineColor = color;
                }
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context)
                    .pop(isText ? textSelectedColor : underlineColor);
              },
            ),
          ],
        );
      },
    );
    if (isText) {
      setState(() {
        textSelectedColor = pickedColor;
      });
    } else {
      setState(() {
        underlineColor = pickedColor;
      });
    }
  }

  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = XFile(pickedFile.path);
      });
    }
  }
}
