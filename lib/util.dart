import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:crypto/crypto.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:facilelojaapp/utiltema.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:share/share.dart';
import 'main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart' as syspaths;

///
/// PLATAFORMA
///
///
///
///

///
/// CORES / ESPACAMENTOS / GEOMETRIAS
///
///
///
///

String getTextWindowsKey(caption, key) {
  return (gDevice.isWindows ? key + ' ' + caption : caption);
}

double getMaxSizedBoxWidth(context) {
  return MediaQuery.of(context).size.width * (gDevice.isWindows || gDevice.isTabletLandscape ? 0.45 : 0.9);
}

double getMaxSizedBoxHeight(context) {
  return MediaQuery.of(context).size.height * (gDevice.isWindows ? 0.9 : 0.9);
}

double getMaxSizedBoxLottieHeight(context) {
  double v = MediaQuery.of(context).size.height *
      (gDevice.isWindows || gDevice.isTabletLandscape
          ? 0.6
          : gDevice.isPhoneSmall
              ? 0.25
              : 0.30);

  if (gDevice.isTabletPortrait) {
    v = MediaQuery.of(context).size.height * 0.3;
  }
  return v;
}

double getMaxSizedImagemProfile(context) {
  double v = (gDevice.isPhoneSmall ? 20 : 40);

  if (gDevice.isPhone) {
    v = 30;
  }
  return v;
}

Widget getEspacadorVertical() {
  return SizedBox(width: gDevice.isWindows || gDevice.isTabletAll ? 12 : 6);
}

Widget getEspacador() {
  return SizedBox(height: gDevice.isWindows || gDevice.isTabletAll ? 12 : 6);
}

Widget getEspacadorDuplo() {
  return SizedBox(height: gDevice.isWindows || gDevice.isTabletAll ? 24 : 12);
}

Widget getEspacadorTriplo() {
  return SizedBox(height: gDevice.isWindows || gDevice.isTabletAll ? 36 : 18);
}

Duration getCupertinoModalBottomSheetDuration({int milliseconds = 500}) {
  return Duration(milliseconds: milliseconds);
}

double getElevation(context) {
  return (gTema.modo == 'dark' ? 10 : 10);
}

EdgeInsetsGeometry getPaddingDefaultExternal(context, {bool paddingTopAlca = false}) {
  // double m = (gDevice.isWindows || gDevice.isTabletAll ? 12 : 6);
  // double v = (gDevice.isWindows || gDevice.isTabletAll ? 1 : 1);

  // return EdgeInsets.only(left: (m * v), right: m * v, top: (m * v) + (paddingTopAlca ? 16 : 0), bottom: m * v);
  return EdgeInsets.all(gDevice.isWindows || gDevice.isTabletAll ? 12 : 12);
}

EdgeInsetsGeometry getPaddingDefault(context) {
  return EdgeInsets.all(gDevice.isWindows || gDevice.isTabletAll ? 8 : 8);
}

///
/// DIALOGOS
///
///
///
///

showOkCancela(BuildContext context, String caption, String msg, VoidCallback onOk) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: FacileTheme.headlineMedium(context, caption.toUpperCase()),
        content: Wrap(
          alignment: WrapAlignment.center,
          children: [
            msg != ''
                ? Icon(
                    Icons.announcement,
                    size: 70,
                    color: Theme.of(context).colorScheme.error,
                  )
                : const SizedBox(),
            msg != ''
                ? Text(
                    msg,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  )
                : const SizedBox(),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('CANCELA', style: TextStyle(fontSize: 20)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            onPressed: onOk,
            child: const Text('OK', style: TextStyle(fontSize: 20)),
          ),
        ],
      );
    },
  );
}

showSimNao(BuildContext context, String caption, String msg, VoidCallback onOk) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: FacileTheme.headlineMedium(context, caption.toUpperCase()),
        content: Wrap(
          alignment: WrapAlignment.center,
          children: [
            msg != ''
                ? Icon(
                    Icons.announcement,
                    size: 70,
                    color: Theme.of(context).colorScheme.error,
                  )
                : const SizedBox(),
            msg != '' ? FacileTheme.headlineSmall(context, msg) : const SizedBox(),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('NÃO', style: TextStyle(fontSize: 20)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            onPressed: onOk,
            child: const Text('SIM', style: TextStyle(fontSize: 20)),
          ),
        ],
      );
    },
  );
}

