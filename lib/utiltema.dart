import 'dart:async';
import 'dart:developer';

import 'package:facilelojaapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// **************************
/// Controle de tema e cores
///

class FacileTheme {
  Color defaultColorLight = Colors.white;
  Color defaultColorDark = const Color.fromARGB(255, 2, 2, 1);

  List<Color> colorArray = [
    Colors.blue,
    Colors.deepOrange,
    Colors.greenAccent,
    Colors.cyan,
    Colors.pink,
    Colors.deepPurple,
    Colors.lime,
    Colors.purpleAccent,
    Colors.teal,
    Colors.indigo,
    Colors.brown,
    Colors.yellow,
  ];

  ThemeMode themeMode = ThemeMode.light;
  bool isLight = false;
  bool isDark = false;
  String modo = 'light';
  int cor = 0;

  Future<void> load(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    modo = prefs.getString('facile_tema_modo') ?? 'light';
    cor = prefs.getInt('facile_tema_cor') ?? 0;
    if (cor >= colorArray.length) {
      cor = 0;
    }
    themeMode = (modo == 'light' ? ThemeMode.light : ThemeMode.dark);
    updateTheme(context);
  }

  Future<void> update(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('facile_tema_modo', modo);
    prefs.setInt('facile_tema_cor', cor);

    updateTheme(context);
  }

  void print() {
    log('TEMA::modo::$modo');
    log('TEMA::cor::$cor');
    log('TEMA::isLight::$isLight');
    log('TEMA::color::${colorArray[gTema.cor].toString()}');
  }

  void changeColor(context) async {
    cor++;

    if (cor >= colorArray.length) {
      cor = 0;
    }
    update(context);
  }

  void changeTheme(context) {
    if (modo == 'dark') {
      themeMode = ThemeMode.light;
      modo = 'light';
    } else {
      themeMode = ThemeMode.dark;
      modo = 'dark';
    }
    update(context);
  }

