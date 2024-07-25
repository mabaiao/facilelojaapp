import 'dart:developer';
import 'package:facilelojaapp/utilpost.dart';
import 'package:facilelojaapp/main.dart';
import 'package:facilelojaapp/util.dart';
import 'package:facilelojaapp/utiltema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';

import 'dados/cargo.dart';
import 'dados/funcionario.dart';
import 'dados/lojafisica.dart';
import 'dados/terminal.dart';

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
      listFloatingActionButton.add(
        FormFloatingActionButton(
          icon: Icons.login_outlined,
          caption: getTextWindowsKey((gDevice.isWindows ? 'ENTRAR' : ''), 'ENTER'),
          onTap: () {},
        ),
      );
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

    Map<String, String> params = {
      'pin': senha,
    };

    FacileResponse response = await facileRouter(context, '/gadget/autorizar', params, showProc: true, addParam: true);

    if (response.isOk()) {
      facileSnackBarSucess(
        context,
        'Show!',
        response.descricao,
        onThen: () {
          Navigator.pop(context, 'ok');
        },
      );

      Iterable v;

      ///
      /// Nao é necessario fazr list para registro simples
      ///
      v = await response.getMap('terminal');
      gTerminal = Terminal.fromMap(v.first);

      v = await response.getMap('lojaFisica');
      gLojaFisica = LojaFisica.fromMap(v.first);

      v = await response.getMap('cargo');
      gCargo = Cargo.fromMap(v.first);

      v = await response.getMap('funcionario');
      gFuncionario = Funcionario.fromMap(v.first);

      //gUsuario.terminaisImpressao = aResult['terminaisImpressao'];
      gUsuario.pin = senha;
      gUsuario.idEmpresa = await response.getResult('idEmpresa', 'data');
      gUsuario.nomeLojaFisica = await response.getResult('nomeLojaFisica', 'data');
      gUsuario.terminalImpressao = await response.getResult('terminalImpressao', 'data');
      gUsuario.terminalNome = await response.getResult('terminal', 'data');
      gUsuario.terminalHost = await response.getResult('hostTerminal', 'data');
      gUsuario.idFuncionario = await response.getResult('idFuncionario', 'data');
      gUsuario.primeiroNome = await response.getResult('primeiroNome', 'data');
      gUsuario.nome = await response.getResult('nome', 'data');
      gUsuario.imagem = await response.getResult('imagem', 'data');
      gUsuario.idCargo = await response.getResult('idCargo', 'data');
      gUsuario.siglaCargo = await response.getResult('siglaCargo', 'data');
      gUsuario.nomeCargo = await response.getResult('nomeCargo', 'data');
      gUsuario.update();
      //gParametros.load(context);
    } else {
      facileSnackBarError(context, 'Ops!', response.descricao);
    }
  }
}
