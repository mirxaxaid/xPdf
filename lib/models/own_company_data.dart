import 'package:shared_preferences/shared_preferences.dart';

// class OwnCompanyData {
//   String companyName;
//   String address;
//   String contactNameOne;
//   String contactNumberOne;
//   String contactNameTwo;
//   String contactNumberTwo;
//   String signedBy;
//
//   OwnCompanyData({
//     this.companyName = 'Your Company Name',
//     this.address = 'Your Company Address',
//     this.contactNameOne = 'Contact Name One',
//     this.contactNumberOne = '0321-1231231',
//     this.contactNameTwo = 'Contact Name Two',
//     this.contactNumberTwo = '0312-3213211',
//     this.signedBy = 'Your Name',
//   });
//
//   factory OwnCompanyData.fromJson(Map<String, dynamic> json) {
//     return OwnCompanyData(
//       companyName: json['companyName'] ?? 'Your Company Name',
//       address: json['address'] ?? 'Your Company Address',
//       contactNameOne: json['contactNameOne'] ?? 'Contact Name One',
//       contactNumberOne: json['contactNumberOne'] ?? '0321-1231231',
//       contactNameTwo: json['contactNameTwo'] ?? 'Contact Name Two',
//       contactNumberTwo: json['contactNumberTwo'] ?? '0312-3213211',
//       signedBy: json['signedBy'] ?? 'Your Name',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'companyName': companyName,
//       'address': address,
//       'contactNameOne': contactNameOne,
//       'contactNumberOne': contactNumberOne,
//       'contactNameTwo': contactNameTwo,
//       'contactNumberTwo': contactNumberTwo,
//       'signedBy': signedBy,
//     };
//   }
// }

class CompanyTerms {
  List<String> termsAndConditions;
  List<String> price;

  CompanyTerms({this.termsAndConditions = const [], this.price = const []});

  // Add a method to add a new term or condition
  void addTerm(String term, String pPrice) {
    termsAndConditions.add(term);
    price.add(pPrice);
    _saveToSharedPreferences(); // Save to SharedPreferences after adding
    print("terms added: $termsAndConditions, price added: $price.");
  }

  // Add a method to remove a term or condition
  void removeTerm(String term) {
    termsAndConditions.remove(term);
    price.removeAt(termsAndConditions.indexWhere((term) => true));
    print("terms removed: $termsAndConditions, price removed: $price.");
    _saveToSharedPreferences(); // Save to SharedPreferences after removing
  }

  // Add a method to clear all terms and conditions
  void clearTerms() {
    termsAndConditions.clear();
    price.clear();
    print("terms clear: $termsAndConditions, price: $price.");
    _saveToSharedPreferences(); // Save to SharedPreferences after clearing
  }

  // Save terms and conditions to SharedPreferences
  Future<void> _saveToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('company_terms', termsAndConditions);
    await prefs.setStringList('price', price);
    print("saving terms: $termsAndConditions, price: $price.");
  }

  // Load terms and conditions from SharedPreferences
  Future<void> loadFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    termsAndConditions = prefs.getStringList('company_terms') ?? [];
    price = prefs.getStringList('price') ?? [];
    print("terms loaded: $termsAndConditions, price loaded: $price");
  }

  void deleteTerm(int index) {
    if (index >= 0 && index < termsAndConditions.length) {
      termsAndConditions.removeAt(index);
      price.removeAt(termsAndConditions.indexWhere((term) => true));
      _saveToSharedPreferences(); // Save the updated list to preferences
    }
  }
}
