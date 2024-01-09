// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:facilelojaapp/configuraimpressoraex.dart';
import 'package:facilelojaapp/menu.dart';
import 'package:facilelojaapp/utilpost.dart';
import 'package:facilelojaapp/logon.dart';
import 'package:facilelojaapp/main.dart';
import 'package:facilelojaapp/registro.dart';
import 'package:facilelojaapp/util.dart';
import 'package:facilelojaapp/utiltema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// **************************
/// Abertura
///

List<Widget> bg = [];

class IniciaPage extends StatefulWidget {
  const IniciaPage({super.key});

  @override
  State<IniciaPage> createState() => _IniciaPageState();
}

class _IniciaPageState extends State<IniciaPage> {
  bool isLoad = false;

  @override
  void initState() {
    super.initState();
    load(context);
  }

  void load(context) async {
    Timer(const Duration(milliseconds: 500), () async {
      setState(() {
        isLoad = true;
      });
    });

    Timer(const Duration(milliseconds: 4001), () {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => const AberturaPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gTema.modo == 'dark' ? gTema.defaultColorDark : gTema.defaultColorLight,
      body: Center(
        child: !isLoad
            ? null
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getLogo(context, proporcao: gDevice.isTabletAll || gDevice.isWindows ? 1.5 : 1),
                  SizedBox(
                    height: 200,
                    //6width: getMaxSizedBoxLottieHeight(context),
                    child: Lottie.asset(
                      'imagens/loading.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                  FacileTheme.headlineLarge(context, 'Aguarde...').animate(onPlay: (controller) => controller.repeat()).shimmer(delay: 400.ms, duration: 4000.ms, color: Colors.grey),
                ],
              ),
      ),
    );
  }
}

class AberturaPage extends StatefulWidget {
  const AberturaPage({super.key});

  @override
  State<AberturaPage> createState() => _AberturaState();
}

class _AberturaState extends State<AberturaPage> {
  List<FormFloatingActionButton> listFloatingActionButton = [];
  bool isLoad = false;
  String svg = '';

  @override
  void initState() {
    super.initState();
    load(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void load(context) async {
    Timer(const Duration(milliseconds: 1500), () async {
      bg = getBackground(context);
      svg = await getFileData('imagens/abertura.svg');
      setState(() {
        isLoad = true;
      });
    });
  }

  void registroPage() {
    showCupertinoModalBottomSheet(
      duration: getCupertinoModalBottomSheetDuration(),
      context: context,
      builder: (context) => const RegistroPage(),
    ).then(
      (value) {
        setState(() {});
      },
    );
  }

  void conf() {
    showCupertinoModalBottomSheet(
      duration: getCupertinoModalBottomSheetDuration(),
      context: context,
      builder: (context) => const ConfiguraImpressoraExPage(),
    ).then(
      (value) {
        setState(() {});
      },
    );
  }

  void entrarPage() async {
    showCupertinoModalBottomSheet(
      backgroundColor: FacileTheme.getShadowColor(context),
      duration: getCupertinoModalBottomSheetDuration(),
      context: context,
      builder: (context) => const LogonPage(),
    ).then(
      (value) {
        debugPrint('AberturaPage::$value');
        if (value != null && value == 'ok') {
          Timer(const Duration(milliseconds: 800), () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const MenuPage(),
              ),
            );
          });
        }
      },
    );
  }

