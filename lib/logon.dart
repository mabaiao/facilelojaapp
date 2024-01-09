import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:facilelojaapp/utilpost.dart';
import 'package:facilelojaapp/main.dart';
import 'package:facilelojaapp/util.dart';
import 'package:facilelojaapp/utiltema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';

/// **************************
/// Logon
///

class LogonPage extends StatefulWidget {
  const LogonPage({super.key});

  @override
  State<LogonPage> createState() => _LogonState();
}

class _LogonState extends State<LogonPage> {
  List<FormFloatingActionButton> listFloatingActionButton = [];
  String senha = '';
  var btnStyle = TextStyle(fontSize: (gDevice.isWindows ? 30 : 20), fontWeight: FontWeight.bold);
  List<Widget> bg = [];
  String svg = '';

  @override
  void initState() {
    super.initState();

    log('load');

    senha = (gDevice.isWindows ? '' : gUsuario.pin);

    if (gDevice.isWindows) {
      listFloatingActionButton.add(FormFloatingActionButton(
          icon: CupertinoIcons.chevron_down,
          caption: getTextWindowsKey((gDevice.isWindows ? 'CANCELAR' : ''), 'ESC'),
          onTap: () {
            Navigator.pop(context);
          }));
    }

    load(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void load(context) async {
    svg = await getFileData('imagens/logon.svg');
    setState(() {});
  }

  void onFocusKey(context, RawKeyEvent event) {
    var s = event.logicalKey.keyLabel.toString().replaceAll('Numpad ', '').replaceAll('Digit ', '').replaceAll('Key ', '').replaceAll('Space', ' ');

    if (event.runtimeType == RawKeyDownEvent) {
      debugPrint('RegistroPage::onFocusKey::$s');

      if (s == 'Escape') {
        Navigator.pop(context);
      } else if (s == 'C') {
        senha = '';
      } else if (s == 'Enter') {
        entrar(context);
      } else if ('1234567890'.contains(s)) {
        if (senha.length < 12) {
          senha += s;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (bg.isEmpty) {
      bg = getBackground(context);
    }

    List<Widget> w1 = [
      FacileTheme.headlineMedium(context, 'Conectar em'),
      FacileTheme.headlineMedium(context, gUsuario.subdominio.toUpperCase()),
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
    ];

    List<Widget> w2 = [
      FacileTheme.displaySmall(context, 'INFORME SEU PIN COM 6 DIGITOS'),
      FacileTheme.headlineLarge(
        context,
        ('').padLeft(senha.length, '*'),
      ),
      getEspacadorDuplo(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: btnNumero(context, '1')),
          getEspacadorVertical(),
          Expanded(child: btnNumero(context, '2')),
          getEspacadorVertical(),
          Expanded(child: btnNumero(context, '3')),
        ],
      ),
      getEspacador(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: btnNumero(context, '4')),
          getEspacadorVertical(),
          Expanded(child: btnNumero(context, '5')),
          getEspacadorVertical(),
          Expanded(child: btnNumero(context, '6')),
        ],
      ),
      getEspacador(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: btnNumero(context, '7')),
          getEspacadorVertical(),
          Expanded(child: btnNumero(context, '8')),
          getEspacadorVertical(),
          Expanded(child: btnNumero(context, '9')),
        ],
      ),
      getEspacador(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: btnNumero(context, 'C')),
          getEspacadorVertical(),
          Expanded(child: btnNumero(context, '0')),
          getEspacadorVertical(),
          Expanded(child: btnNumero(context, 'CR')),
        ],
      )
    ];
    return Focus(
      autofocus: true,
      onKey: (node, event) {
        onFocusKey(context, event);
        setState(() {});
        return KeyEventResult.ignored;
      },
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: getFormFloatingActionButtonList(listFloatingActionButton),
          body: getStackCupertinoAlca(
            context,
            bg,
            getBody(context, w1, w2, flex1: 5, flex2: 5),
          ),
        ),
      ),
    );
  }

  Widget btnNumero(context, caption) {
    if (caption == 'C') {
      return ElevatedButtonNoIconEx(
        caption: caption,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red.shade900,
        ),
        onPressed: () {
          gDevice.beep();

          senha = '';
          setState(() {});
        },
      );
    } else if (caption == 'CR') {
      return ElevatedButtonEx(
        caption: '',
        icon: const Icon(
          Icons.keyboard_return_outlined,
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: FacileTheme.getColorPrimary(context),
        ),
        onPressed: () {
          gDevice.beep();

          entrar(context);
        },
      );
    }
    return ElevatedButtonNoIconEx(
      caption: caption,
      style: ElevatedButton.styleFrom(),
      onPressed: () {
        if (senha.length < 12) {
          gDevice.beep();

          senha += caption;
        }
        setState(() {});
      },
    );
  }

  void entrar(context) async {
    if (senha.trim().isEmpty) {
      facileSnackBarError(context, 'Ops!', 'Informe seu Pin com 6 digitos !');
      return;
    }
    String host = '';

    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

      if (kIsWeb) {
        WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
        host = webBrowserInfo.browserName.toString();
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        host = androidInfo.host.toString();
      } else if (Platform.isWindows) {
        WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
        host = windowsInfo.computerName.toString();
      }
    } catch (e) {
      host = 'unico';
    }

    debugPrint('host::$host');

    Map<String, String> params = {
      'Funcao': 'Logon',
      'Pin': senha,
    };

    var aResult = await facilePostEx(context, 'facileFlutterApp.php', params, showProc: true);

    if (aResult == null) {
    } else if (aResult != null && aResult['Status'] == 'OK') {
      facileSnackBarSucess(
        context,
        'Show!',
        aResult['Msg'],
        onThen: () {
          Navigator.pop(context, 'ok');
        },
      );

      gUsuario.pin = senha;
      gUsuario.nomeLojaFisica = aResult['nomeLojaFisica'];
      gUsuario.idEmpresa = aResult['idEmpresa'];
      gUsuario.idFuncionario = aResult['idFuncionario'];
      gUsuario.primeiroNome = aResult['primeiroNome'];
      gUsuario.nome = aResult['nome'];
      gUsuario.imagem = aResult['imagem'];
      gUsuario.idCargo = aResult['idCargo'];
      gUsuario.siglaCargo = aResult['siglaCargo'];
      gUsuario.nomeCargo = aResult['nomeCargo'];
      gUsuario.update();
      gParametros.load(context);
    } else {
      facileSnackBarError(context, 'Ops!', aResult['Msg']);
    }
  }
}
