import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart' as fm;
import 'package:pdf/pdf.dart' as pdf;
import 'package:shared_preferences/shared_preferences.dart';

class HeaderModel {
  String title;
  String font;
  bool isUnderline;
  Color titleColor;
  Color underlineColor;
  File? imageFile;

  HeaderModel({
    this.title = 'Company Name',
    this.font = 'Lora',
    this.isUnderline = false,
    this.titleColor = fm.Colors.black,
    this.underlineColor = fm.Colors.red,
    this.imageFile,
  });

  factory HeaderModel.fromJson(Map<String, dynamic> json) {
    return HeaderModel(
      title: json['title'] ?? 'Company Name',
      font: json['font'] ?? 'Lora',
      isUnderline: json['isUnderline'] ?? false,
      titleColor: Color(json['titleColor'] ?? fm.Colors.black.value),
      underlineColor: Color(json['underlineColor'] ?? fm.Colors.red.value),
      imageFile:
      json['imageFilePath'] != null ? File(json['imageFilePath']) : null,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'font': font,
      'isUnderline': isUnderline,
      'titleColor': titleColor.value,
      'underlineColor': underlineColor.value,
      'imageFilePath': imageFile?.path,
    };
  }

  // Save this Header instance to SharedPreferences
  Future<void> saveToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('header', jsonEncode(toJson()));
  }

  // Load a Header instance from SharedPreferences
  static Future<HeaderModel?> loadFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('header');
    if (jsonString != null) {
      final jsonData = jsonDecode(jsonString);
      return HeaderModel.fromJson(jsonData);
    }
    return null;
  }

  Future<Map<String, pdf.PdfColor>> pwConversion() async {
    HeaderModel? loadedHeader = await HeaderModel.loadFromSharedPreferences();
    final myPdfColors = <String, pdf.PdfColor>{};
    if (loadedHeader != null) {
      String titleColorHex = colorToHex(loadedHeader.titleColor);
      String underlineColorHex = colorToHex(loadedHeader.underlineColor);
      pdf.PdfColor pdfTitleColor = pdf.PdfColor.fromHex(titleColorHex);
      pdf.PdfColor pdfUnderlineColor = pdf.PdfColor.fromHex(underlineColorHex);

      myPdfColors['titleColor'] = pdfTitleColor;
      myPdfColors['underlineColor'] = pdfUnderlineColor;
    }
    return myPdfColors;
  }

  String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }
}
