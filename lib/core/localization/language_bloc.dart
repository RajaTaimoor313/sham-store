import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object> get props => [];
}

class ChangeLanguage extends LanguageEvent {
  final String languageCode;

  const ChangeLanguage(this.languageCode);

  @override
  List<Object> get props => [languageCode];
}

// States
abstract class LanguageState extends Equatable {
  const LanguageState();

  @override
  List<Object> get props => [];
}

class LanguageInitial extends LanguageState {}

class LanguageLoaded extends LanguageState {
  final String languageCode;
  final Locale locale;
  final TextDirection textDirection;

  const LanguageLoaded({
    required this.languageCode,
    required this.locale,
    required this.textDirection,
  });

  @override
  List<Object> get props => [languageCode, locale, textDirection];
}

// BLoC
class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc({String? initialLanguageCode}) : super(LanguageInitial()) {
    on<ChangeLanguage>(_onChangeLanguage);

    if (initialLanguageCode != null) {
      // ignore: avoid_print
      print(
        '[LanguageBloc] Starting with provided language: $initialLanguageCode',
      );
      add(ChangeLanguage(initialLanguageCode));
    } else {
      _loadSavedLanguage();
    }
  }

  void _onChangeLanguage(ChangeLanguage event, Emitter<LanguageState> emit) {
    final locale = Locale(event.languageCode);
    final textDirection = event.languageCode == 'ar'
        ? TextDirection.rtl
        : TextDirection.ltr;

    // Debug
    // ignore: avoid_print
    print('[LanguageBloc] Changing language to: ${event.languageCode}');

    emit(
      LanguageLoaded(
        languageCode: event.languageCode,
        locale: locale,
        textDirection: textDirection,
      ),
    );
    // ignore: avoid_print
    print('[LanguageBloc] Language changed. Direction: $textDirection');

    _persistLanguageCode(event.languageCode);
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCode = prefs.getString('languageCode') ?? 'en';
      // ignore: avoid_print
      print('[LanguageBloc] Loaded saved language: $savedCode');
      add(ChangeLanguage(savedCode));
    } catch (e) {
      // ignore: avoid_print
      print('[LanguageBloc] Failed to load saved language: $e');
      add(const ChangeLanguage('en'));
    }
  }

  Future<void> _persistLanguageCode(String code) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('languageCode', code);
      // ignore: avoid_print
      print('[LanguageBloc] Persisted language: $code');
    } catch (e) {
      // ignore: avoid_print
      print('[LanguageBloc] Failed to persist language: $e');
    }
  }
}
