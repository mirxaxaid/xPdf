
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xpdf/screens/terms_&_conditions_screen.dart';
import 'package:xpdf/utils/fonts.dart';

import '../../api/pdf_api.dart';
import '../../utils/app_colors.dart';
import '../../utils/utils.dart';
import '../api/pdf_bill_api.dart';
import '../models/customer.dart';
import '../models/footer_model.dart';
import '../models/header_model.dart';
import '../models/invoice.dart';
import '../models/own_company_data.dart';

class BillItems extends StatefulWidget {
  const BillItems({
    super.key,
    required this.customerName,
    required this.companyName,
    required this.customerAddress,
    required this.customerCity,
    required this.billRef,
    required this.liftType,
    required this.customerNumber,
    required this.dated,
  });

  final String customerName;
  final String companyName;
  final String customerAddress;
  final String customerCity;
  final String billRef;
  final String liftType;
  final String customerNumber;
  final DateTime dated;

  @override
  State<BillItems> createState() => _BillItemsState();
}

class _BillItemsState extends State<BillItems> {
  final GlobalKey<FormState> itemFormKey = GlobalKey<FormState>();

  late String _customerName;
  late String _companyName;
  late String _customerAddress;
  late String _customerCity;
  late String _liftType;
  late String _billRef;
  late String _customerNumber;
  late DateTime _dated;

  TextEditingController itemDescriptionController = TextEditingController();
  TextEditingController itemQuantityController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();

  final CompanyTerms companyTerms = CompanyTerms();
  HeaderModel myHeader = HeaderModel();
  FooterModel myFooter = FooterModel();
  MyFonts myFonts = MyFonts();

  double totalPrice = 0.0;

  @override
  void initState() {
    _customerName = widget.customerName;
    _companyName = widget.companyName;
    _customerAddress = widget.customerAddress;
    _customerCity = widget.customerCity;
    _billRef = widget.billRef;
    _liftType = widget.liftType;
    _customerNumber = widget.customerNumber;
    _dated = widget.dated;
    _loadData();
    getTerms();
    super.initState();
  }

  Future<void> getTerms() async {
    await companyTerms.loadFromSharedPreferences();
    setState(() {});
  }

  Future<void> _loadData() async {
    myHeader = (await HeaderModel.loadFromSharedPreferences())!;
    myFooter = (await FooterModel.loadFromSharedPreferences())!;
    myFonts = (await MyFonts.loadFromSharedPreferences())!;
    setState(() {});
  }

  Map<int, Map<String, dynamic>> items = {};
  int counter = 1;

  void addItem(Map<String, dynamic> itemData) {
    if (itemData.isNotEmpty) {
      setState(() {
        items[counter] = itemData;
        counter++;
      });
    }
  }

  void textFieldClear() {
    itemDescriptionController.clear();
    itemQuantityController.clear();
    itemPriceController.clear();
  }

  void removeItem(int itemKey) {
    setState(() {
      items.remove(itemKey);
    });
  }

