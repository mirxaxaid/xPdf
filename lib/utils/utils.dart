import 'package:intl/intl.dart';

class Utils {
  // static formatPrice(double price) => '${price.toStringAsFixed(0)}/-';
  static formatPriceForTable(double price) {
    String formattedPrice = "${NumberFormat.currency(name: '', decimalDigits: 0).format(price)}/-";
    return formattedPrice;
  }
  static formatTotalPrice(double price) {
    String formattedPrice = "${NumberFormat.currency(name: 'PKR ',decimalDigits: 0).format(price)}/-";
    return formattedPrice;
  }
  // static formatDate(DateTime date) => DateFormat.yMd().format(date);
  static formatDate(DateTime date) => DateFormat('dd/MM/yyyy').format(date);
  static formatDateForFileName(DateTime date) => DateFormat('yyyy_MM_dd').format(date);
}
