import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return FlexThemeData.light(
      scheme: FlexScheme.shark,
      surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
      blendLevel: 20,
      appBarStyle: FlexAppBarStyle.primary,
      appBarOpacity: 0.95,
      tabBarStyle: FlexTabBarStyle.forBackground,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 20,
        blendOnColors: false,
        thinBorderWidth: 1.5,
        toggleButtonsRadius: 6.0,
        cardRadius: 20.0,
        popupMenuRadius: 2.0,
        bottomNavigationBarOpacity: 0.57,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      // To use the playground font, add GoogleFonts package and uncomment
      // fontFamily: GoogleFonts.notoSans().fontFamily,
    );
  }

  static ThemeData get darkTheme {
    return FlexThemeData.dark(
      scheme: FlexScheme.shark,
      surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
      blendLevel: 15,
      appBarOpacity: 0.90,
      tabBarStyle: FlexTabBarStyle.forBackground,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 30,
        thinBorderWidth: 1.5,
        toggleButtonsRadius: 6.0,
        cardRadius: 20.0,
        popupMenuRadius: 2.0,
        bottomNavigationBarOpacity: 0.57,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      // To use the playground font, add GoogleFonts package and uncomment
      // fontFamily: GoogleFonts.notoSans().fontFamily,
    );
  }
}
