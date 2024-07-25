import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:facilelojaapp/levalor.dart';
import 'package:facilelojaapp/main.dart';
import 'package:facilelojaapp/util.dart';
import 'package:facilelojaapp/utiltema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'cupom.dart';
import 'dados/meiospagamento.dart';
import 'utilpost.dart';

/// **************************
/// Pagar
///

class PagamentoPage extends StatefulWidget {
  final Cupom cupom;

  const PagamentoPage({super.key, required this.cupom});

  @override
  State<PagamentoPage> createState() => _PagamentoState();
}

class _PagamentoState extends State<PagamentoPage> {
  late List<MeioPagamento> meios = [];
  List<Widget> bg = [];
  String svg = '';
  bool isLoad = true;
  int parcelas = 0;

  @override
  void initState() {
    super.initState();

    load(context);
  }

  void load(context) async {
    svg = await getFileData('imagens/pagamento.svg');

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

      int i = 0;
      int index = -1;
      for (var meio in meios) {
        for (var pagto in widget.cupom.pagtos) {
          if (meio.id == pagto.idMeioPagamento && meio.pedeParcelamento == 'S') {
            snackBarMsg(context, 'SELECIONADO AS PARCELAS...');
            index = i;
            Timer(const Duration(milliseconds: 1500), () {
              menuParcelas(context, index, modo: 'parcelar');
            });
            break;
          }
        }
        i++;
      }

      if (index == -1) {
        if (mounted) {
          setState(() {
            isLoad = false;
          });
        }
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

  Widget getCardValor(context, double prop, String title, String val, {bool invert = false}) {
    return Card(
      color: FacileTheme.getColorHard(context),
      shadowColor: Colors.transparent,
      elevation: 10,
      child: SizedBox(
        width: getMaxSizedBoxWidth(context) * prop,
        height: gDevice.isTabletAll ? 100 : 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FacileTheme.headlineSmall(context, title, invert: true, fontSize: gDevice.isTabletAll ? 24 : 14),
                FacileTheme.headlineMedium(context, val, invert: true, fontSize: gDevice.isTabletAll ? 36 : 24),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) {
      return const SizedBox();
    }
    if (bg.isEmpty) {
      bg = getBackground(context);
    }

    List<Widget> w1 = [
      SizedBox(
        height: getMaxSizedBoxLottieHeight(context) * (gDevice.isTabletAll ? 0.7 : 0.5),
        child: svg.isEmpty
            ? const SizedBox()
            : SizedBox(
                child: SvgPicture.string(svg.replaceAll('#B0BEC5', gTema.colorArray[gTema.cor].toHex().replaceAll('#ff', '#')))
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .move(duration: 1000.ms)),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          getCardValor(context, 0.3, 'SubTotal', widget.cupom.subTotalF),
          getCardValor(context, 0.3, 'Desconto', widget.cupom.descontoF),
          getCardValor(context, 0.3, 'Pagar', widget.cupom.aPagarF),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          getCardValor(context, 0.45, 'Pago', widget.cupom.pagoF),
          getCardValor(context, 0.45, 'Troco', widget.cupom.trocoF),
        ],
      ),
    ];

    List<Widget> w2 = [
      SizedBox(
        height: (getMaxSizedBoxHeight(context) / (gDevice.isTabletLandscape ? 1.2 : (gDevice.isPhoneSmall ? 2.5 : 2))),
        child: isLoad
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FacileTheme.headlineMedium(context, 'AGUARDE...'),
                ],
              )
            : Stack(
                children: [
                  GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 15,
                        crossAxisCount: gDevice.isPhoneAll ? 2 : 3,
                        mainAxisSpacing: 3,
                        mainAxisExtent: gDevice.isTabletAll ? 160 : 80,
                      ),
                      itemCount: meios.length,
                      itemBuilder: (BuildContext context, int index) {
                        Widget card = Card(
                          shadowColor: Colors.transparent,
                          elevation: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FacileTheme.displaySmall(context, meios[index].nome, fontSize: 18),
                              Icon(
                                getIcon(meios[index].codigoSefaz),
                                size: gDevice.isTabletAll ? 60 : 30,
                              ),
                            ],
                          ),
                        );

                        for (var pagto in widget.cupom.pagtos) {
                          if (meios[index].id == pagto.idMeioPagamento) {
                            card = Card(
                              shadowColor: Colors.transparent,
                              color: Colors.green.shade900,
                              elevation: 10,
                              child: Stack(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          FacileTheme.displaySmall(context, meios[index].nome, fontSize: 18, invert: true),
                                          Icon(
                                            getIcon(meios[index].codigoSefaz),
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          FacileTheme.displaySmall(context, (pagto.parcelas > 1 ? '(${pagto.parcelas}) ' : '') + pagto.valorF, fontSize: gDevice.isTabletAll ? 28 : 18, invert: true)
                                              .animate(onPlay: (controller) => controller.repeat())
                                              .shake(delay: 1400.ms, duration: 1000.ms),
                                          getEspacadorVertical(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
                        }

                        return SizedBox(
                          width: getMaxSizedBoxWidth(context) * 0.2,
                          height: getMaxSizedBoxHeight(context) * 0.5,
                          child: InkWell(
                            onTap: () {
                              menuParcelas(context, index);
                            },
                            child: card,
                          ),
                        );
                      }),
                  widget.cupom.aPagar == 0
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: (getMaxSizedBoxHeight(context) / (gDevice.isTabletLandscape ? 1.2 : (gDevice.isPhoneSmall ? 2.5 : 2))) - 20,
                            child: Opacity(
                              opacity: 0.85,
                              child: facileDelayedDisplay(
                                Card(
                                  color: Colors.black,
                                  shadowColor: Colors.transparent,
                                  elevation: 10,
                                  child: Stack(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              parcelas = 0;
                                              widget.cupom.pagtos.clear();
                                              widget.cupom.recalcula();
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.close,
                                                size: gDevice.isTabletAll ? 60 : 30,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              getEspacadorDuplo(),
                                              gDevice.isTabletAll
                                                  ? FacileTheme.headlineLarge(context, 'PAGAMENTO ${widget.cupom.temParcelado ? 'PARCELADO ' : ''}COMPLETO !', invert: true)
                                                  : FacileTheme.headlineSmall(context, 'PAGAMENTO COMPLETO !', invert: true),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context, PopReturns('okClick', ''));
                                                },
                                                child: AvatarGlow(
                                                  glowColor: Colors.green.shade900,
                                                  endRadius: gDevice.isPhoneSmall ? 70 : 120,
                                                  duration: const Duration(milliseconds: 1000),
                                                  repeat: true,
                                                  showTwoGlows: true,
                                                  repeatPauseDuration: const Duration(milliseconds: 100),
                                                  child: Material(
                                                    elevation: 8.0,
                                                    shape: const CircleBorder(),
                                                    child: CircleAvatar(
                                                      backgroundColor: Colors.green.shade900,
                                                      radius: gDevice.isTabletAll
                                                          ? 80
                                                          : gDevice.isPhoneSmall
                                                              ? 40
                                                              : 50,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Icon(
                                                            Icons.send,
                                                            size: gDevice.isTabletAll
                                                                ? 80
                                                                : gDevice.isPhoneSmall
                                                                    ? 30
                                                                    : 40,
                                                            color: Colors.white,
                                                          ),
                                                          FacileTheme.headlineMedium(
                                                            context,
                                                            'ENVIAR',
                                                            invert: true,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox()
                ],
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

  void paga(context, int index) async {
    if (widget.cupom.aPagar == 0) {
      return;
    }

    showCupertinoModalBottomSheet(
      backgroundColor: FacileTheme.getShadowColor(context),
      duration: getCupertinoModalBottomSheetDuration(),
      context: context,
      builder: (context) => LeValorPage(
        title: meios[index].nome.toUpperCase(),
        modo: LeValorModo.monetario,
        limite: meios[index].codigoSefaz == '01' ? 0 : widget.cupom.aPagar,
        valorInicial: widget.cupom.aPagar.toStringAsFixed(2),
      ),
    ).then(
      (value) {
        if (value != null && value.action == 'okClick') {
          if (double.parse(value.param) > 0) {
            final item = CupomPagto(
              idMeioPagamento: meios[index].id,
              nome: meios[index].nome,
              codigoSefaz: meios[index].codigoSefaz,
              gerarXml: meios[index].gerarXml,
              valor: double.parse(value.param),
              parcelas: parcelas,
            );

            var s = widget.cupom.adicionaPagto(context, item);

            if (s.isNotEmpty) {
              facileSnackBarError(context, 'Ops!', s);
            }
          }

          setState(() {});
        }
      },
    );
  }

  Future<void> menuParcelas(context, int index, {String modo = ''}) async {
    if (!mounted) {
      return;
    }

    if (meios[index].pedeParcelamento == 'S') {
      List<Widget> acts = [];

      parcelas = 0;

      acts.add(
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            if (mounted) {
              Navigator.pop(context);
              parcelas = 0;
            }
          },
          child: FacileTheme.displayLarge(context, "A VISTA"),
        ),
      );

      int max = int.parse(gParametros.vendaLimiteParcelasCredito);

      for (var i = 2; i <= max; i++) {
        acts.add(
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () async {
              if (mounted) {
                Navigator.pop(context);
                parcelas = i;
              }
            },
            child: FacileTheme.displayLarge(context, '$i X'),
          ),
        );
      }

      final action = CupertinoActionSheet(
        title: FacileTheme.headlineSmall(context, 'CRÉDIDO PARCELADO'),
        actions: acts,
        cancelButton: CupertinoActionSheetAction(
          child: FacileTheme.displaySmall(context, 'CANCELA'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );

      showCupertinoModalPopup(context: context, builder: (context) => action).then(
        (value) {
          if (modo.isEmpty) {
            paga(context, index);
          } else {
            if (mounted) {
              setState(() {
                isLoad = false;
                if (widget.cupom.pagtos.isNotEmpty) {
                  widget.cupom.pagtos[0].parcelas = parcelas;
                }
                widget.cupom.recalcula();
              });
            }
          }
        },
      );
    } else {
      paga(context, index);
    }
  }

  ///
  /// Fim
  ///
}
