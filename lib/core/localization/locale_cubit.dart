import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/storage/preferences_storage.dart';
import 'package:injectable/injectable.dart';

@injectable
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(this._preferencesStorage) : super(const Locale('en'));

  final PreferencesStorage _preferencesStorage;

  static const supportedLocales = [
    Locale('en'),
    Locale('ur'),
  ];

  Future<void> load() async {
    final saved = _preferencesStorage.getLocale();
    if (saved != null) {
      emit(Locale(saved));
    }
  }

  Future<void> setLocale(Locale locale) async {
    await _preferencesStorage.setLocale(locale.languageCode);
    emit(locale);
  }
}
