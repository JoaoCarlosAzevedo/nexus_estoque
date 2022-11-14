import 'package:flutter/material.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData get defaultTheme {
    return ThemeData(
      // Define the default brightness and colors.
      /*   brightness: Brightness.light,
      secondaryHeaderColor: AppColors.primaryGrey,
      primaryColor: AppColors.grey,
      backgroundColor: AppColors.background,
      canvasColor: AppColors.primaryGrey, */
      primaryColor: AppColors.secondaryGrey,
      colorScheme: const ColorScheme(
        primaryContainer: AppColors.primaryGrey,
        background: AppColors.primaryGrey,
        brightness: Brightness.light,
        error: AppColors.primaryGrey,
        onBackground: AppColors.primaryGrey,
        onError: AppColors.primaryGrey,
        onPrimary: AppColors.primaryGrey,
        onSecondary: AppColors.primaryGrey,
        onSurface: AppColors.primaryGrey,
        primary: AppColors.primaryGrey,
        secondary: AppColors.primaryGrey,
        surface: AppColors.primaryGrey,
        outline: AppColors.primaryGrey,
        inversePrimary: AppColors.primaryGrey,

        //hea: AppColors.primaryGrey,
        //primaryColor: AppColors.grey,
        //backgroundColor: AppColors.background,
        //canvasColor: AppColors.primaryGrey,
      ),
      // Define the default font family.
      fontFamily: 'Nunito Sans',
      scaffoldBackgroundColor: AppColors.primaryGrey,
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: AppColors.grey,
        ),
        centerTitle: true,
        color: AppColors.primaryGrey,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.grey),
      ),
      cardColor: AppColors.background,
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      primaryTextTheme: customTextTheme(),
      inputDecorationTheme: InputDecorationTheme(
        iconColor: AppColors.grey,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(
            width: 0,
            color: AppColors.background,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(
            width: 0,
            color: AppColors.background,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(
            width: 0,
            color: AppColors.background,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(width: 2, color: AppColors.primaryRed),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(
              width: 2, color: AppColors.grey, style: BorderStyle.solid),
        ),
        labelStyle: const TextStyle(
            fontSize: 16.0,
            fontFamily: 'Nunito Sans',
            color: AppColors.grey,
            fontWeight: FontWeight.normal),
        fillColor: AppColors.background,
        prefixIconColor: AppColors.grey,
        suffixIconColor: AppColors.grey,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      )),
      iconTheme: const IconThemeData(color: AppColors.grey),
      // Define the default `TextTheme`. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: customTextTheme(),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
          circularTrackColor: AppColors.primaryGrey, color: AppColors.grey),
    );
  }

  static TextTheme customTextTheme() {
    return const TextTheme(
      headline1: TextStyle(
          fontSize: 36.0, fontWeight: FontWeight.bold, color: AppColors.grey),
      headline2: TextStyle(
          fontSize: 30.0, fontWeight: FontWeight.bold, color: AppColors.grey),
      headline3: TextStyle(
          fontSize: 24.0, fontWeight: FontWeight.bold, color: AppColors.grey),
      headline4: TextStyle(
          fontSize: 20.0, fontWeight: FontWeight.bold, color: AppColors.grey),
      headline5: TextStyle(
          fontSize: 18.0, fontWeight: FontWeight.bold, color: AppColors.grey),
      headline6: TextStyle(
          fontSize: 16.0, fontWeight: FontWeight.bold, color: AppColors.grey),
      bodyText1: TextStyle(
          fontSize: 16.0, fontFamily: 'Nunito Sans', color: AppColors.grey),
      bodyText2: TextStyle(
          fontSize: 14.0,
          fontFamily: 'Nunito Sans',
          color: AppColors.grey,
          fontWeight: FontWeight.bold), //TextPadrao
      subtitle1: TextStyle(
          fontSize: 14.0, fontFamily: 'Nunito Sans', color: AppColors.grey),
      caption: TextStyle(
          fontSize: 12.0,
          fontFamily: 'Nunito Sans',
          color: AppColors.grey,
          fontWeight: FontWeight.bold),
    );
  }
}