  TextStyle textStyle = const TextStyle(
    color: AppColors.settingCardColor,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bill Items"),
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
                    return const TermsAndConditionsScreen();
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
              Icons.list_alt_rounded,
              color: AppColors.settingCardColor,
            ),
          )
        ],
      ),
      body: Form(
        key: itemFormKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextFormField(
                        style: textStyle,
                        controller: itemDescriptionController,
                        decoration: const InputDecoration(
                          label: Text("Item Description: "),
                          icon: Icon(
                            Icons.shopping_cart_checkout_outlined,
                            color: AppColors.settingCardColor,
                          ),
                        ),
                        onTapOutside: (event) {
                          primaryFocus!.unfocus();
                        },
                        validator: (value) {
                          if (value == null) {
                            return "Please enter item description";
                          } else if (value.isEmpty) {
                            return "Please enter item description";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 4,
                            child: TextFormField(
                              style: textStyle,
                              controller: itemQuantityController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              decoration: const InputDecoration(
                                label: Text("Quantity: "),
                                icon: Icon(
                                  Icons.numbers_rounded,
                                  color: AppColors.settingCardColor,
                                ),
                              ),
                              onTapOutside: (event) {
                                primaryFocus!.unfocus();
                              },
                              validator: (value) {
                                if (value == null) {
                                  return "Please enter Quantity";
                                } else if (value.isEmpty) {
                                  return "Please enter Quantity";
                                } else if (double.tryParse(value) == 0) {
                                  return "Quantity cannot be 0";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 6,
                            child: TextFormField(
                              style: textStyle,
                              controller: itemPriceController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r"[0-9]")),
                              ],
                              decoration: const InputDecoration(
                                label: Text("Unit Price: "),
                                icon: Icon(
                                  Icons.attach_money_rounded,
                                  color: AppColors.settingCardColor,
                                ),
                              ),
                              onTapOutside: (event) {
                                primaryFocus!.unfocus();
                              },
                              validator: (value) {
                                if (value == null) {
                                  return "Please enter Unit Price";
                                } else if (value.isEmpty) {
                                  return "Please enter Unit Price";
                                } else if (double.tryParse(value) == 0) {
                                  return "Price cannot be 0";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: () {
                          String itemDescription =
                              itemDescriptionController.text.trim();
                          int quantity =
                              int.tryParse(itemQuantityController.text) ?? 0;
                          double price =
                              double.tryParse(itemPriceController.text) ?? 0;

                          if (itemFormKey.currentState!.validate()) {
                            addItem({
                              'description': itemDescription,
                              'quantity': quantity,
                              'itemPrice': price,
                            });
                            textFieldClear();
                          }
                        },
                        child: const Text(
                          'Add Item',
                          style: TextStyle(
                            color: AppColors.settingCardColor,
                          ),
                        ),
                      ),
                    ),
                    const Divider(
                        color: AppColors.settingCardColor, thickness: 2),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 350),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Table(
                              border: TableBorder.all(),
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              children: const [
                                TableRow(
                                  decoration: BoxDecoration(
                                      color: AppColors.settingCardColor),
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Description: ",
                                          style: TextStyle(
                                              color:
                                                  AppColors.settingTextColor),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Quantity: ",
                                          style: TextStyle(
                                              color:
                                                  AppColors.settingTextColor),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Unit Price: ",
                                          style: TextStyle(
                                              color:
                                                  AppColors.settingTextColor),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Total: ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.settingTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          " ",
                                          style: TextStyle(
                                              color:
                                                  AppColors.settingTextColor),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final itemKey = items.keys.toList()[index];
                                final item = items[itemKey];
                                String itemPrice = Utils.formatPriceForTable(
                                    item?['itemPrice']);
                                if (item?['quantity'] >= 1) {
                                  totalPrice =
                                      item?['quantity'] * item?['itemPrice'];
                                } else {
                                  totalPrice = item?['itemPrice'];
                                }
                                String strTotalPrice =
                                    Utils.formatPriceForTable(totalPrice);
                                return Column(
                                  children: [
                                    Table(
                                      border: TableBorder.all(),
                                      defaultVerticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      children: [
                                        TableRow(
                                          children: [
                                            TableCell(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child:
                                                    Text(item?['description']),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                    "${item?['quantity'].toString()}"),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(itemPrice),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(strTotalPrice),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: IconButton(
                                                  onPressed: () {
                                                    // Remove the item when the button is pressed
                                                    removeItem(itemKey);
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete_rounded,
                                                    color: AppColors
                                                        .settingButtonColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                        color: AppColors.settingCardColor, thickness: 2),
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
            //     onPressed: () async {
            //       companyTerms.loadFromSharedPreferences();
            //       if (items.isEmpty) {
            //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            //             content: Text("Please ADD some items...")));
            //         itemFormKey.currentState!.validate();
            //       } else {
            //         String dateForQR = Utils.formatDate(DateTime.now());
            //         List<InvoiceItem> invoiceItems = [];
            //         items.forEach((key, value) {
            //           invoiceItems.add(
            //             InvoiceItem(
            //               description: value['description'] ?? '',
            //               quantity: value['quantity'] ?? 0,
            //               itemPrice: value['itemPrice'] ?? 0.0,
            //             ),
            //           );
            //         });
            //         final invoice = Invoice(
            //           info: InvoiceInfo(
            //             invoiceDescription: "Bill",
            //             invoiceNumber:
            //                 "$_companyName _ $_customerName _ $dateForQR"
            //                     .toUpperCase(),
            //             liftType: _liftType,
            //             billRef: _billRef,
            //             date: _dated,
            //           ),
            //           customer: Customer(
            //             name: _customerName,
            //             companyName: _companyName,
            //             number: _customerNumber,
            //             address: Address(
            //               address: _customerAddress,
            //               city: _customerCity,
            //             ),
            //           ),
            //           items: invoiceItems,
            //         );
            //         final pdfFile = await PdfBillApi.generate(
            //             invoice, companyTerms, myHeader, myFooter, myFonts);
            //
            //         Fluttertoast.showToast(
            //           msg: "Opening Pdf",
            //           toastLength: Toast.LENGTH_SHORT,
            //           gravity: ToastGravity.SNACKBAR,
            //           timeInSecForIosWeb: 1,
            //           backgroundColor: AppColors.settingCardColor,
            //           textColor: AppColors.settingTextColor,
            //           // fontSize: 16.0,
            //         );
            //
            //         PdfApi.openFile(pdfFile);
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
        onPressed: () async {
          companyTerms.loadFromSharedPreferences();
          if (items.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Please ADD some items...")));
            itemFormKey.currentState!.validate();
          } else {
            String dateForQR = Utils.formatDate(DateTime.now());
            List<InvoiceItem> invoiceItems = [];
            items.forEach((key, value) {
              invoiceItems.add(
                InvoiceItem(
                  description: value['description'] ?? '',
                  quantity: value['quantity'] ?? 0,
                  itemPrice: value['itemPrice'] ?? 0.0,
                ),
              );
            });
            final invoice = Invoice(
              info: InvoiceInfo(
                invoiceDescription: "Bill",
                invoiceNumber:
                "$_companyName _ $_customerName _ $dateForQR"
                    .toUpperCase(),
                liftType: _liftType,
                billRef: _billRef,
                date: _dated,
              ),
              customer: Customer(
                name: _customerName,
                companyName: _companyName,
                number: _customerNumber,
                address: Address(
                  address: _customerAddress,
                  city: _customerCity,
                ),
              ),
              items: invoiceItems,
            );
            final pdfFile = await PdfBillApi.generate(
                invoice, companyTerms, myHeader, myFooter, myFonts);

            Fluttertoast.showToast(
              msg: "Opening Pdf",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: AppColors.settingCardColor,
              textColor: AppColors.settingTextColor,
              // fontSize: 16.0,
            );

            PdfApi.openFile(pdfFile);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}
