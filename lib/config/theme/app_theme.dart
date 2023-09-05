import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();
  static getApplicationTheme() {
    return ThemeData(
      colorScheme: const ColorScheme.light(),
      scaffoldBackgroundColor: Colors.black,
      fontFamily: 'Comfortaa',
      useMaterial3: true,

      //////////////////////////////////For AppBar//////////////////////////////////
      appBarTheme: const AppBarTheme(
        elevation: 0,
        // backgroundColor: AppColorConstant.appBarColor,
        // foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

    );
  }
}