showAlert(BuildContext context, String caption, String msg, {sOK = 'OK'}) {
  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.red,
    title: FacileTheme.headlineMedium(context, caption),
    content: FacileTheme.headlineSmall(context, msg),
    actions: [
      TextButton(
        child: Text(sOK, style: const TextStyle(fontSize: 20)),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertError(
  BuildContext context,
  String caption,
  String msg, {
  sOK = 'OK',
  VoidCallback? onThen,
  dur = 3000,
}) {
  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.orange.shade900,
    title: FacileTheme.headlineMedium(context, caption, invert: true),
    content: FacileTheme.headlineSmall(context, msg, invert: true),
    actions: [
      TextButton(
        autofocus: true,
        child: FacileTheme.displaySmall(context, sOK, invert: true),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      Timer(Duration(milliseconds: dur), () {
        if (context.mounted) {
          Navigator.pop(context);
        }
      });

      return alert;
    },
  ).then((value) {
    if (onThen != null) {
      onThen();
    }
  });
}

showAlertWarning(
  BuildContext context,
  String caption,
  String msg, {
  sOK = 'OK',
  VoidCallback? onThen,
  dur = 3000,
}) {
  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.orange.shade900,
    title: FacileTheme.headlineMedium(context, caption, invert: true),
    content: FacileTheme.headlineSmall(context, msg, invert: true),
    actions: [
      TextButton(
        autofocus: true,
        child: FacileTheme.displaySmall(context, sOK, invert: true),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      Timer(Duration(milliseconds: dur), () {
        if (context.mounted) {
          Navigator.pop(context);
        }
      });

      return alert;
    },
  ).then((value) {
    if (onThen != null) {
      onThen();
    }
  });
}

showAlertSuccess(
  BuildContext context,
  String caption,
  String msg, {
  sOK = 'OK',
  VoidCallback? onThen,
  dur = 1000,
}) {
  AlertDialog alert = AlertDialog(
    //backgroundColor: Colors.green.shade900,
    title: FacileTheme.headlineMedium(context, caption),
    content: FacileTheme.headlineSmall(context, msg),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      Timer(Duration(milliseconds: dur), () {
        if (context.mounted) {
          Navigator.pop(context);
        }
      });

      return alert;
    },
  ).then((value) {
    if (onThen != null) {
      onThen();
    }
  });
}

showLoading(BuildContext context, {VoidCallback? onThen}) {
  AlertDialog alert = AlertDialog(
    contentPadding: getPaddingDefault(context),
    content: Padding(
      padding: getPaddingDefault(context),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              width: getMaxSizedBoxLottieHeight(context),
              child: Lottie.asset(
                'imagens/loading.json',
                fit: BoxFit.contain,
              ),
            ),
            // const SizedBox(
            //   width: 100,
            //   height: 100,
            //   child: CircularProgressIndicator(
            //     strokeWidth: 8,
            //   ),
            // ),
            getEspacadorDuplo(),
            FacileTheme.headlineSmall(context, '1 minuto por favor...'),
          ],
        ),
      ),
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  ).then((value) {
    if (onThen != null) {
      onThen();
    }
  });
}

