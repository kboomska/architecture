import 'package:flutter/material.dart';

class LocalizationModelStorage {
  String _localeTag = '';
  String get localeTag => _localeTag;

  bool isLocaleUpdated(Locale locale) {
    final localeTag = locale.toLanguageTag();

    if (_localeTag == localeTag) return false;
    _localeTag = localeTag;
    return true;
  }
}
