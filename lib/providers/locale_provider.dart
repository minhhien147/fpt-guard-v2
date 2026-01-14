import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('vi'); // Default: Vietnamese
  
  Locale get locale => _locale;
  
  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('vi'), // Vietnamese
    Locale('en'), // English
    Locale('ja'), // Japanese
  ];
  
  // Load saved locale
  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'vi';
    _locale = Locale(languageCode);
    notifyListeners();
  }
  
  // Set locale
  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.contains(locale)) return;
    
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    notifyListeners();
  }
  
  // Get language name
  String getLanguageName(String code) {
    switch (code) {
      case 'vi':
        return 'Tiếng Việt';
      case 'en':
        return 'English';
      case 'ja':
        return '日本語';
      default:
        return 'Tiếng Việt';
    }
  }
}
