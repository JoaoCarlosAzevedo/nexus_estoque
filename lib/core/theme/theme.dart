import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return FlexThemeData.light(
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xff1d2228),
        onPrimary: Color(0xffffffff),
        primaryContainer: Color(0xffb0b2c0),
        onPrimaryContainer: Color(0xff1e1f21),
        secondary: Color(0xfffb8122),
        onSecondary: Color(0xff000000),
        secondaryContainer: Color(0xffffb680),
        onSecondaryContainer: Color(0xff281f17),
        tertiary: Color(0xffea9654),
        onTertiary: Color(0xff000000),
        tertiaryContainer: Color(0xffe9cbab),
        onTertiaryContainer: Color(0xff27221d),
        error: Color(0xffb00020),
        onError: Color(0xffffffff),
        errorContainer: Color(0xfffcd8df),
        onErrorContainer: Color(0xff282526),
        background: Color(0xffededee),
        onBackground: Color(0xff121212),
        surface: Color(0xfff6f6f6),
        onSurface: Color(0xff090909),
        surfaceVariant: Color(0xffededee),
        onSurfaceVariant: Color(0xff121212),
        outline: Color(0xff5f5f5f),
        shadow: Color(0xff000000),
        inverseSurface: Color(0xff111111),
        onInverseSurface: Color(0xfff5f5f5),
        inversePrimary: Color(0xff9ea2a6),
        surfaceTint: Color(0xff1d2228),
      ),
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