void facileSnackBarSucess(context, caption, msg, {dur = 2000, VoidCallback? onThen}) {
  showAlertSuccess(context, caption, msg, onThen: onThen, dur: dur);
  // var snackBar = SnackBar(
  //   elevation: 0,
  //   behavior: SnackBarBehavior.floating,
  //   backgroundColor: Colors.transparent,
  //   duration: Duration(milliseconds: dur),
  //   content: AwesomeSnackbarContent(
  //     title: caption,
  //     message: msg,
  //     messageFontSize: (gDevice.isWindows ? 18 : 14),
  //     contentType: ContentType.success,
  //   ),
  // );

  //ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void snackBarMsg(context, msg, {dur = 1000}) {
  var gradient = LinearGradient(
    colors: [
      (gTema.modo == 'dark' ? Colors.orange.withOpacity(0.6) : Colors.orange.withOpacity(0.6)),
      (gTema.modo == 'dark' ? Colors.orange.withOpacity(0.6) : Colors.orange.withOpacity(0.6)),
      (gTema.modo == 'dark' ? Colors.orange.withOpacity(0.6) : Colors.orange.withOpacity(0.6)),
      (gTema.modo == 'dark' ? Colors.orange.withOpacity(0.6) : Colors.orange.withOpacity(0.6)),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  var snackBar = SnackBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    behavior: SnackBarBehavior.fixed,
    duration: Duration(milliseconds: dur),
    content: Padding(
      padding: EdgeInsets.only(bottom: getMaxSizedBoxHeight(context) * .05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: getMaxSizedBoxWidth(context) * 0.8,
                padding: getPaddingDefault(context) * (gDevice.isTabletAll ? 3 : 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: gradient,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    gDevice.isTabletAll ? FacileTheme.displayLarge(context, msg) : FacileTheme.displayMedium(context, msg),
                  ],
                ),
              ).animate().flip(),
            ],
          ),
        ],
      ),
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void facileSnackBarError(context, caption, msg, {dur = 2000}) {
  showAlertError(context, caption, msg, dur: dur);
  // var snackBar = SnackBar(
  //   elevation: 0,
  //   behavior: SnackBarBehavior.floating,
  //   backgroundColor: Colors.transparent,
  //   duration: Duration(milliseconds: dur),
  //   content: AwesomeSnackbarContent(
  //     title: caption,
  //     message: msg,
  //     messageFontSize: (gDevice.isWindows ? 18 : 14),
  //     contentType: ContentType.failure,
  //   ),
  // );

  // ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

PreferredSizeWidget? getCupertinoAppBar(context, caption, icons, {addClose = true, isBack = false}) {
  List<Widget> actions = [];

  for (var fab in icons) {
    Widget w = IconButton(
      icon: Icon(fab.icon, size: gDevice.isWindows || gDevice.isTabletAll ? 32 : null),
      color: Theme.of(context).colorScheme.primary,
      onPressed: fab.onTap,
    );
    actions.add(w);
  }
  if (addClose) {
    actions.add(IconButton(
        icon: Icon(Icons.close, size: gDevice.isWindows || gDevice.isTabletAll ? 32 : null),
        color: Theme.of(context).colorScheme.primary,
        onPressed: () {
          Navigator.pop(context);
        }));
  }

  return AppBar(
    centerTitle: true,
    actions: actions,
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        isBack ? Icons.arrow_back_ios : Icons.expand_more_outlined,
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        gUsuario.imagem.isEmpty
            ? const SizedBox()
            : SizedBox(
                width: 30,
                height: 30,
                child: ClipOval(
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(
                      getMaxSizedImagemProfile(context),
                    ),
                    child: Image.network(
                      gUsuario.imagem,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
        getEspacadorVertical(),
        FacileTheme.displaySmall(
          context,
          caption,
        ),
      ],
    ),
  );
}

PreferredSizeWidget? getCupertinoAppBarCheck(context, caption, icons, isLoad, {addCheck = true, addBack = true}) {
  List<Widget> actions = [];

  for (var fab in icons) {
    Widget w = IconButton(
      icon: Icon(fab.icon, size: gDevice.isWindows || gDevice.isTabletAll ? 32 : null),
      color: isLoad ? Colors.grey : Theme.of(context).colorScheme.primary,
      onPressed: isLoad ? () {} : fab.onTap,
    );

    actions.add(w);
  }

  if (addCheck) {
    actions.add(IconButton(
        icon: Icon(Icons.check, size: gDevice.isWindows || gDevice.isTabletAll ? 32 : null),
        color: isLoad ? Colors.grey : Theme.of(context).colorScheme.primary,
        onPressed: () {
          if (!isLoad) {
            Navigator.pop(context, 'check');
          }
        }));
  }

  Widget wUsuario = gUsuario.imagem.isEmpty
      ? const SizedBox()
      : SizedBox(
          width: 30,
          height: 30,
          child: ClipOval(
            child: SizedBox.fromSize(
              size: Size.fromRadius(
                getMaxSizedImagemProfile(context),
              ),
              child: Image.network(
                gUsuario.imagem,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );

  return AppBar(
    centerTitle: true,
    actions: actions,
    leading: !addBack
        ? wUsuario
        : IconButton(
            onPressed: () {
              if (!isLoad) {
                Navigator.pop(context, 'back');
              }
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: isLoad ? Colors.grey : Theme.of(context).colorScheme.primary,
            ),
          ),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        addCheck ? wUsuario : const SizedBox(),
        getEspacadorVertical(),
        FacileTheme.displaySmall(
          context,
          caption,
        ),
      ],
    ),
  );
}

///
/// COMPONENTES
///
///
///
///

class TextButtonEx extends StatefulWidget {
  final VoidCallback? onPressed;
  final String caption;

  const TextButtonEx({Key? key, required this.caption, required this.onPressed}) : super(key: key);

  @override
  State<TextButtonEx> createState() => _TextButtonExState();
}

class _TextButtonExState extends State<TextButtonEx> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            widget.caption,
            maxLines: 1,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontStyle: FontStyle.italic,
              // decoration: TextDecoration.underline,
              // decorationColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

class ElevatedButtonEx extends StatefulWidget {
  final VoidCallback? onPressed;
  final Icon icon;
  final String caption;
  final ButtonStyle style;

  const ElevatedButtonEx({
    Key? key,
    required this.caption,
    required this.icon,
    required this.onPressed,
    required this.style,
  }) : super(key: key);

  @override
  State<ElevatedButtonEx> createState() => _ElevatedButtonExState();
}

class _ElevatedButtonExState extends State<ElevatedButtonEx> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: widget.style,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          (widget.caption.isEmpty
              ? const SizedBox()
              : Text(
                  widget.caption,
                  maxLines: 1,
                )),
          widget.icon,
        ],
      ),
    );
  }
}

