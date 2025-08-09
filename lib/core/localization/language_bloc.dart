import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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
  LanguageBloc() : super(LanguageInitial()) {
    on<ChangeLanguage>(_onChangeLanguage);

    // Initialize with English as default
    add(const ChangeLanguage('en'));
  }

  void _onChangeLanguage(ChangeLanguage event, Emitter<LanguageState> emit) {
    final locale = Locale(event.languageCode);
    final textDirection = event.languageCode == 'ar'
        ? TextDirection.rtl
        : TextDirection.ltr;

    emit(
      LanguageLoaded(
        languageCode: event.languageCode,
        locale: locale,
        textDirection: textDirection,
      ),
    );
  }
}
