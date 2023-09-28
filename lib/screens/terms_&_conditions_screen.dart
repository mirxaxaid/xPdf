import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/own_company_data.dart';
import '../utils/app_colors.dart';
import '../utils/utils.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  final GlobalKey<FormState> alertDialogFormKey = GlobalKey<FormState>();

  final CompanyTerms companyTerms = CompanyTerms();

  TextEditingController alertDialogInputController = TextEditingController();
  TextEditingController alertDialogPriceController = TextEditingController();

  @override
  void initState() {
    getTerms();
    super.initState();
  }

  Future<void> getTerms() async {
    await companyTerms.loadFromSharedPreferences();
    setState(() {});
  }

  TextStyle textStyle = const TextStyle(
    color: AppColors.settingCardColor,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms & Conditions"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            CupertinoIcons.back,
            color: AppColors.settingCardColor,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return getTerms();
        },
        child: ListView.builder(
          itemCount: companyTerms.termsAndConditions.length,
          itemBuilder: (context, index) {
            final term = companyTerms.termsAndConditions[index];
            final price = companyTerms.price[index];
            String formattedPrice = '';
            if (price.isNotEmpty){
              formattedPrice = Utils.formatTotalPrice(double.tryParse(price)!);
            }
            return ListTile(
              title: Text(term),
              subtitle: price.isNotEmpty ? Text(formattedPrice) : null,
              leading: Text((index + 1).toString()),
              trailing: IconButton(
                onPressed: () {
                  companyTerms.deleteTerm(index);
                  setState(() {});
                },
                icon: const Icon(Icons.delete_rounded,
                    color: AppColors.settingButtonColor),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showInputDialog(context);
        },
        tooltip: "Add Term or Condition",
        label: const Text(
          "Add Term",
          style: TextStyle(color: AppColors.settingTextColor),
        ),
        icon: const Icon(
          Icons.upload,
          color: AppColors.settingTextColor,
        ),
        backgroundColor: AppColors.settingCardColor,
        heroTag: 'floating_button',
        enableFeedback: true,
        focusColor: AppColors.buttonSplashColor,
        foregroundColor: AppColors.buttonSplashColor,
        hoverColor: AppColors.buttonSplashColor,
      ),
    );
  }

  Future<void> _showInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.settingBgColor,
          surfaceTintColor: AppColors.settingBgColor,
          title: const Text(
            'Term or Condition',
            style: TextStyle(color: AppColors.settingCardColor),
          ),
          content: Form(
            key: alertDialogFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  controller: alertDialogInputController,
                  style: textStyle,
                  decoration: const InputDecoration(
                    label: Text("Term:"),
                    hintText: 'Type something...',
                  ),
                  validator: (value) {
                    if (value == null) {
                      return "Please add Term or Condition";
                    } else if (value.isEmpty) {
                      return "Please add Term or Condition";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: alertDialogPriceController,
                  style: textStyle,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
                  ],
                  decoration: const InputDecoration(
                    label: Text("Price (Optional): "),
                    hintText: '0',
                  ),
                  onTapOutside: (event) {
                    primaryFocus!.unfocus();
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                alertDialogInputController.clear();
                alertDialogPriceController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                // Handle the user's input here
                if (alertDialogFormKey.currentState!.validate()) {
                  String userInput = alertDialogInputController.text.trim();
                  String price = alertDialogPriceController.text.trim();
                  companyTerms.addTerm(userInput, price);
                  setState(() {});
                  alertDialogInputController.clear();
                  alertDialogPriceController.clear();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
