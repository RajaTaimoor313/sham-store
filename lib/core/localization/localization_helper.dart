import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_localizations.dart';
import 'language_bloc.dart';

class LocalizationHelper {
  static String translate(BuildContext context, String key) {
    final languageState = context.read<LanguageBloc>().state;
    if (languageState is LanguageLoaded) {
      return AppLocalizations.translate(key, languageState.languageCode);
    }
    return AppLocalizations.translate(key, 'en'); // Default to English
  }

  static String getCurrentLanguage(BuildContext context) {
    final languageState = context.read<LanguageBloc>().state;
    if (languageState is LanguageLoaded) {
      return languageState.languageCode;
    }
    return 'en'; // Default to English
  }

  static TextDirection getTextDirection(BuildContext context) {
    final languageState = context.read<LanguageBloc>().state;
    if (languageState is LanguageLoaded) {
      return languageState.textDirection;
    }
    return TextDirection.ltr; // Default to LTR
  }
}

// Extension for easier access
extension LocalizationExtension on BuildContext {
  String tr(String key) => LocalizationHelper.translate(this, key);
  String get currentLanguage => LocalizationHelper.getCurrentLanguage(this);
  TextDirection get textDirection => LocalizationHelper.getTextDirection(this);
}