class ElevatedButtonNoIconEx extends StatefulWidget {
  final VoidCallback? onPressed;
  final String caption;
  final ButtonStyle style;

  const ElevatedButtonNoIconEx({
    Key? key,
    required this.caption,
    required this.onPressed,
    required this.style,
  }) : super(key: key);

  @override
  State<ElevatedButtonNoIconEx> createState() => _ElevatedButtonNoIconExState();
}

class _ElevatedButtonNoIconExState extends State<ElevatedButtonNoIconEx> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: widget.style,
      child: Row(
        //padding: EdgeInsets.all(Platform.isWindows ? 25 : (gDevice.isTabletLandscape ? 15 : (gDevice.isPhoneSmall ? 17 : 18))),
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            widget.caption,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

Widget getCard(BuildContext context, wchild, {cardSuave = false}) {
  var gradient = LinearGradient(
    colors: [
      // (gTema.modo == 'dark' ? getColorPrimary(context).withOpacity(0.1) : Colors.grey.shade200.withOpacity(0.5)),
      // (gTema.modo == 'dark' ? FacileTheme.getColorButton(context).withOpacity(0.1) : Colors.grey.shade200.withOpacity(0.5)),
      // (gTema.modo == 'dark' ? FacileTheme.getColorButton(context).withOpacity(0.1) : Colors.grey.shade200.withOpacity(0.5)),
      // (gTema.modo == 'dark' ? getColorPrimary(context).withOpacity(0.1) : Colors.grey.shade200.withOpacity(0.5)),

      (gTema.modo == 'dark' ? Colors.white.withOpacity(0.1) : Colors.grey.shade200.withOpacity(0.5)),
      (gTema.modo == 'dark' ? Colors.white.withOpacity(0.1) : Colors.grey.shade200.withOpacity(0.5)),
      (gTema.modo == 'dark' ? Colors.white.withOpacity(0.1) : Colors.grey.shade200.withOpacity(0.5)),
      (gTema.modo == 'dark' ? Colors.white.withOpacity(0.1) : Colors.grey.shade200.withOpacity(0.5)),

      // (gTema.modo == 'dark' ? getColorPrimary(context).withOpacity(0.1) : FacileTheme.getColorButton(context).withOpacity(0.1)),
      // (gTema.modo == 'dark' ? FacileTheme.getColorButton(context).withOpacity(0.1) : getColorPrimary(context).withOpacity(0.1)),
      // (gTema.modo == 'dark' ? FacileTheme.getColorButton(context).withOpacity(0.1) : getColorPrimary(context).withOpacity(0.1)),
      // (gTema.modo == 'dark' ? getColorPrimary(context).withOpacity(0.1) : FacileTheme.getColorButton(context).withOpacity(0.2)),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  //(gTema.modo == 'dark' ? Colors.blue.shade200.withOpacity(0.1) : Colors.white.withOpacity(.5)),
  //(gTema.modo == 'dark' ? Colors.blue.shade200.withOpacity(0.1) : Colors.white.withOpacity(.5)),

  return BackdropFilter(
    //filter: ImageFilter.blur(sigmaX: Random().nextInt(20).toDouble() + 3, sigmaY: Random().nextInt(20).toDouble() + 3),
    filter: ImageFilter.blur(sigmaX: cardSuave ? 0 : 20, sigmaY: cardSuave ? 0 : 20),
    child: Container(
      padding: getPaddingDefault(context),
      decoration: BoxDecoration(
//          color: (gTema.modo == 'dark' ? Colors.blue.shade200.withOpacity(0.1) : Colors.white.withOpacity(.5)),

        borderRadius: BorderRadius.circular(30),
        // boxShadow: [
        //   BoxShadow(
        //     color: FacileTheme.getColorButton(context).withOpacity(.5),
        //     blurRadius: 1.0,
        //     spreadRadius: 1.0,
        //     offset: const Offset(2.0, 2.0),
        //   )
        // ],
        gradient: gradient,
      ),
      child: wchild,
    ),
  );
  //).animate().flipH(duration: const Duration(milliseconds: 1500));
}

Widget getStackCupertino(context, List<Widget> background, child) {
  return getStackCupertinoAlca(context, background, child, showAlca: false);
}

Widget getStackCupertinoAlca(context, List<Widget> background, child, {showAlca = true}) {
  List<Widget> wids = [];
  wids.addAll(background);

  if (showAlca) {
    wids.insert(
        0,
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.drag_handle_sharp,
              //color: Colors.bla,
              size: 40,
            ),
          ],
        ));
  }
  wids.add(child);

  return Stack(
    children: wids,
  );
}

