import 'customer.dart';

class Invoice {
  final InvoiceInfo info;
  final Customer customer;
  final List<InvoiceItem> items;

  const Invoice({
    required this.info,
    required this.customer,
    required this.items,
  });
}

class InvoiceInfo {
  String invoiceDescription;
  String invoiceNumber;
  String liftType;
  String billRef;
  DateTime date;

  InvoiceInfo({
    this.invoiceDescription = "Invoice Description",
    this.invoiceNumber = "Invoice Number",
    this.liftType = "Lift Type",
    this.billRef = "Invoice Reference",
    DateTime? date,
  }) : date = date ?? DateTime(1999, 1, 1);
}

class InvoiceItem {
  final String description;
  final int quantity;
  final double itemPrice;

  const InvoiceItem({
    this.description = "Item Description",
    this.quantity = 0,
    this.itemPrice = 0.0,
  });
}
