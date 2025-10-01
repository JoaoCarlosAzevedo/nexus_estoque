import 'package:flutter/material.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData get defaultTheme {
    return ThemeData(
      //useMaterial3: true,
      // Define the default brightness and colors.
      /*   brightness: Brightness.light,
      secondaryHeaderColor: AppColors.primaryGrey,
      primaryColor: AppColors.grey,
      backgroundColor: AppColors.background,
      canvasColor: AppColors.primaryGrey, */
      primaryColor: AppColors.secondaryGrey,
      colorScheme: const ColorScheme(
        primaryContainer: AppColors.primaryGrey,
        brightness: Brightness.light,
        error: AppColors.primaryGrey,
        onError: AppColors.primaryGrey,
        onPrimary: AppColors.primaryGrey,
        onSecondary: AppColors.primaryGrey,
        onSurface: AppColors.primaryGrey,
        primary: AppColors.primaryGrey,
        secondary: AppColors.primaryGrey,
        surface: AppColors.primaryGrey,
        outline: AppColors.primaryGrey,
        inversePrimary: AppColors.primaryGrey,
        background: AppColors.primaryGrey,
        onBackground: AppColors.primaryGrey,
        //hea: AppColors.primaryGrey,
        //primaryColor: AppColors.grey,
        //backgroundColor: AppColors.background,
        //canvasColor: AppColors.primaryGrey,
      ),
      // Define the default font family.
      radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.all(AppColors.grey),
          visualDensity: VisualDensity.standard
          //overlayColor:
          ),
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
        color: AppColors.background,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      primaryTextTheme: customTextTheme(),
      inputDecorationTheme: InputDecorationTheme(
        errorStyle: const TextStyle(color: Colors.red),
        iconColor: AppColors.grey,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(
            width: 2,
            color: AppColors.secondaryGrey,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(
            width: 2,
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
              width: 4, color: AppColors.grey, style: BorderStyle.solid),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(width: 4, color: AppColors.primaryRed),
        ),
        labelStyle: const TextStyle(
            fontSize: 16.0,
            fontFamily: 'Nunito Sans',
            color: AppColors.grey,
            fontWeight: FontWeight.normal),
        floatingLabelStyle: const TextStyle(
            fontSize: 20.0,
            fontFamily: 'Nunito Sans',
            color: AppColors.grey,
            fontWeight: FontWeight.normal),
        fillColor: AppColors.background,
        prefixIconColor: AppColors.grey,
        suffixIconColor: AppColors.grey,
      ),
      expansionTileTheme: ExpansionTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textColor: AppColors.grey,
        iconColor: AppColors.grey,
        //collapsedBackgroundColor: AppColors.grey,
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        collapsedTextColor: AppColors.grey,
        collapsedIconColor: AppColors.grey,
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        //contentPadding: EdgeInsets.all(18),
        textColor: AppColors.grey,
        tileColor: AppColors.background,
        iconColor: AppColors.grey,
        leadingAndTrailingTextStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          //overlayColor: MaterialStateProperty.all(Colors.transparent),
          //iconSize: MaterialStateProperty.resolveWith((states) => 36),
          iconColor:
              MaterialStateProperty.resolveWith((states) => AppColors.grey),
        ),
      ),
      //primaryIconTheme: IconThemeData(color: Colors.red),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: Colors.grey.shade500,
          backgroundColor: AppColors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.grey),
      /*    datePickerTheme: DatePickerThemeData(
        dayBackgroundColor: MaterialStateProperty.all(AppColors.grey),
        dayForegroundColor: MaterialStateProperty.all(AppColors.primaryGrey),
        rangePickerBackgroundColor: Colors.grey.shade700,
        rangePickerHeaderBackgroundColor: AppColors.grey,
        rangeSelectionBackgroundColor: Colors.white,
      ), */
      // Define the default `TextTheme`. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: customTextTheme(),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
          circularTrackColor: AppColors.primaryGrey, color: AppColors.grey),
      tabBarTheme: TabBarTheme(
        dividerColor: AppColors.tertiaryGrey,
        labelColor: AppColors.grey,
        indicatorColor: AppColors.grey,
        unselectedLabelColor: Colors.grey.shade400,
        /*  indicator: BoxDecoration(
          color: Colors.amberAccent,
        ), */
        overlayColor:
            MaterialStateProperty.resolveWith((states) => AppColors.background),
      ),
    );
  }

  static TextTheme customTextTheme() {
    return const TextTheme(
      displayLarge: TextStyle(
          fontSize: 36.0, fontWeight: FontWeight.bold, color: AppColors.grey),
      displayMedium: TextStyle(
          fontSize: 30.0, fontWeight: FontWeight.bold, color: AppColors.grey),
      displaySmall: TextStyle(
          fontSize: 24.0, fontWeight: FontWeight.bold, color: AppColors.grey),
      headlineMedium: TextStyle(
          fontSize: 20.0, fontWeight: FontWeight.bold, color: AppColors.grey),
      headlineSmall: TextStyle(
          fontSize: 18.0, fontWeight: FontWeight.bold, color: AppColors.grey),
      titleLarge: TextStyle(
          fontSize: 16.0, fontWeight: FontWeight.bold, color: AppColors.grey),
      bodyLarge: TextStyle(
          fontSize: 16.0, fontFamily: 'Nunito Sans', color: AppColors.grey),
      bodyMedium: TextStyle(
          fontSize: 14.0,
          fontFamily: 'Nunito Sans',
          color: AppColors.grey,
          fontWeight: FontWeight.bold), //TextPadrao
      titleMedium: TextStyle(
          fontSize: 14.0, fontFamily: 'Nunito Sans', color: AppColors.grey),
      bodySmall: TextStyle(
          fontSize: 12.0,
          fontFamily: 'Nunito Sans',
          color: AppColors.grey,
          fontWeight: FontWeight.bold),
    );
  }
}