  void onFocusKey(context, RawKeyEvent event) {
    var s = event.logicalKey.keyLabel.toString().replaceAll('Numpad ', '').replaceAll('Digit ', '').replaceAll('Key ', '').replaceAll('Space', ' ');

    if (event.runtimeType == RawKeyDownEvent) {
      debugPrint('AberturaPage::onFocusKey::$s');

      if (s == 'F1' && gUsuario.subdominio.trim().isEmpty) {
        registroPage();
      } else if (s == 'F1') {
        entrarPage();
      } else if (s == 'Escape') {}
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('AberturaPage::build');

    listFloatingActionButton.clear();

    listFloatingActionButton.add(FormFloatingActionButton(
        icon: Icons.mode_night_outlined,
        caption: getTextWindowsKey('', ''),
        onTap: () {
          gTema.changeTheme(context);
        }));

    listFloatingActionButton.add(FormFloatingActionButton(
        icon: Icons.color_lens_outlined,
        caption: getTextWindowsKey('', ''),
        onTap: () async {
          gTema.changeColor(context);
          Timer(const Duration(milliseconds: 200), () {
            bg = getBackground(context);
            setState(() {});
          });
        }));

    listFloatingActionButton.add(FormFloatingActionButton(
      caption: (gUsuario.subdominio.trim().isEmpty ? getTextWindowsKey('REGISTRAR', 'F1') : getTextWindowsKey('ENTRAR', 'F1')),
      icon: CupertinoIcons.chevron_up,
      onTap: () {
        if (gUsuario.subdominio.trim().isEmpty) {
          registroPage();
        } else {
          entrarPage();
        }
      },
    ));

    List<Widget> w1 = [
      getLogo(context, proporcao: gDevice.isTabletAll || gDevice.isWindows ? 1.5 : 1),
      getEspacadorDuplo(),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //    FacileTheme. headlineLarge(context, 'FACILE').animate(onPlay: (controller) => controller.repeat()).shimmer(delay: 400.ms, duration: 4000.ms, color: Colors.grey),
      //   ],
      // ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FacileTheme.headlineMedium(context, 'Aplicativo de vendas'),
        ],
      ),
      FacileTheme.displaySmall(
        context,
        (gUsuario.subdominio.isEmpty ? 'Terminal não registrado' : 'Terminal ${gUsuario.host} registrado para ${gUsuario.subdominio.toUpperCase()}'),
      ),
      (gUsuario.subdominio.isEmpty
          ? const SizedBox()
          : TextButtonEx(
              caption: 'Descadastrar este aparelho',
              //style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(1)),
              onPressed: () {
                showSimNao(
                  context,
                  'Aviso',
                  'Este aparelho será desconectado do sistema, confirma ?',
                  () {
                    Navigator.pop(context);
                    descadastrar(context);
                  },
                );
              },
            ))
    ];

    List<Widget> w2 = [
      SizedBox(
        height: getMaxSizedBoxLottieHeight(context),
        child: svg.isEmpty
            ? const SizedBox()
            : SizedBox(
                child: SvgPicture.string(svg.replaceAll('#AAAAAA', gTema.colorArray[gTema.cor].toHex().replaceAll('#ff', '#')))
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .move(duration: 1000.ms)),
      ),

      // Container(
      //   height: 300,
      //   decoration: const BoxDecoration(
      //     image: DecorationImage(
      //       image: NetworkImage("http://192.168.1.10/img/store.gif"),
      //       colorFilter: ColorFilter.mode(Colors.white, BlendMode.colorBurn),
      //       fit: BoxFit.cover,
      //     ),
      //   ),
      // )
    ];

    return !isLoad
        ? Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: getMaxSizedBoxLottieHeight(context) * .3,
                    child: Lottie.asset(
                      'imagens/loading.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                  FacileTheme.displayMedium(context, 'Mais 1 minuto...').animate(onPlay: (controller) => controller.repeat()).shimmer(delay: 400.ms, duration: 4000.ms, color: Colors.grey),
                ],
              ),
            ),
          )
        : Focus(
            autofocus: true,
            onKey: (node, event) {
              onFocusKey(context, event);
              return KeyEventResult.ignored;
            },
            child: WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: SafeArea(
                child: Scaffold(
                  floatingActionButton: getFormFloatingActionButtonList(listFloatingActionButton),
                  body: getStackCupertino(
                    context,
                    bg,
                    getBody(context, w1, w2, flex1: 4, flex2: 6, delay: true),
                  ),
                ),
              ),
            ),
          );
  }

  void descadastrar(context) async {
    Map<String, String> params = {
      'Funcao': 'Descadastra',
    };

    var aResult = await facilePostEx(context, 'facileFlutterApp.php', params, showProc: true, addParam: true);

    if (aResult == null) {
    } else if (aResult != null && aResult['Status'] == 'OK') {
      gUsuario.clear();
      facileSnackBarSucess(context, 'Show!', aResult['Msg']);
      setState(() {});
    } else {
      gUsuario.clear();
      facileSnackBarError(context, 'Ops!', aResult['Msg']);
      setState(() {});
    }
  }
}