  void updateTheme(context) {
    if (modo == 'light') {
      isLight = true;
      isDark = false;
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: defaultColorLight,
        systemNavigationBarColor: defaultColorLight,
      ));
    } else {
      isLight = false;
      isDark = true;
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: defaultColorDark,
        systemNavigationBarColor: defaultColorDark,
      ));
    }
    print();
    FacileApp.of(context)?.rebuild();
  }

  ThemeData loadTheme(Brightness brightness) {
    Color corDef = colorArray[cor];

    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      useMaterial3: true,
      brightness: brightness,
      colorSchemeSeed: corDef,
      scaffoldBackgroundColor: brightness == Brightness.dark ? defaultColorDark : defaultColorLight,
      appBarTheme: AppBarTheme(
        titleTextStyle: GoogleFonts.ubuntuCondensed(
          color: corDef,
          fontWeight: FontWeight.bold,
        ),
      ),
      focusColor: corDef.withOpacity(0.2),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(gDevice.isWindows ? 25 : (gDevice.isTabletLandscape ? 13 : (gDevice.isPhoneSmall ? 14 : 20))),
          elevation: gDevice.isWindows || gDevice.isTabletAll ? 8 : 4,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: GoogleFonts.ubuntuCondensed(
          color: Colors.grey.withOpacity(0.4),
        ),
        floatingLabelStyle: GoogleFonts.ubuntuCondensed(
          color: Colors.grey,
          fontWeight: FontWeight.w800,
        ),
        prefixStyle: GoogleFonts.ubuntuCondensed(
          color: Colors.grey.withOpacity(0.8),
          fontWeight: FontWeight.w600,
        ),
        helperStyle: GoogleFonts.ubuntuCondensed(
          color: Colors.grey.withOpacity(0.8),
          fontWeight: FontWeight.w600,
        ),
        errorStyle: GoogleFonts.ubuntuCondensed(
          fontWeight: FontWeight.w600,
        ),
        suffixStyle: GoogleFonts.ubuntuCondensed(
          color: Colors.grey.withOpacity(0.8),
          fontWeight: FontWeight.w600,
        ),
        hintStyle: GoogleFonts.ubuntuCondensed(
          color: Colors.grey.withOpacity(0.8),
          fontWeight: FontWeight.w600,
        ),
        contentPadding: EdgeInsets.all(
          gDevice.isWindows || gDevice.isTabletAll ? 15 : 5,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.4),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return corDef;
          }
          return null;
        }),
      ),
      listTileTheme: const ListTileThemeData(),
      textTheme: TextTheme(
        labelLarge: GoogleFonts.ubuntuCondensed(
          fontSize: 16 + (gDevice.isWindows || gDevice.isTabletAll ? 4 : 0),
          fontWeight: FontWeight.bold,
        ),

        /// Input text
        bodyLarge: GoogleFonts.ubuntuCondensed(
          fontSize: 18 + (gDevice.isWindows || gDevice.isTabletAll ? 4 : 0),
          fontWeight: FontWeight.w800,
        ),

        /// ListTile title
        titleLarge: GoogleFonts.ubuntuCondensed(
          fontSize: 24 + (gDevice.isWindows || gDevice.isTabletAll ? 4 : 0),
          fontWeight: FontWeight.w700,
        ),
        titleMedium: GoogleFonts.ubuntuCondensed(
          fontSize: 16 + (gDevice.isWindows || gDevice.isTabletAll ? 4 : 0),
          fontWeight: FontWeight.w600,
        ),
        titleSmall: GoogleFonts.ubuntuCondensed(
          fontSize: 12 + (gDevice.isWindows || gDevice.isTabletAll ? 4 : 0),
          fontWeight: FontWeight.w600,
        ),

        displayLarge: GoogleFonts.ubuntuCondensed(
          fontSize: 24 + (gDevice.isWindows || gDevice.isTabletAll ? 4 : 0),
          fontWeight: FontWeight.w700,
        ),
        displayMedium: GoogleFonts.ubuntuCondensed(
          fontSize: 20 + (gDevice.isWindows || gDevice.isTabletAll ? 4 : 0),
          fontWeight: FontWeight.w600,
        ),
        displaySmall: GoogleFonts.ubuntuCondensed(
          fontSize: 16 + (gDevice.isWindows || gDevice.isTabletAll ? 4 : 0),
          fontWeight: FontWeight.w600,
        ),

        headlineLarge: GoogleFonts.archivoBlack(
          fontSize: (gDevice.isPhoneSmall ? 20 : 30) + (gDevice.isWindows || gDevice.isTabletAll ? 4 : 0),
          fontWeight: FontWeight.w900,
        ),
        headlineMedium: GoogleFonts.archivoBlack(
          fontSize: 20 + (gDevice.isWindows || gDevice.isTabletAll ? 4 : 0),
          fontWeight: FontWeight.w400,
        ),
        headlineSmall: GoogleFonts.ubuntuCondensed(
          fontSize: 16 + (gDevice.isWindows || gDevice.isTabletAll ? 4 : 0),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  ///
  /// TEXTOS
  ///
  ///
  ///
  ///

  static Widget headlineLarge(
    context,
    String title, {
    bool invert = false,
    disable = false,
    align = TextAlign.center,
    double fontSize = 0,
  }) {
    return Text(
      title,
      textAlign: align,
      style: GoogleFonts.anton(
        fontWeight: Theme.of(context).textTheme.headlineLarge?.fontWeight,
        fontSize: fontSize == 0 ? Theme.of(context).textTheme.headlineLarge?.fontSize : fontSize,
        color: invert
            ? Colors.white
            : disable
                ? Colors.grey
                : Theme.of(context).textTheme.headlineLarge!.color!.withOpacity(1),
      ),
    );
  }

  static Widget headlineMedium(
    context,
    String title, {
    bool invert = false,
    disable = false,
    align = TextAlign.center,
    fontSize = 0,
  }) {
    return Text(
      title,
      textAlign: align,
      style: GoogleFonts.anton(
        fontWeight: Theme.of(context).textTheme.headlineMedium?.fontWeight,
        fontSize: fontSize == 0 ? Theme.of(context).textTheme.headlineMedium?.fontSize : fontSize,
        color: invert
            ? Colors.white
            : disable
                ? Colors.grey
                : Theme.of(context).textTheme.headlineLarge!.color!.withOpacity(1),
      ),
    );
  }

  static Widget headlineSmall(
    context,
    String title, {
    bool invert = false,
    disable = false,
    bold = false,
    align = TextAlign.center,
    fontSize = 0,
  }) {
    return Text(
      title,
      textAlign: align,
      style: GoogleFonts.anton(
        fontWeight: bold ? FontWeight.bold : Theme.of(context).textTheme.headlineSmall?.fontWeight,
        fontSize: fontSize == 0 ? Theme.of(context).textTheme.headlineSmall?.fontSize : fontSize,
        color: invert
            ? Colors.white
            : disable
                ? Colors.grey
                : Theme.of(context).textTheme.headlineSmall?.color!.withOpacity(1),
      ),
    );
  }

  static Widget displaySmall(
    context,
    String title, {
    bool invert = false,
    disable = false,
    bold = false,
    align = TextAlign.center,
    fontSize = 0,
  }) {
    return Text(
      title,
      textAlign: align,
      style: GoogleFonts.ubuntuCondensed(
        fontWeight: bold ? FontWeight.bold : Theme.of(context).textTheme.displaySmall?.fontWeight,
        fontSize: fontSize == 0 ? Theme.of(context).textTheme.displaySmall?.fontSize : fontSize,
        color: invert
            ? Colors.white
            : disable
                ? Colors.grey
                : Theme.of(context).textTheme.displaySmall?.color!.withOpacity(1),
      ),
    );
  }

  static Widget displayMedium(
    context,
    String title, {
    bool invert = false,
    disable = false,
    bold = false,
    align = TextAlign.center,
    fontSize = 0,
  }) {
    return Text(
      title,
      textAlign: align,
      style: GoogleFonts.ubuntuCondensed(
        fontWeight: bold ? FontWeight.bold : Theme.of(context).textTheme.displayMedium?.fontWeight,
        fontSize: fontSize == 0 ? Theme.of(context).textTheme.displayMedium?.fontSize : fontSize,
        color: invert
            ? Colors.white
            : disable
                ? Colors.grey
                : Theme.of(context).textTheme.displayMedium?.color!.withOpacity(1),
      ),
    );
  }

  static Widget displayLarge(
    context,
    String title, {
    bool invert = false,
    disable = false,
    bold = false,
    align = TextAlign.center,
    fontSize = 0,
  }) {
    return Text(
      title,
      textAlign: align,
      style: GoogleFonts.ubuntuCondensed(
        fontWeight: bold ? FontWeight.bold : Theme.of(context).textTheme.displayLarge?.fontWeight,
        fontSize: fontSize == 0 ? Theme.of(context).textTheme.displayLarge?.fontSize : fontSize,
        color: invert
            ? Colors.white
            : disable
                ? Colors.grey
                : Theme.of(context).textTheme.displayLarge?.color!.withOpacity(1),
      ),
    );
  }

  static Color getColorPrimary(context) {
    return (gTema.modo == 'dark' ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary);
  }

  static Color getColorButton(context) {
    return Theme.of(context).colorScheme.inversePrimary;
  }

  static Color getColorHard(context) {
    return (gTema.modo == 'dark' ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.primary);
  }

  static Color getShadowColor(context) {
    return (gTema.modo == 'dark' ? gTema.defaultColorDark : Colors.grey);
  }
}
