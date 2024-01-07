import 'package:facilelojaapp/main.dart';
import 'package:facilelojaapp/util.dart';
import 'package:facilelojaapp/utiltema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';

/// **************************
/// Logon
///

enum LeClienteModo {
  cpf,
  cnpj,
  celular,
}

class LeClientePage extends StatefulWidget {
  final String title;
  final LeClienteModo modo;

  const LeClientePage({super.key, required this.title, required this.modo});

  @override
  State<LeClientePage> createState() => _LeClienteState();
}

class _LeClienteState extends State<LeClientePage> {
  var btnStyle = TextStyle(fontSize: (gDevice.isWindows ? 30 : 20), fontWeight: FontWeight.bold);
  List<FormFloatingActionButton> listFloatingActionButton = [];
  String senha = '';
  List<Widget> bg = [];
  String svg = '';

  @override
  void initState() {
    super.initState();

    iniciaValor(context);

    if (gDevice.isWindows) {
      listFloatingActionButton.add(
        FormFloatingActionButton(
          icon: CupertinoIcons.chevron_down,
          caption: getTextWindowsKey((gDevice.isWindows ? 'CANCELAR' : ''), 'ESC'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      );
    }

    load(context);
  }

  void load(context) async {
    svg = await getFileData('imagens/documento.svg');
    setState(() {});
  }

  void onFocusKey(context, RawKeyEvent event) {
    var s = event.logicalKey.keyLabel.toString().replaceAll('Numpad ', '').replaceAll('Digit ', '').replaceAll('Key ', '').replaceAll('Space', ' ');

    if (event.runtimeType == RawKeyDownEvent) {
      debugPrint('RegistroPage::onFocusKey::$s');

      if (s == 'Escape') {
        Navigator.pop(context);
      } else if (s == 'C') {
        iniciaValor(context);
      } else if (s == 'Enter') {
        retornarValor(context);
      } else if ('1234567890'.contains(s)) {
        if (widget.modo == LeClienteModo.cpf && senha.length < 11) {
          senha += s;
        } else if (widget.modo == LeClienteModo.cnpj && senha.length < 14) {
          senha += s;
        } else if (widget.modo == LeClienteModo.celular && senha.length < 11) {
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
      FacileTheme.headlineMedium(context, widget.title),
      SizedBox(
        height: getMaxSizedBoxLottie(context) / 2,
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
      FacileTheme.headlineLarge(context, formataModo(senha)),
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
          appBar: getCupertinoAppBar(
            context,
            'ENTRADA',
            [],
          ),
          body: getStackCupertinoAlca(
            context,
            bg,
            getBody(context, w1, w2, flex1: 5, flex2: 5, delay: false),
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
          retornarValor(context);
        },
      );
    }
    return ElevatedButtonNoIconEx(
      caption: caption,
      style: ElevatedButton.styleFrom(),
      onPressed: () {
        gDevice.beep();

        if (widget.modo == LeClienteModo.cpf && senha.length < 11) {
          senha += caption;
        } else if (widget.modo == LeClienteModo.cnpj && senha.length < 14) {
          senha += caption;
        } else if (widget.modo == LeClienteModo.celular && senha.length < 11) {
          senha += caption;
        }
        setState(() {});
      },
    );
  }

  void retornarValor(context) async {
    if (senha.trim().isEmpty) {
      gDevice.beepErr();
      facileSnackBarError(context, 'Ops!', '${widget.title}!');
      return;
    }

    String result = senha;

    if (result.length != 11 && result.length != 14) {
      gDevice.beepErr();
      facileSnackBarError(context, 'Ops!', 'Tamanho inválido !');
      return;
    }

    if (widget.modo == LeClienteModo.cpf) {
      if (!CPFValidator.isValid(result)) {
        gDevice.beepErr();
        facileSnackBarError(context, 'Ops!', 'CPF inválido !');
        return;
      }
    }
    if (widget.modo == LeClienteModo.cnpj) {
      if (!CNPJValidator.isValid(result)) {
        gDevice.beepErr();
        facileSnackBarError(context, 'Ops!', 'CNPJ inválido !');
        return;
      }
    }

    Navigator.pop(context, PopReturns('okClick', result));
  }

  String formataModo(str) {
    String result = str;
    return result;
  }

  void iniciaValor(context) {
    senha = '';
  }
}
