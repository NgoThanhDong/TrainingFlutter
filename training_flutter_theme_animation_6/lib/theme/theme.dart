import 'package:flutter/material.dart';
import 'color.dart';

ThemeData buildPostTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: kPostBrown900,
    primaryColor: kPostPink300,
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: kPostPink300,
      textTheme: ButtonTextTheme.normal,
    ),
    scaffoldBackgroundColor: kPostBackgroundWhite,
    textSelectionColor: kPostPink300,
    errorColor: kPostErrorRed,
    textTheme: _buildPostTextTheme(base.textTheme),
    primaryTextTheme: _buildPostTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildPostTextTheme(base.accentTextTheme),
    primaryIconTheme: base.iconTheme.copyWith(
      color: kPostBrown900
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
      labelStyle: TextStyle(fontSize: 18.0),
    ),
  );
}

TextTheme _buildPostTextTheme(TextTheme base) {
  return base.copyWith(
    title: base.title.copyWith(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
    ),
    button: base.button.copyWith(
      fontSize: 18.0,
      fontWeight: FontWeight.w700,
    ),
  ).apply(
    fontFamily: 'Comfortaa',
    displayColor: kPostBrown900,
    bodyColor: kPostBrown900,
  );
}