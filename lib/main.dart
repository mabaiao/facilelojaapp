import 'dart:developer';
import 'dart:io';

import 'package:facilelojaapp/abertura.dart';
import 'package:facilelojaapp/util/device.dart';
import 'package:facilelojaapp/utilparametros.dart';
import 'package:facilelojaapp/utilpost.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:facilelojaapp/utiltema.dart';
import 'package:facilelojaapp/utilusuario.dart';

void main() {
  /// **************************
  /// Previne a mudanca de cor
  /// da sattusBar
  ///

  WidgetsFlutterBinding.ensureInitialized();
  //WidgetsBinding.instance.renderView.automaticSystemUiAdjustment = false;

  if (Platform.isWindows) {
    if (kDebugMode) {
      DesktopWindow.setWindowSize(const Size(1600 * 1.52, 1024 * 1.52));
      DesktopWindow.setMinWindowSize(const Size(1024, 768));
    } else {
      DesktopWindow.setFullScreen(true);
    }
  }

  runApp(const MeuApp());
}

/// **************************
/// Instancias
///

FacileUser gUsuario = FacileUser();
FacileTheme gTema = FacileTheme();
FacilePost gUrlPost = FacilePost();
FacileParams gParametros = FacileParams();
FacileDevice gDevice = FacileDevice();
bool gIsLoad = false;

/// **************************
/// Principal / state
///

class MeuApp extends FacileApp {
  const MeuApp({super.key});
}

class FacileApp extends StatefulWidget {
  const FacileApp({super.key});

  @override
  State<FacileApp> createState() => FacileAppState();
  static FacileAppState? of(BuildContext context) => context.findAncestorStateOfType<FacileAppState>();
}

class FacileAppState extends State<FacileApp> {
  Size? x;

  @override
  void initState() {
    super.initState();

    load();
  }

  void load() async {
    gTema.load(context);
    await gDevice.load(context);
    gUrlPost.load();
    gUsuario.load();

    gIsLoad = true;

    if (!gDevice.isTabletAll) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      log('EM PE');
    }

    setState(() {});
  }

  void rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    x = Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    return OrientationBuilder(builder: (context, orientation) {
      gDevice.update(context);
      return MaterialApp(
        title: 'FacileLoja',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('pt', 'BR')],
        debugShowCheckedModeBanner: false,
        //routes: {},
        themeMode: gTema.themeMode,
        theme: gTema.loadTheme(Brightness.light),
        darkTheme: gTema.loadTheme(Brightness.dark),

        home: (gIsLoad ? const IniciaPage() : null),
      );
    });
  }
}
