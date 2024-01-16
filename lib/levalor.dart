import 'package:facilelojaapp/main.dart';
import 'package:facilelojaapp/util.dart';
import 'package:facilelojaapp/utiltema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

/// **************************
/// Logon
///

enum LeValorModo {
  inteiro,
  percentual,
  monetario,
}

class LeValorPage extends StatefulWidget {
  final String title;
  final LeValorModo modo;
  final double limite;

  const LeValorPage({super.key, required this.title, required this.modo, required this.limite});

  @override
  State<LeValorPage> createState() => _LeValorState();
}

class _LeValorState extends State<LeValorPage> {
  var btnStyle = TextStyle(fontSize: (gDevice.isWindows ? 30 : 20), fontWeight: FontWeight.bold);
  List<FormFloatingActionButton> listFloatingActionButton = [];
  String senha = '';
  List<Widget> bg = [];
  String svg = '';
  NumberFormat format = NumberFormat('###,##0.00', 'pt_BR');

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
        iniciaValor(context);
      } else if (s == 'Enter') {
        retornarValor(context);
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
      FacileTheme.headlineMedium(context, widget.title),
      FacileTheme.displayMedium(context, 'Limite em ${format.format(widget.limite)} ${widget.modo == LeValorModo.percentual ? "%" : ""}'),
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
      FacileTheme.headlineLarge(context, formataModo(senha)),
      gDevice.isPhoneSmall ? const SizedBox() : getEspacadorDuplo(),
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

        if (widget.modo == LeValorModo.percentual) {
          if (senha.length < 5) {
            senha += caption;
          }
        } else if (widget.modo == LeValorModo.monetario) {
          if (senha.length < 15) {
            senha += caption;
          }
        }
        setState(() {});
      },
    );
  }

  void retornarValor(context) async {
    if (senha.trim().isEmpty) {
      gDevice.beepErr();
      facileSnackBarError(context, 'Ops!', 'INFORME ${widget.title}');
      return;
    }

    String result = senha.replaceAll('.', '');

    result = result.padLeft(20, '0');
    result = '${result.substring(0, result.length - 2)}.${result.substring(result.length - 2)}';

    if (widget.modo == LeValorModo.percentual || widget.modo == LeValorModo.monetario) {
      var resultParam = double.parse(result);
      Navigator.pop(context, PopReturns('okClick', resultParam.toStringAsFixed(2)));
    }
  }

  String formataModo(str) {
    String result = str.replaceAll('.', '');

    result = result.padLeft(20, '0');
    result = '${result.substring(0, result.length - 2)}.${result.substring(result.length - 2)}';

    double value = double.parse(result);

    if (widget.modo == LeValorModo.percentual || widget.modo == LeValorModo.monetario) {
      if (value > widget.limite) {
        value = widget.limite;
        senha = value.toStringAsFixed(2).replaceAll('.', '');
      }
    }
    result = format.format(value);

    if (widget.modo == LeValorModo.percentual) {
      result = '$result %';
    } else if (widget.modo == LeValorModo.monetario) {
      result = 'R\$ $result';
    }

    return result;
  }

  void iniciaValor(context) {
    senha = '';
    if (widget.modo == LeValorModo.percentual) {
      format = NumberFormat('##0.00', 'pt_BR');
    } else if (widget.modo == LeValorModo.monetario) {
      format = NumberFormat('###,##0.00', 'pt_BR');
    } else if (widget.modo == LeValorModo.inteiro) {
      format = NumberFormat('#######0', 'pt_BR');
    }
  }
}
