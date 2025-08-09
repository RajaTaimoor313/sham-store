import 'package:flutter/material.dart';

class TextUtils {
  /// Checks if the given text contains Arabic characters
  static bool containsArabic(String text) {
    if (text.isEmpty) return false;
    
    // Arabic Unicode range: U+0600 to U+06FF
    // Arabic Supplement: U+0750 to U+077F
    // Arabic Extended-A: U+08A0 to U+08FF
    final arabicRegex = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]');
    return arabicRegex.hasMatch(text);
  }
  
  /// Checks if the given text is primarily Arabic
  static bool isPrimarilyArabic(String text) {
    if (text.isEmpty) return false;
    
    final arabicRegex = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]');
    final arabicMatches = arabicRegex.allMatches(text).length;
    final totalChars = text.replaceAll(RegExp(r'\s'), '').length; // Exclude spaces
    
    if (totalChars == 0) return false;
    
    // Consider text primarily Arabic if more than 50% of characters are Arabic
    return (arabicMatches / totalChars) > 0.5;
  }
  
  /// Gets the appropriate text direction for the given text
  static TextDirection getTextDirection(String text) {
    return containsArabic(text) ? TextDirection.rtl : TextDirection.ltr;
  }
}