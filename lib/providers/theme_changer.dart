import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  ThemeData _currentTheme;
  bool _isDark = true;

  ThemeChanger(this._currentTheme);

  ThemeData get theme => _currentTheme;

  bool get isDark => _isDark;

  setTheme(ThemeData theme) {
    this._currentTheme = theme;
    notifyListeners();
  }

  toggle() {
    if (this._isDark) {
      this._currentTheme = light;
      this._isDark = false;
    } else {
      this._currentTheme = dark;
      this._isDark = true;
    }
    notifyListeners();
  }

  static final _fontFamily = "Merienda";

  static final _headline = TextStyle(fontWeight: FontWeight.bold, fontSize: 26);
  static final _bodyText = TextStyle(fontSize: 18);

  static final ThemeData dark = new ThemeData(
      backgroundColor: Color.fromRGBO(61, 38, 69, 1),
      primaryColor: Color.fromRGBO(216, 30, 91, 1),
      accentColor: Color.fromRGBO(35, 206, 107, 1),
      fontFamily: _fontFamily,
      textTheme: TextTheme(
          headline1: _headline.copyWith(
            color: Color.fromRGBO(35, 206, 107, 1),
          ),
          bodyText1: _bodyText.copyWith(color: Color.fromRGBO(216, 30, 91, 1)),
          bodyText2:
              _bodyText.copyWith(color: Color.fromRGBO(35, 206, 107, 1))));

  static final ThemeData light = new ThemeData(
      backgroundColor: Color.fromRGBO(240, 239, 244, 1),
      primaryColor: Color.fromRGBO(216, 30, 91, 1),
      accentColor: Color.fromRGBO(9, 48, 52, 1),
      fontFamily: _fontFamily,
      textTheme: TextTheme(
          headline1: _headline.copyWith(color: Color.fromRGBO(9, 48, 52, 1)),
          bodyText1: _bodyText.copyWith(color: Color.fromRGBO(216, 30, 91, 1)),
          bodyText2: _bodyText.copyWith(color: Color.fromRGBO(9, 48, 52, 1))));
}
