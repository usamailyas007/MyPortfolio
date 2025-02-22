import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:portfolio/theme.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'landing_page.dart';

void main() async{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MaterialColor colorCustom = const MaterialColor(0xFF7600BC, {
      50: Color.fromRGBO(118, 0, 188, 0.1),
      100: Color.fromRGBO(118, 0, 188, 0.2),
      200: Color.fromRGBO(118, 0, 188, 0.3),
      300: Color.fromRGBO(118, 0, 188, 0.4),
      400: Color.fromRGBO(118, 0, 188, 0.5),
      500: Color.fromRGBO(118, 0, 188, 0.6),
      600: Color.fromRGBO(118, 0, 188, 0.7),
      700: Color.fromRGBO(118, 0, 188, 0.8),
      800: Color.fromRGBO(118, 0, 188, 0.9),
      900: Color.fromRGBO(118, 0, 188, 1.0),
    });

    return MaterialApp(
      builder: (context, child) => ResponsiveBreakpoints.builder(
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 920, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
        child: child!,
      ),
      debugShowCheckedModeBanner: false,
      title: 'Portfolio',
      theme: ThemeData(
        useMaterial3: false,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundDarkColor,
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: backgroundDarkColor,
          iconTheme: IconThemeData(color: lightColor),
          titleTextStyle: TextStyle(
            color: lightColor,
          ),
        ),
        dividerColor: dividerColor,
        dividerTheme: DividerThemeData(color: dividerColor),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: hintColor, fontSize: 12),
          contentPadding: EdgeInsets.symmetric(
            vertical: 18,
            horizontal: mainP,
          ),
          fillColor: backgroundColor,
          filled: true,
          iconColor: greyLightColor,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: greyLightColor),
            borderRadius: BorderRadius.circular(mainP),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: greyLightColor),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: primaryColor),
          ),
        ),
        textTheme: TextTheme(
          titleMedium: TextStyle(color: darkColor, fontSize: 14),
          bodyLarge: TextStyle(color: darkColor, fontSize: 14),
          bodyMedium: TextStyle(color: darkColor, fontSize: 14),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: colorCustom).copyWith(secondary: primaryColor),
      ),
      home: const LandingPage(),
    );
  }
}

