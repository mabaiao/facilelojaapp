import 'dart:developer';

import 'package:facilelojaapp/dados/meiospagamento.dart';
import 'package:facilelojaapp/main.dart';
import 'package:facilelojaapp/util.dart';
import 'package:facilelojaapp/utiltema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';

import 'utilpost.dart';

/// **************************
/// Le chave do cliente
///

class LeFormaPagamentoPage extends StatefulWidget {
  const LeFormaPagamentoPage({super.key});

  @override
  State<LeFormaPagamentoPage> createState() => _LeFormaPagamentoState();
}

class _LeFormaPagamentoState extends State<LeFormaPagamentoPage> {
  List<Widget> bg = [];
  String svg = '';
  late List<MeioPagamento> meios = [];
  bool isLoad = true;

  @override
  void initState() {
    super.initState();

    load(context);
  }

  void load(context) async {
    svg = await getFileData('imagens/meiopagamento.svg');

    setState(() {});

    Map<String, String> params = {
      'Funcao': 'MeiosPagamentosLe',
    };

    var aResult = await facilePostEx(context, 'facileFlutterApp.php', params, showProc: false);

    if (aResult == null) {
    } else if (aResult != null && aResult['Status'] == 'OK') {
      Iterable v = await aResult['meiospagamento'];
      List<MeioPagamento> meiosTodos = v.map((model) => MeioPagamento.fromMap(model)).toList();

      for (var item in meiosTodos) {
        if (item.mostrarPdv == 'S') {
          meios.add(item);
        }
      }

      log(meios.toString());

      if (mounted) {
        setState(() {
          isLoad = false;
        });
      }
    } else {
      facileSnackBarError(context, 'Ops!', aResult['Msg']);
    }
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
    if (bg.isEmpty) {
      bg = getBackground(context);
    }

    List<Widget> w1 = [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FacileTheme.headlineMedium(context, 'INFORME O MEIO DE PAGAMENTO'),
        ],
      ),
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
      SizedBox(
        width: getMaxSizedBoxWidth(context),
        height: getMaxSizedBoxHeight(context) / 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isLoad
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FacileTheme.headlineMedium(context, 'AGUARDE...'),
                  ],
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 15,
                    crossAxisCount: gDevice.isPhoneAll ? 2 : 4,
                    mainAxisSpacing: 5,
                    mainAxisExtent: gDevice.isTabletAll ? 170 : 130,
                  ),
                  itemCount: meios.length,
                  itemBuilder: (BuildContext context, int index) {
                    Widget card = Card(
                      shadowColor: Colors.transparent,
                      elevation: 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FacileTheme.displaySmall(context, meios[index].nome),
                          Icon(
                            getIcon(meios[index].codigoSefaz),
                            size: 60,
                          ),
                        ],
                      ),
                    );

                    return SizedBox(
                      width: getMaxSizedBoxWidth(context) * 0.2,
                      height: getMaxSizedBoxHeight(context) * 0.5,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(
                              context,
                              PopReturnsDynamic(
                                'okClick',
                                [meios[index].id, meios[index].nome],
                              ));
                        },
                        child: card,
                      ),
                    );
                  }),
        ),
      ),
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
          appBar: getCupertinoAppBar(
            context,
            'PAGAMENTO',
            [],
          ),
          body: getStackCupertinoAlca(
            context,
            bg,
            getBody(context, w1, w2, flex1: 5, flex2: 5, delay: true),
          ),
        ),
      ),
    );
  }

  IconData getIcon(String codigoSefaz) {
    if (codigoSefaz == '01') {
      return Icons.money;
    } else if (codigoSefaz == '17') {
      return CupertinoIcons.qrcode;
    } else if (codigoSefaz == '03') {
      return CupertinoIcons.creditcard;
    }
    return Icons.credit_card;
  }
}
