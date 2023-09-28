import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart' as fm;
import 'package:pdf/pdf.dart' as pdf;
import 'package:shared_preferences/shared_preferences.dart';

class FooterModel {
  String street;
  String city;
  String zipCode;
  String name;
  String number;
  String selectedFont;
  bool isUnderlined;
  fm.Color selectedAddressColor;
  fm.Color selectedContactColor;
  fm.Color underlineColor;
  String signedBy;

  FooterModel({
    this.street = 'Your Company Address / Street',
    this.city = 'City',
    this.zipCode = 'ZipCode',
    this.name = 'Your Name',
    this.number = 'Your Number',
    this.selectedFont = 'Lora',
    this.isUnderlined = false,
    this.selectedAddressColor = fm.Colors.black,
    this.selectedContactColor = fm.Colors.black,
    this.underlineColor = fm.Colors.red,
    this.signedBy = 'Your Name',
  });

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'zipCode': zipCode,
      'name': name,
      'number': number,
      'selectedFont': selectedFont,
      'isUnderlined': isUnderlined,
      'selectedAddressColor': selectedAddressColor.value,
      'selectedContactColor': selectedContactColor.value,
      'underlineColor': underlineColor.value,
      'signedBy': signedBy,
    };
  }

  // Save this FooterModel instance to SharedPreferences
  Future<void> saveToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('footer', jsonEncode(toJson()));
  }

  // Load a FooterModel instance from SharedPreferences
  static Future<FooterModel?> loadFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('footer');
    if (jsonString != null) {
      final jsonData = jsonDecode(jsonString);
      return FooterModel.fromJson(jsonData);
    }
    return null;
  }

  factory FooterModel.fromJson(Map<String, dynamic> json) {
    return FooterModel(
      street: json['street'] ?? 'Your Company Address / Street',
      city: json['city'] ?? 'City',
      zipCode: json['zipCode'] ?? 'ZipCode',
      name: json['name'] ?? 'Your Name',
      number: json['number'] ?? 'Your Number',
      selectedFont: json['selectedFont'] ?? 'Lora',
      isUnderlined: json['isUnderlined'] ?? false,
      selectedAddressColor: fm.Color(json['selectedAddressColor'] ?? fm.Colors.black.value),
      selectedContactColor: fm.Color(json['selectedContactColor'] ?? fm.Colors.black.value),
      underlineColor: fm.Color(json['underlineColor'] ?? fm.Colors.red.value),
      signedBy: json['signedBy'] ?? 'Your Name',
    );
  }

  Future<Map<String, pdf.PdfColor>> pwConversion() async {
    FooterModel? loadedFooter = await FooterModel.loadFromSharedPreferences();
    final myPdfColors = <String, pdf.PdfColor>{};
    if (loadedFooter != null) {
      String selectedAddressColorHex = colorToHex(loadedFooter.selectedAddressColor);
      String selectedContactColorHex = colorToHex(loadedFooter.selectedContactColor);
      String underlineColorHex = colorToHex(loadedFooter.underlineColor);

      pdf.PdfColor pdfAddressColor = pdf.PdfColor.fromHex(selectedAddressColorHex);
      pdf.PdfColor pdfContactColor = pdf.PdfColor.fromHex(selectedContactColorHex);
      pdf.PdfColor pdfUnderlineColor = pdf.PdfColor.fromHex(underlineColorHex);

      myPdfColors['addressColor'] = pdfAddressColor;
      myPdfColors['contactColor'] = pdfContactColor;
      myPdfColors['underlineColor'] = pdfUnderlineColor;
    }
    return myPdfColors;
  }

  String colorToHex(fm.Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }
}