Color getColorRandom() {
  return gTema.colorArray[Random().nextInt(gTema.colorArray.length - 1)];
}

Widget getBallColor(context, int max) {
  Color cor = getColorRandom();
  var gradient = LinearGradient(
    colors: [
      cor,
      Colors.black,
    ],
  );

  double size = max.toDouble();

  return Positioned(
    top: Random().nextInt(MediaQuery.of(context).size.height.toInt()).toDouble(),
    left: Random().nextInt(MediaQuery.of(context).size.width.toInt()).toDouble(),
    child: Opacity(
      opacity: 1,
      child: facileDelayedDisplayB(
        Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: gradient,
          ),
        ),
        dur: 100,
      ),
    ),
  );
}

List<Widget> getBackgroundColor(context, {minimize = false}) {
  List<Widget> result = [
    getBallColor(context, Random().nextInt(50)),
    getBallColor(context, Random().nextInt(20)),
    getBallColor(context, Random().nextInt(50)),
    getBallColor(context, Random().nextInt(20)),
    getBallColor(context, Random().nextInt(50)),
    getBallColor(context, Random().nextInt(20)),
    getBallColor(context, Random().nextInt(50)),
    getBallColor(context, Random().nextInt(20)),
    getBallColor(context, Random().nextInt(50)),
    getBallColor(context, Random().nextInt(20)),
    getBallColor(context, Random().nextInt(50)),
    getBallColor(context, Random().nextInt(20)),
    getBallColor(context, Random().nextInt(50)),
    getBallColor(context, Random().nextInt(20)),
    getBallColor(context, Random().nextInt(50)),
    getBallColor(context, Random().nextInt(20)),
    getBallColor(context, Random().nextInt(50)),
    getBallColor(context, Random().nextInt(20)),
    getBallColor(context, Random().nextInt(50)),
    getBallColor(context, Random().nextInt(20)),
    getBallColor(context, Random().nextInt(100)),
    getBallColor(context, Random().nextInt(100)),
    getBallColor(context, Random().nextInt(70)),
    getBallColor(context, Random().nextInt(70)),
    getBallColor(context, Random().nextInt(100)),
    getBallColor(context, Random().nextInt(70)),
    getBallColor(context, Random().nextInt(100)),
    getBallColor(context, Random().nextInt(70)),
    getBallColor(context, Random().nextInt(100)),
    getBallColor(context, Random().nextInt(70)),
    getBallColor(context, Random().nextInt(100)),
    getBallColor(context, Random().nextInt(70)),
    getBallColor(context, Random().nextInt(100)),
    getBallColor(context, Random().nextInt(70)),
    getBallColor(context, Random().nextInt(100)),
    getBallColor(context, Random().nextInt(70)),
    getBallColor(context, Random().nextInt(100)),
    getBallColor(context, Random().nextInt(70)),
    getBallColor(context, Random().nextInt(100)),
    getBallColor(context, Random().nextInt(70)),
    getBallColor(context, Random().nextInt(100))
  ];

  return result;
}

