import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:xpdf/api/pdf_api.dart';
import 'package:xpdf/models/footer_model.dart';
import 'package:xpdf/models/header_model.dart';
import 'package:xpdf/utils/fonts.dart';

import '../models/invoice.dart';
import '../models/own_company_data.dart';
import '../utils/utils.dart';

class PdfBillApi {
  static Future<File> generate(Invoice invoice, CompanyTerms companyTerms,
      HeaderModel myHeader, FooterModel myFooter, MyFonts myFonts) async {
    final pdf = pw.Document();

    String pdfName =
        "${invoice.customer.companyName}_${invoice.customer.name}_${Utils.formatDateForFileName(invoice.info.date)}.pdf";

    File? imageFile;
    Uint8List? imageBytes;
    MemoryImage? memoryImage;

    Uint8List fileToUint8List(File file) {
      final bytes = file.readAsBytesSync();
      return Uint8List.fromList(bytes);
    }

    if (myHeader.imageFile != null) {
      imageFile = File(myHeader.imageFile!.path);
      imageBytes = fileToUint8List(imageFile);
      memoryImage = MemoryImage(Uint8List.fromList(imageBytes));
    }

    final pdfFooterColors = await FooterModel().pwConversion();
    final pdfHeaderColors = await HeaderModel().pwConversion();

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      theme: pw.ThemeData(defaultTextStyle: TextStyle(font: pw.Font.times())),
      build: (pw.Context context) {
        return [
          SizedBox(height: 1.5 * PdfPageFormat.cm),
          dated(invoice),
          SizedBox(height: 1 * PdfPageFormat.cm),
          buildCustomerDetails(invoice),
          SizedBox(height: 1 * PdfPageFormat.cm),
          builtElevatorType(invoice),
          SizedBox(height: 1 * PdfPageFormat.cm),
          buildInvoice(invoice),
          SizedBox(height: 0.4 * PdfPageFormat.cm),
          buildTotal(invoice),
          buildTerms(companyTerms),
          SizedBox(height: 2 * PdfPageFormat.cm),
          signedBy(myFooter),
        ];
      },
      header: (context) =>
          buildCompanyHeader(myHeader, memoryImage, pdfHeaderColors),
      footer: (context) => buildFooter(myFooter, pdfFooterColors),
    ));

    return PdfApi.saveDocument(name: pdfName, pdf: pdf);
  }

  static Widget buildCompanyHeader(HeaderModel myHeader, MemoryImage? imageFile,
      Map<String, PdfColor> pdfHeaderColors) {
    final PdfColor titleColor = pdfHeaderColors['titleColor']!;
    final PdfColor headerUnderlineColor = pdfHeaderColors['underlineColor']!;
    print("imageFile in Header: ${myHeader.imageFile}");

    TextStyle headerStyle = TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: titleColor,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            myHeader.imageFile != null
                ? Expanded(
                    flex: 3,
                    child: Image(
                      imageFile!,
                      height: 0.8 * PdfPageFormat.inch,
                      width: 1.6 * PdfPageFormat.inch,
                      dpi: 300,
                      fit: BoxFit.contain,
                    ),
                  )
                : SizedBox(),
            SizedBox(width: 4 * PdfPageFormat.mm),
            Expanded(
              flex: 7,
              child: Container(
                alignment: myHeader.imageFile == null
                    ? Alignment.center
                    : Alignment.centerLeft,
                child: Text(
                  myHeader.title,
                  style: headerStyle,
                ),
              ),
            ),
          ],
        ),
        myHeader.isUnderline
            ? Divider(
                thickness: 2,
                color: headerUnderlineColor,
              )
            : SizedBox(),
      ],
    );
  }

  static Widget dated(Invoice invoice) {
    String dated = Utils.formatDate(invoice.info.date);
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Our Ref: ${invoice.info.billRef.toString().toUpperCase()},"),
          Text("Dated: $dated"),
        ]);
  }

  static Widget builtElevatorType(Invoice invoice) {
    return Row(children: [
      Text("Type: "),
      Text(
        invoice.info.liftType,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          font: pw.Font.timesBold(),
        ),
      ),
      Text("."),
    ]);
  }

  static Widget buildCustomerDetails(Invoice invoice) {
    return Row(children: [
      Expanded(
        flex: 6,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("To,"),
              Text("${invoice.customer.companyName},"),
              Text("${invoice.customer.address.address},"),
              Text("${invoice.customer.address.city}."),
              Text(invoice.customer.number.isNotEmpty
                  ? "${invoice.customer.number}."
                  : ""),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Text("Attention. C/o ${invoice.customer.name},"),
            ]),
      ),
      Expanded(
        flex: 4,
        child: Container(
          width: 70,
          height: 70,
          child: BarcodeWidget(
              data: invoice.info.invoiceNumber,
              barcode: Barcode.fromType(BarcodeType.QrCode)),
        ),
      )
    ]);
  }

  static Widget buildInvoice(Invoice invoice) {
    final headers = [
      'Description',
      'Quantity',
      'Unit Price',
      'Total',
    ];
    final data = invoice.items.map((item) {
      double totalPrice = item.quantity * item.itemPrice;
      return [
        item.description,
        item.quantity.toString(),
        '${Utils.formatPriceForTable(item.itemPrice)}',
        '${Utils.formatPriceForTable(totalPrice)}',
      ];
    }).toList();

    return TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(
        fontWeight: FontWeight.bold,
        font: pw.Font.timesBold(),
      ),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(Invoice invoice) {
    final netTotal = invoice.items
        .map((item) => item.itemPrice * item.quantity)
        .reduce((item1, item2) => item1 + item2);
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Row(
              children: [
                Text(
                  "NOTE.\nPrice quoted without all taxes.\nE & O.E.",
                  style: TextStyle(
                    fontSize: 10,
                    font: pw.Font.timesItalic(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                buildText(
                  title: 'Net total',
                  value: Utils.formatTotalPrice(netTotal),
                  unite: true,
                ),
                Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ??
        TextStyle(
          font: pw.Font.timesBold(),
        );

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }

  static Widget buildTerms(CompanyTerms companyTerms) {
    final terms = companyTerms.termsAndConditions;
    final prices = companyTerms.price;

    final data = <List<String>>[];

    // Iterate over the terms and prices to create rows of data
    for (int i = 0; i < terms.length; i++) {
      final price = prices[i];
      final formattedPrice = (price.isEmpty || price == '0')
          ? ''
          : '${Utils.formatTotalPrice(double.tryParse(price) ?? 0.0)}';

      data.add([
        terms[i],
        formattedPrice,
      ]);
    }

    return TableHelper.fromTextArray(
      // headers: headers,
      data: data,
      border: null,
      // headerStyle: TextStyle(
      //   fontWeight: FontWeight.bold,
      //   font: pw.Font.timesBold(),
      // ),
      // headerDecoration: const BoxDecoration(color: PdfColors.grey100),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
      },
    );
  }

  static Widget signedBy(FooterModel myFooter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Thanks,"),
        SizedBox(height: 1 * PdfPageFormat.cm),
        Text("${myFooter.signedBy}."),
      ],
    );
  }

  static Widget buildFooter(
      FooterModel myFooter, Map<String, PdfColor> footerColors) {
    final PdfColor addressColor = footerColors['addressColor']!;
    final PdfColor contactColor = footerColors['contactColor']!;
    final PdfColor footerUnderlineColor = footerColors['underlineColor']!;

    TextStyle addressStyle = TextStyle(
      color: addressColor,
    );
    TextStyle addressStyleBold = TextStyle(
      color: addressColor,
      fontWeight: FontWeight.bold,
    );
    TextStyle contactStyle = TextStyle(
      color: contactColor,
    );
    TextStyle contactStylebold = TextStyle(
      color: contactColor,
      fontWeight: FontWeight.bold,
    );

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          myFooter.isUnderlined
              ? Divider(
                  color: footerUnderlineColor,
                  thickness: 1,
                )
              : SizedBox(height: 15),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Contact Info:",
                        style: contactStylebold,
                      ),
                      Text(
                        "${myFooter.name} : ${myFooter.number}",
                        style: contactStyle,
                      ),
                    ]),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Address: ",
                      style: addressStyleBold,
                    ),
                    Text(
                      myFooter.street,
                      softWrap: true,
                      maxLines: 3,
                      style: addressStyle,
                    ),
                    Text(
                      "${myFooter.city}, ${myFooter.zipCode}",
                      softWrap: true,
                      maxLines: 1,
                      style: addressStyle,
                    ),
                  ],
                ),
              ]),
        ]);
  }
}
