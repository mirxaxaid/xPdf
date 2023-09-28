import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class InvoiceInstructions extends StatefulWidget {
  const InvoiceInstructions({super.key});

  @override
  State<InvoiceInstructions> createState() => _InvoiceInstructionsState();
}

class _InvoiceInstructionsState extends State<InvoiceInstructions> {
  final String samplePdfPath = "assets/sample_images/sample_pdf.jpg";

  final String headerImagePath = "assets/sample_images/header.png";

  final String referenceImagePath = "assets/sample_images/bill_ref_2.png";

  final String customerDetailsImagePath =
      "assets/sample_images/customer_details.png";

  final String elevatorTypeImagePath = "assets/sample_images/elevator_type.png";

  final String itemsDetailsImagePath = "assets/sample_images/items_details.png";

  final String termsImagePath = "assets/sample_images/terms.png";

  final String footerImagePath = "assets/sample_images/footer.png";

  final TextStyle headingStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    overflow: TextOverflow.ellipsis,
    color: AppColors.settingCardColor,
  );

  final TextStyle bodyStyle = const TextStyle(
    color: AppColors.settingCardColor,
  );

  final TextStyle listTileTextStyle = const TextStyle(
    color: AppColors.settingCardColor,
  );

  final TextStyle listTileTitleTextStyle = const TextStyle(
    color: AppColors.settingCardColor,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Instructions"),
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
      body: ListView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(18.0),
        children: [
          ListTile(
            title: Text("Sample PDF File:", style: listTileTitleTextStyle),
            subtitle: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "This is a sample file that represents"
                        " almost all aspects of the completed PDF.",
                    style: listTileTextStyle,
                  ),
                  const TextSpan(text: '\n'),
                  TextSpan(
                    text:
                        "Next we will understand individual aspects of the Pdf.",
                    style: listTileTextStyle,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: AppColors.settingCardColor,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.asset(
                    samplePdfPath,
                    width: screenWidth,
                    fit: BoxFit.contain,
                    isAntiAlias: true,
                    semanticLabel: "Sample Pdf File.",
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text("Header:", style: listTileTitleTextStyle),
            subtitle: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "This is the Header of the pdf file, "
                        "it is mostly used for Company Letter head info.",
                    style: listTileTextStyle,
                  ),
                  const TextSpan(text: '\n'),
                  TextSpan(
                    text: "You can update this in Settings.",
                    style: listTileTitleTextStyle,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: AppColors.settingCardColor,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.asset(
                    headerImagePath,
                    width: screenWidth,
                    fit: BoxFit.contain,
                    isAntiAlias: true,
                    semanticLabel: "Sample Pdf File.",
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text("Reference:", style: listTileTitleTextStyle),
            subtitle: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'This is the reference for this Invoice.',
                    style: listTileTextStyle,
                  ),
                  const TextSpan(text: '\n'),
                  TextSpan(
                    text: 'You can add this in the Bill Reference Page.',
                    style: listTileTitleTextStyle,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: AppColors.settingCardColor,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.asset(
                    referenceImagePath,
                    width: screenWidth,
                    fit: BoxFit.contain,
                    isAntiAlias: true,
                    semanticLabel: "Sample Pdf File.",
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text("Customer Details:", style: listTileTitleTextStyle),
            subtitle: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'These are Customer Details,\n'
                        '1- Company name of the customer.\n'
                        '2- Address of the Company.\n'
                        '3- City.\n'
                        '4- Name of the Customer.\n'
                        '5- The QR Code contains the Comapany Name, Customer '
                        'Name and Date of the Invoice.',
                    style: listTileTextStyle,
                  ),
                  const TextSpan(text: '\n'),
                  TextSpan(
                    text: 'You can add this in the customer screen Page.',
                    style: listTileTitleTextStyle,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: AppColors.settingCardColor,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.asset(
                    customerDetailsImagePath,
                    width: screenWidth,
                    fit: BoxFit.contain,
                    isAntiAlias: true,
                    semanticLabel: "Sample Pdf File.",
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text("Elevator Type:", style: listTileTitleTextStyle),
            subtitle: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'The type Elevator that the Customer Has.',
                    style: listTileTextStyle,
                  ),
                  const TextSpan(text: '\n'),
                  TextSpan(
                    text: 'You can add this in the customer screen Page.',
                    style: listTileTitleTextStyle,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: AppColors.settingCardColor,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.asset(
                    elevatorTypeImagePath,
                    width: screenWidth,
                    fit: BoxFit.contain,
                    isAntiAlias: true,
                    semanticLabel: "Sample Pdf File.",
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text("item Details:", style: listTileTitleTextStyle),
            subtitle: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'This is the Table that shows the Invoice Items.',
                    style: listTileTextStyle,
                  ),
                  const TextSpan(text: '\n'),
                  TextSpan(
                    text: 'You can add this in the Bill Items Page.',
                    style: listTileTitleTextStyle,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: AppColors.settingCardColor,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.asset(
                    itemsDetailsImagePath,
                    width: screenWidth,
                    fit: BoxFit.contain,
                    isAntiAlias: true,
                    semanticLabel: "Sample Pdf File.",
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text("Terms & Conditions:", style: listTileTitleTextStyle),
            subtitle: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'These are the Terms that will be showed below your '
                        'items table.',
                    style: listTileTextStyle,
                  ),
                  const TextSpan(text: '\n'),
                  TextSpan(
                    text: 'You can add this in the Terms Page on the Top'
                        ' Right Corner of the Settings & Bill Items Screen.',
                    style: listTileTitleTextStyle,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: AppColors.settingCardColor,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.asset(
                    termsImagePath,
                    width: screenWidth,
                    fit: BoxFit.contain,
                    isAntiAlias: true,
                    semanticLabel: "Sample Pdf File.",
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text("Footer:", style: listTileTitleTextStyle),
            subtitle: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "This is the Footer of the Invoice.\n"
                        "It contains Two Contact Information's and "
                        "your company Address.",
                    style: listTileTextStyle,
                  ),
                  const TextSpan(text: '\n'),
                  TextSpan(
                    text: 'You can add this in the Settings Page.',
                    style: listTileTitleTextStyle,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: AppColors.settingCardColor,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.asset(
                    footerImagePath,
                    width: screenWidth,
                    fit: BoxFit.contain,
                    isAntiAlias: true,
                    semanticLabel: "Sample Pdf File.",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