List<Widget> getBackground(context, {minimize = false}) {
  // var boxshadow = BoxShadow(
  //   color: Colors.grey.shade300,
  //   blurStyle: BlurStyle.normal,
  //   blurRadius: 1.0,
  //   spreadRadius: 5.0,
  //   offset: const Offset(-2, -2),
  // );

  List<Widget> result = [
    getBall(context, Random().nextInt(30)),
    getBall(context, Random().nextInt(30)),
    getBall(context, Random().nextInt(30)),
    getBall(context, Random().nextInt(30)),
    getBall(context, Random().nextInt(30)),
    getBall(context, Random().nextInt(30)),
    getBall(context, Random().nextInt(30)),
    getBall(context, Random().nextInt(30)),
    getBall(context, Random().nextInt(30)),
    getBall(context, Random().nextInt(30)),
    getBall(context, Random().nextInt(30)),
    getBall(context, Random().nextInt(30)),
    getBall(context, Random().nextInt(30)),
    getBall(context, Random().nextInt(30)),
    getBall(context, Random().nextInt(30)),
    getBall(context, Random().nextInt(30)),
    getBall(context, Random().nextInt(30)),
    getBall(context, Random().nextInt(30)),
    getBall(context, Random().nextInt(30)),
    getBall(context, Random().nextInt(30)),
    getBall(context, Random().nextInt(30)),
    getBall(context, Random().nextInt(30)),
    getBall(context, Random().nextInt(30)),
    getBall(context, Random().nextInt(30)),
    getBall(context, Random().nextInt(30)),
    getBall(context, Random().nextInt(30)),
    getBall(context, Random().nextInt(30)),
    getBall(context, Random().nextInt(50)),
    getBall(context, Random().nextInt(50)),
    getBall(context, Random().nextInt(50)),
    getBall(context, Random().nextInt(50)),
    getBall(context, Random().nextInt(50)),
    getBall(context, Random().nextInt(50)),
    getBall(context, Random().nextInt(50)),
    getBall(context, Random().nextInt(50)),
    getBall(context, Random().nextInt(100)),
    getBall(context, Random().nextInt(100)),
    getBall(context, Random().nextInt(100)),
    getBall(context, Random().nextInt(100)),
    getBall(context, Random().nextInt(100)),
    getBall(context, Random().nextInt(100)),
    getBall(context, Random().nextInt(100)),
    getBall(context, Random().nextInt(130)),
    getBall(context, Random().nextInt(130)),
    getBall(context, Random().nextInt(130)),
    getBall(context, Random().nextInt(130)),
    getBall(context, Random().nextInt(130)),
    getBall(context, Random().nextInt(130)),
    getBall(context, Random().nextInt(130)),
    getBall(context, Random().nextInt(250)),
    getBall(context, Random().nextInt(250)),
    getBall(context, Random().nextInt(250)),
    getBall(context, Random().nextInt(250)),
    SizedBox(
      height: MediaQuery.of(context).size.height,
    ),
  ];

  //if (gDevice.isWindows || gDevice.isTabletAll) {
  result = result +
      [
        getBall(context, Random().nextInt(700)),
        getBall(context, Random().nextInt(700)),
        getBall(context, Random().nextInt(700)),
        getBall(context, Random().nextInt(1200)),
        getBall(context, Random().nextInt(1200)),
      ];
  //}

  if (minimize) {
    result = [
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(30)),
      getBall(context, Random().nextInt(50)),
      getBall(context, Random().nextInt(50)),
      getBall(context, Random().nextInt(50)),
      getBall(context, Random().nextInt(50)),
      getBall(context, Random().nextInt(50)),
      getBall(context, Random().nextInt(50)),
      getBall(context, Random().nextInt(50)),
      getBall(context, Random().nextInt(50)),
      getBall(context, Random().nextInt(100)),
      getBall(context, Random().nextInt(100)),
      getBall(context, Random().nextInt(100)),
      getBall(context, Random().nextInt(100)),
      getBall(context, Random().nextInt(100)),
    ];
  }

  return result;
}

Widget getBall(context, int max) {
  var gradient = LinearGradient(
    colors: [
      //Theme.of(context).colorScheme.onPrimaryContainer,
      //FacileTheme.getColorButton(context),
      Colors.grey,
      Colors.grey.shade200,
      //getColorPrimary(context),
      //Colors.grey.shade100,
      //Colors.grey,
      //gTema.colorArray[Random().nextInt(2)].withOpacity(.2),
    ],
  );

  //if (gTema.modo == 'light') {
  gradient = LinearGradient(
    colors: [
      Theme.of(context).colorScheme.onPrimaryContainer,
      FacileTheme.getColorButton(context),
    ],
  );
  //}

  double size = max.toDouble();

  return Positioned(
    top: Random().nextInt(MediaQuery.of(context).size.height.toInt()).toDouble(),
    left: Random().nextInt(MediaQuery.of(context).size.width.toInt()).toDouble(),
    child: Opacity(
      opacity: .7,
      child: facileDelayedDisplayB(
        Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            //boxShadow: [boxshadow],
            shape: BoxShape.circle,
            gradient: gradient,
          ),
        ),
        //dur: size.toInt() + 500,
        dur: 100,
      ),
    ),
  );
}

///
/// APOIO PARA FORMS
///
///
///
///

///
/// FFormIconButton
///

class FormIconButton {
  final IconData icon;
  final VoidCallback? onTap;
  String caption = '';

  FormIconButton({required this.icon, required this.onTap, this.caption = ''});
}

///
/// FFormFloatingActionButton
///

class FormFloatingActionButton {
  final IconData icon;
  final VoidCallback? onTap;
  String caption = '';
  Color? cor;

  FormFloatingActionButton({required this.icon, required this.onTap, this.caption = '', this.cor});
}

///
/// getFFormFloatingActionButtonList
///

