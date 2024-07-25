import 'dart:developer';
import 'package:facilelojaapp/utilpost.dart';
import 'package:facilelojaapp/main.dart';
import 'package:facilelojaapp/util.dart';
import 'package:facilelojaapp/utiltema.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// **************************
/// Registro
///

class RegistroPage extends StatefulWidget {
  const RegistroPage({super.key});

  @override
  State<RegistroPage> createState() => _RegistroState();
}

class _RegistroState extends State<RegistroPage> {
  TextEditingController controllerSenhaValidador = TextEditingController();
  TextEditingController controllerApelidoValidador = TextEditingController();
  List<Widget> bg = [];
  String svg = '';

  @override
  void initState() {
    super.initState();

    load(context);
  }

  void load(context) async {
    svg = await getFileData('imagens/registro.svg');
    log('load...');
    setState(() {});
  }

  void onFocusKey(context, RawKeyEvent event) {
    var s = event.logicalKey.keyLabel.toString().replaceAll('Numpad ', '').replaceAll('Digit ', '').replaceAll('Key ', '').replaceAll('Space', ' ');

    if (event.runtimeType == RawKeyDownEvent) {
      debugPrint('RegistroPage::onFocusKey::$s');

      if (s == 'Escape') {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    log('build...');
    if (bg.isEmpty) {
      bg = getBackground(context);
    }

    List<Widget> w1 = [
      SizedBox(
        height: getMaxSizedBoxLottieHeight(context),
        child: svg.isEmpty
            ? const SizedBox()
            : SizedBox(
                child: SvgPicture.string(svg.replaceAll('#B0BEC5', gTema.colorArray[gTema.cor].toHex().replaceAll('#ff', '#')))
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .move(duration: 1000.ms)),
      ),
    ];

    List<Widget> w2 = [
      FacileTheme.headlineMedium(context, 'Acesse Facile OnLine'),
      FacileTheme.displaySmall(context, 'Procure por Configurações -> Lojas/Empresas'),
      FacileTheme.displaySmall(context, 'e anote um código de ativação LIVRE'),
      getEspacadorDuplo(),
      TextField(
        inputFormatters: [LengthLimitingTextInputFormatter(20)],
        controller: controllerApelidoValidador,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.store),
          hintText: 'Nome do seu negócio',
          label: Text.rich(
            TextSpan(
              children: <InlineSpan>[
                WidgetSpan(
                  child: Text(
                    'Apelido',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      getEspacadorDuplo(),
      TextField(
        inputFormatters: [LengthLimitingTextInputFormatter(6)],
        controller: controllerSenhaValidador,
        obscureText: true,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.lock),
          hintText: 'PIN',
          label: Text.rich(
            TextSpan(
              children: <InlineSpan>[
                WidgetSpan(
                  child: Text(
                    'Código de ativação',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      getEspacadorDuplo(),
      ElevatedButtonEx(
        style: ElevatedButton.styleFrom(),
        caption: 'REGISTRAR',
        icon: const Icon(Icons.check),
        onPressed: () async {
          registro(context);
        },
      ),
      getEspacadorDuplo(),
      getEspacadorDuplo(),
      getEspacadorDuplo(),
      getEspacadorDuplo(),
    ];

    log('build...2');

    return Focus(
      autofocus: true,
      onKey: (node, event) {
        onFocusKey(context, event);
        return KeyEventResult.ignored;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: svg.isEmpty ? null : getCupertinoAppBar(context, 'REGISTRAR TERMINAL', []),
          body: svg.isEmpty
              ? const SizedBox()
              : SingleChildScrollView(
                  child: getStackCupertino(
                    context,
                    bg,
                    getBody(context, w1, w2, flex1: 5, flex2: 5, mainAxisAlignment: MainAxisAlignment.center),
                  ),
                ),
        ),
      ),
    );
  }

  void registro(context) async {
    if (controllerApelidoValidador.text.trim().isEmpty) {
      facileSnackBarError(context, 'Ops!', 'Informe o apelido do seu negócio !');
      return;
    }
    String host = gDevice.host;

    Map<String, String> params = {
      'subdominio': controllerApelidoValidador.text.toLowerCase().trim(),
      'pinInstalacaoTerminal': controllerSenhaValidador.text.trim(),
      'hostTerminal': host,
    };

    FacileResponse response = await facileRouter(context, '/gadget/registrardispositivo', params, showProc: true, addParam: false);

    if (response.isOk()) {
      gUsuario.subdominio = controllerApelidoValidador.text.toLowerCase();
      gUsuario.idLojaFisica = await response.getResult('idLojaFisica', 'data');
      gUsuario.terminalId = await response.getResult('id', 'data');
      gUsuario.terminalHost = await response.getResult('hostTerminal', 'data');
      gUsuario.terminalNome = await response.getResult('terminal', 'data');
      gUsuario.host = host;
      gUsuario.update();

      facileSnackBarSucess(
        context,
        'Show!',
        response.descricao,
        onThen: () {
          Navigator.pop(context);
        },
      );
    } else {
      facileSnackBarError(context, 'Ops!', response.descricao);
    }
  }
}