Widget getFormFloatingActionButtonList(listIn, {isLoad = false, mainAxisAlignment = MainAxisAlignment.end, bool mini = false, bool animate = false}) {
  List<Widget> list = [];

  for (var fab in listIn) {
    Widget w = Opacity(
      opacity: mini ? 0.8 : 0.9,
      child: FloatingActionButton.extended(
        backgroundColor: isLoad ? Colors.grey.withOpacity(0.9) : fab.cor,
        foregroundColor: isLoad ? Colors.white.withOpacity(0.8) : null,
        heroTag: null,
        onPressed: isLoad ? () {} : fab.onTap,
        label: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(fab.caption),
            animate
                ? Icon(fab.icon).animate(onPlay: (controller) => controller.repeat()).shake(
                      delay: 1400.ms,
                      duration: 1000.ms,
                    )
                : Icon(fab.icon),
          ],
        ),
      ),
    );
    //if (mini) {
    list.add(facileDelayedDisplayBatendo(w));
    list.add(const SizedBox(
      width: 5,
    ));
  }
  return Row(
    mainAxisAlignment: mainAxisAlignment,
    children: list,
  );
}

Widget getBody(context, List<Widget> w1, List<Widget> w2, {mainAxisAlignment = MainAxisAlignment.center, flex1 = 5, flex2 = 5, delay = true, cardSuave = false}) {
  if (delay) {
    int efeito = Random().nextInt(4);
    double offset = Random().nextInt(10).toDouble();

    int dur = 0;
    for (int i = 0; i < w1.length; i++) {
      w1[i] = facileDelayedDisplay(w1[i], dur: dur, efeito: efeito, offset: offset);
      dur += 2;
    }

    for (int i = 0; i < w2.length; i++) {
      w2[i] = facileDelayedDisplay(w2[i], dur: dur, efeito: efeito, offset: offset);
      dur += 2;
    }
  }

  return Padding(
    padding: getPaddingDefaultExternal(context),
    child: (gDevice.isTabletLandscape || gDevice.isWindows
        ? getCard(
            context,
            Row(
              children: [
                Expanded(
                    flex: flex1,
                    child: Padding(
                      padding: getPaddingDefault(context),
                      child: Column(
                        mainAxisAlignment: mainAxisAlignment,
                        children: w1,
                      ),
                    )),
                Expanded(
                    flex: flex2,
                    child: Padding(
                      padding: getPaddingDefault(context),
                      child: Column(
                        mainAxisAlignment: mainAxisAlignment,
                        children: w2,
                      ),
                    )),
              ],
            ))
        : getCard(
            context,
            Column(
              mainAxisAlignment: mainAxisAlignment,
              children: (w1 + w2),
            ),
            cardSuave: cardSuave)),
  );
}

Widget facileDelayedDisplayBatendo(wid, {int dur = 0}) {
  return DelayedDisplay(
    slidingCurve: Curves.bounceOut,
    delay: Duration(milliseconds: 200 + dur),
    child: wid,
  );
}

Widget facileDelayedDisplay(wid, {int dur = 0, int efeito = 0, double offset = 0}) {
  var efeitos = [
    Curves.decelerate,
    //Curves.bounceOut,
    Curves.easeInQuad,
    Curves.fastOutSlowIn,
    Curves.fastLinearToSlowEaseIn,
  ];

  return DelayedDisplay(
    slidingBeginOffset: Offset(offset, 5),
    slidingCurve: efeitos[efeito],
    delay: Duration(milliseconds: dur),
    child: wid,
  );
}

Widget facileDelayedDisplayB(wid, {int dur = 0}) {
  return DelayedDisplay(
    slidingCurve: Curves.linear,
    delay: Duration(milliseconds: dur + 500),
    child: wid,
  );
}

Widget facileDelayedDisplayBotoes(wid, {int dur = 0}) {
  return DelayedDisplay(
    slidingCurve: Curves.linear,
    delay: Duration(milliseconds: 100 + dur),
    child: wid,
  );
}

Future<String> getFileData(String path) async {
  return await rootBundle.loadString(path);
}

///
/// MISC
///
///
///
///

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    ///
    /// Vem 0.00
    /// Muda para 000
    /// Muda para 0000000000 (10)
    /// Adiciona o ponto 00000000.00
    ///

    String s = newValue.text.replaceAll('.', '');

    if (s.isEmpty) {
      s = '0.00';
    }

    s = s.padLeft(10, '0');
    s = '${s.substring(0, s.length - 2)}.${s.substring(s.length - 2)}';

    double value = double.parse(s);
    final f = NumberFormat("#######0.00");

    s = f.format(value);

    return newValue.copyWith(text: s, selection: TextSelection.collapsed(offset: s.length));
  }
}

class CurrencyInputFormatter3 extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    ///
    /// Vem 0.00
    /// Muda para 000
    /// Muda para 0000000000 (10)
    /// Adiciona o ponto 00000000.00
    ///

    String s = newValue.text.replaceAll('.', '');

    if (s.isEmpty) {
      s = '0.000';
    }

    s = s.padLeft(10, '0');
    s = '${s.substring(0, s.length - 3)}.${s.substring(s.length - 3)}';

    double value = double.parse(s);
    final f = NumberFormat("######0.000");

    s = f.format(value);

    return newValue.copyWith(text: s, selection: TextSelection.collapsed(offset: s.length));
  }
}

///
/// CLASSES DE APOIO
///
///
///
///

class PopReturnsDynamic {
  String action;
  dynamic param;

  PopReturnsDynamic(this.action, this.param);

  void setParam(p) {
    param = p;
  }
}

class PopReturns {
  String action;
  String param;

  PopReturns(this.action, this.param);

  void setParam(p) {
    param = p;
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

Widget getLogo(context, {double proporcao = 1}) {
  var gradient = LinearGradient(
    colors: [
      FacileTheme.getColorHard(context),
      FacileTheme.getColorHard(context).withOpacity(.9),
      FacileTheme.getColorHard(context),
    ],
  );

  return Transform(
    transform: Matrix4.identity()..rotateZ(-3 * 3.1415927 / 180),
    child: DottedBorder(
      borderType: BorderType.Rect,
      strokeWidth: 2,
      padding: const EdgeInsets.all(5),
      color: (gTema.modo == 'dark' ? Colors.white : Colors.black),
      dashPattern: const [6, 6],
      child: Container(
        height: 75 * proporcao,
        width: 150 * proporcao,
        decoration: BoxDecoration(
          gradient: gradient,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'FACILE',
              style: GoogleFonts.anton(
                fontSize: 40 * proporcao,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ).animate(onPlay: (controller) => controller.repeat()).shimmer(delay: 400.ms, duration: 4000.ms, color: Colors.grey).then().shake(duration: 500.ms),
      ),
    ),
  );
}

Widget getSlogan(context, {double proporcao = 1, String title = ''}) {
  var gradient = LinearGradient(
    colors: [
      Colors.yellow,
      Colors.yellow.withOpacity(.9),
      Colors.yellow,
    ],
  );

  return Transform(
    transform: Matrix4.identity()..rotateZ(-9 * 3.1415927 / 180),
    child: DottedBorder(
      borderType: BorderType.Rect,
      strokeWidth: 2,
      padding: const EdgeInsets.all(5),
      color: (gTema.modo == 'dark' ? Colors.white : Colors.black),
      dashPattern: const [6, 6],
      child: Container(
        height: 75 * proporcao,
        width: 150 * proporcao,
        decoration: BoxDecoration(
          gradient: gradient,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.anton(
                fontSize: 50 * proporcao,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget getImageDefault(context, String url, {inList = false, double clip = 10}) {
  var gradient = const RadialGradient(
    colors: [
      Colors.transparent,
      Colors.transparent,
    ],
  );

  if (gParametros.aparenciaPreencherFundoImagem == 'S' && gParametros.aparenciaPreencherFundoImagemDiversificar == 'S') {
    gradient = RadialGradient(
      colors: [
        Colors.white,
        getColorRandom().withOpacity(.3),
      ],
    );
  } else if (gParametros.aparenciaPreencherFundoImagem == 'S') {
    gradient = RadialGradient(
      colors: [
        Colors.white,
        FacileTheme.getColorButton(context),
      ],
    );
  }

  if (inList) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(clip),
      child: Container(
        width: 80,
        decoration: BoxDecoration(
          gradient: gradient,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
            url,
          ),
        ),
      ),
    );
  }

  return Stack(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(clip),
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              url,
            ),
          ),
        ),
      ),
      Padding(
        padding: getPaddingDefault(context),
        child: RotatedBox(
          quarterTurns: -1,
          child: FacileTheme.headlineMedium(context, gUsuario.subdominio.toUpperCase()),
        ),
      ),
    ],
  );
}

void compartilha(bytes, {String text = ''}) async {
  var arquivo = 'tmp.png';
  final appDir = await syspaths.getTemporaryDirectory();
  File file = File('${appDir.path}/$arquivo');
  await file.writeAsBytes(bytes);
  Share.shareFiles(['${appDir.path}/$arquivo'], text: text);
}

String getUniqueID() {
  return md5.convert(utf8.encode('${DateTime.now().millisecondsSinceEpoch}-${UniqueKey()}')).toString();
}

double truncate(double val, int places) {
  num mod = pow(10.0, places);
  return ((val * mod).round().toDouble() / mod);
}
