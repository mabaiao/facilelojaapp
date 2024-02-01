import 'dart:async';
import 'dart:developer';
import 'package:facilelojaapp/main.dart';
import 'package:facilelojaapp/util.dart';
import 'package:facilelojaapp/utilpost.dart';
import 'package:facilelojaapp/utiltema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'caixa.dart';
import 'dados/pedidoatendimento.dart';
import 'imprimecupom.dart';

/// **************************
/// Produtos
///

class FilaAtendimentoPage extends StatefulWidget {
  const FilaAtendimentoPage({super.key});

  @override
  State<FilaAtendimentoPage> createState() => _FilaAtendimentoState();
}

class _FilaAtendimentoState extends State<FilaAtendimentoPage> {
  bool isLoad = true;
  bool timerLigado = true;

  final FocusNode controllerListNode = FocusNode();
  final ScrollController controllerList = ScrollController();

  String svg = '';

  late List<AtendimentoLoja> listAtendimentoLoja = List.empty();

  @override
  void initState() {
    super.initState();

    loadSvg(context);
    load(context);

    checkTimer(context);
  }

  void scrollToTop() {
    if (controllerList.hasClients) {
      if (gDevice.isWindows) {
        controllerListNode.requestFocus();
      }
      controllerList.jumpTo(0);
    }
  }

  void loadSvg(context) async {
    svg = await getFileData('imagens/search.svg');
  }

  void load(context) async {
    isLoad = true;
    if (mounted) {
      setState(() {});

      Map<String, String> params = {
        'Funcao': 'ListagemAtendimentoLoja',
      };

      var aResult = await facilePostEx(context, 'facileFlutterApp.php', params, showProc: false);

      if (aResult == null) {
      } else if (aResult != null && aResult['Status'] == 'OK') {
        Iterable vAtendimentoLoja = await aResult['listAtendimentoLoja'];
        listAtendimentoLoja = vAtendimentoLoja.map((model) => AtendimentoLoja.fromMap(model)).toList();

        if (mounted) {
          isLoad = false;
          scrollToTop();
          setState(() {});
        }
      } else {
        facileSnackBarError(context, 'Ops!', aResult['Msg']);
      }
    }
  }

  void onFocusKey(context, RawKeyEvent event) {
    var s = event.logicalKey.keyLabel.toString().replaceAll('Numpad ', '').replaceAll('Digit ', '').replaceAll('Key ', '').replaceAll('Space', ' ');

    if (event.runtimeType == RawKeyDownEvent) {
      log('ProdutosPage::onFocusKey::$s');

      if (s == 'Escape') {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<FormIconButton> listIconButton = [];

    // listIconButton.add(FormIconButton(
    //   icon: Icons.refresh_outlined,
    //   caption: getTextWindowsKey(gDevice.isPhoneAll ? '' : 'Scanner', 'F3'),
    //   onTap: () {
    //     load(context);
    //   },
    // ));

    List<FormFloatingActionButton> listFloatingActionButton = [];

    // listFloatingActionButton.add(FormFloatingActionButton(
    //     icon: Icons.refresh_outlined,
    //     caption: getTextWindowsKey(gDevice.isPhoneAll ? '' : 'Atualizar', 'F1'),
    //     onTap: () {
    //       load(context);
    //     }));

    // if (gDevice.isWindows) {
    //   listFloatingActionButton.add(FormFloatingActionButton(
    //       icon: CupertinoIcons.chevron_down,
    //       caption: getTextWindowsKey((gDevice.isWindows ? 'VOLTAR' : ''), 'ESC'),
    //       onTap: () {
    //         Navigator.pop(context);
    //       }));
    // }

    listIconButton.add(FormIconButton(
      icon: Icons.receipt_long_rounded,
      caption: getTextWindowsKey(gDevice.isPhoneAll ? '' : 'Atendimento', 'F9'),
      onTap: () {},
    ));

    List<Widget> w1 = [
      getEspacadorDuplo(),
      SizedBox(
        height: getMaxSizedBoxHeight(context) *
            (gDevice.isWindows
                ? 0.95
                : gDevice.isTabletLandscape
                    ? 0.85
                    : gDevice.isPhoneSmall
                        ? 0.90
                        : 0.95),
        child: GridView.builder(
            controller: controllerList,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 1,
              crossAxisCount: 1,
              mainAxisSpacing: 1,
              mainAxisExtent: gDevice.isTabletPortrait
                  ? 160
                  : gDevice.isWindows || gDevice.isTabletLandscape
                      ? 160
                      : 140,
            ),
            itemCount: listAtendimentoLoja.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                //focusNode: index == 0 && gDevice.isWindows ? controllerListNode : null,
                onTap: () {
                  ///
                  /// Menu
                  ///

                  menu(context, listAtendimentoLoja[index]);
                },
                child: cardFila(context, index),
              );
            }),
      )
    ];

    if (listAtendimentoLoja.isEmpty) {
      w1 = [
        SizedBox(
          height: getMaxSizedBoxHeight(context) * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                          width: getMaxSizedBoxLottieHeight(context),
                          child: Lottie.asset(
                            'imagens/cartempty.json',
                            fit: BoxFit.contain,
                            frameRate: FrameRate(1115),
                          ))
                      .animate(
                        onPlay: (controller) => controller.repeat(reverse: true),
                      )
                      .move(duration: 1000.ms),
                  FacileTheme.headlineLarge(
                    context,
                    'AGUARDANDO ATENDIMENTO',
                  ).animate(onPlay: (controller) => controller.repeat()).shimmer(delay: 400.ms, duration: 4000.ms, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ];
    }
    // if (listAtendimentoLoja.isEmpty) {
    //   w1 = [
    //     SizedBox(
    //       height: getMaxSizedBoxHeight(context) * 0.8,
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Icon(
    //                 Icons.shopping_cart_outlined,
    //                 size: gDevice.isTabletAll ? 250 : 160,
    //                 color: FacileTheme.getColorHard(context),
    //               ).animate(onPlay: (controller) => controller.repeat()).shake(delay: 1400.ms, duration: 1000.ms),
    //               FacileTheme.headlineLarge(
    //                 context,
    //                 'AGUARDANDO ATENDIMENTO',
    //               ).animate(onPlay: (controller) => controller.repeat()).shimmer(delay: 400.ms, duration: 4000.ms, color: Colors.grey),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //   ];
    // }

    return Focus(
      autofocus: true,
      onKey: (node, event) {
        onFocusKey(context, event);
        return KeyEventResult.ignored;
      },
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: () async {
          return !isLoad;
        },
        child: SafeArea(
          child: Scaffold(
            floatingActionButton: getFormFloatingActionButtonList(listFloatingActionButton, isLoad: isLoad),
            appBar: getCupertinoAppBar(context, 'FILA DE ATENDIMENTO(${listAtendimentoLoja.length})', listIconButton, isBack: true, addClose: false),
            body: Column(children: w1),
          ),
        ),
      ),
    );
  }

  cardFila(context, index) {
    var ind = index + 1;

    double heightPreco = gDevice.isTabletAll || gDevice.isWindows ? 80 : 50;

    Widget preco = Container(
      height: heightPreco,
      width: gDevice.isTabletAll || gDevice.isWindows ? 200 : 130,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        border: true
            ? Border.all(
                color: FacileTheme.getColorButton(context),
                width: 1,
              )
            // ignore: dead_code
            : null,
        boxShadow: [
          BoxShadow(
            color: FacileTheme.getShadowColor(context),
            spreadRadius: 0.1,
            blurRadius: 12,
            offset: const Offset(-3, -3),
          ),
        ],
        gradient: LinearGradient(
          colors: [
            FacileTheme.getColorHard(context),
            FacileTheme.getColorHard(context),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            badges.Badge(
              badgeContent: Icon(Icons.attach_money, size: gDevice.isTabletAll || gDevice.isWindows ? 10 : 10),
              position: badges.BadgePosition.topEnd(top: -13, end: -25),
              badgeColor: Theme.of(context).colorScheme.inversePrimary,
              child: FacileTheme.displayLarge(
                context,
                listAtendimentoLoja[index].totalF,
                invert: true,
              ),
            ),
          ],
        ),
      ),
    );

    return Container(
      margin: EdgeInsets.all(gDevice.isWindows ? 4 : 2),
      decoration: BoxDecoration(
        border: Border.all(
          color: FacileTheme.getColorButton(context),
          width: 0.5,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Stack(
        children: [
          /// **************************
          /// Image/nome stack 2/2
          ///
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                /// **************************
                /// Imagem do funcionario de atendimento
                ///
                Padding(
                  padding: EdgeInsets.only(left: gDevice.isPhoneAll ? 5 : 15),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: listAtendimentoLoja[index].status == '1' ? Colors.green : Colors.blue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: gDevice.isTabletAll ? 10 : 10,
                          color: listAtendimentoLoja[index].status == '1' ? Colors.green : Colors.blue,
                          offset: const Offset(2, 2),
                        )
                      ],
                    ),
                    child: SizedBox(
                      width: gDevice.isWindows || gDevice.isTabletAll ? 90 : 60,
                      height: gDevice.isWindows || gDevice.isTabletAll ? 90 : 60,
                      child: ClipOval(
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(
                            getMaxSizedImagemProfile(context),
                          ),
                          child: Image.network(
                            listAtendimentoLoja[index].imagem,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// **************************
          /// Nome
          ///

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(flex: gDevice.isWindows || gDevice.isTabletLandscape ? 1 : 2, child: const SizedBox()),
                  Expanded(
                    flex: 6,
                    child:

                        /// **************************
                        /// Data e hora do atendimento
                        ///

                        Text(
                      '${listAtendimentoLoja[index].data} ${listAtendimentoLoja[index].hora}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: FacileTheme.getColorPrimary(context),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(flex: gDevice.isWindows || gDevice.isTabletLandscape ? 1 : 2, child: const SizedBox()),
                  Expanded(
                    flex: 6,
                    child:

                        /// **************************
                        /// Cliente
                        ///
                        Row(
                      children: [
                        Expanded(
                          child: FacileTheme.displaySmall(context, '${listAtendimentoLoja[index].cliente} - ${listAtendimentoLoja[index].celular}', align: TextAlign.start),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(flex: gDevice.isWindows || gDevice.isTabletLandscape ? 1 : 2, child: const SizedBox()),
                  Expanded(
                    flex: 6,
                    child:

                        /// **************************
                        /// Meio de pagamento
                        ///
                        Row(
                      children: [
                        Icon(getIcon(listAtendimentoLoja[index].idSugestaoMeioPagamento), size: gDevice.isTabletAll ? 48 : 32),
                        FacileTheme.displaySmall(context, listAtendimentoLoja[index].nomeSugestaoMeioPagamento),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(flex: gDevice.isWindows || gDevice.isTabletLandscape ? 1 : 2, child: const SizedBox()),
                  Expanded(
                    flex: 6,
                    child:

                        /// **************************
                        /// Nome
                        ///
                        Row(
                      children: [
                        Container(
                          //color: listAtendimentoLoja[index].status == '1' ? Colors.green : Colors.blue,

                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            border: Border.all(
                              color: listAtendimentoLoja[index].status == '1' ? Colors.green : Colors.blue,
                              width: 1,
                            ),
                            color: listAtendimentoLoja[index].status == '1' ? Colors.green : Colors.blue,
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: FacileTheme.displaySmall(
                              context,
                              listAtendimentoLoja[index].status == '1' ? 'Aguardando' : 'Em atendimento',
                              invert: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),

          /// **************************
          /// No pedido
          ///
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      width: gDevice.isWindows || gDevice.isTabletAll ? 150 : 120,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(15),
                        ),
                        border: Border.all(
                          color: FacileTheme.getColorPrimary(context),
                          width: .5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: FacileTheme.getShadowColor(context),
                            spreadRadius: 0.5,
                            blurRadius: 12,
                            offset: const Offset(-3, 3),
                          ),
                        ],
                        gradient: LinearGradient(
                          colors: [
                            FacileTheme.getColorButton(context),
                            FacileTheme.getColorButton(context),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: FacileTheme.displaySmall(
                                context,
                                'ID:${listAtendimentoLoja[index].idVenda} / $ind',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: gDevice.isWindows || gDevice.isTabletAll ? 130 : 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      listAtendimentoLoja[index].nomeFuncionarioComissionado,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: listAtendimentoLoja[index].status == '1' ? Colors.green : Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              gDevice.isPhoneAll ? getEspacadorDuplo() : getEspacador(),
            ],
          ),

          /// **************************
          /// Total da venda
          ///
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    preco,
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData getIcon(String id) {
    if (id == '1') {
      return Icons.money;
    } else if (id == '2') {
      return CupertinoIcons.qrcode;
    } else if (int.parse(id) >= 14) {
      return CupertinoIcons.creditcard;
    }
    return Icons.credit_card;
  }

  void menu(context, AtendimentoLoja item) {
    if (item.status == '1') {
      menuAtender(context, item);
    } else {
      menuEmAtendimento(context, item);
    }
  }

  void reImprime(context, String m, AtendimentoLoja item) {
    timerLigado = false;
    showCupertinoModalBottomSheet(
      backgroundColor: FacileTheme.getShadowColor(context),
      duration: getCupertinoModalBottomSheetDuration(),
      context: context,
      builder: (context) => ImprimeCupomPage(
        title: m,
        idVenda: item.idVenda,
        showConfetti: false,
      ),
    ).then(
      (value) {
        load(context);
        timerLigado = true;

        if (value != null && value == 'ok') {}
      },
    );
  }

  void menuEmAtendimento(context, AtendimentoLoja item) {
    final action = CupertinoActionSheet(
      title: FacileTheme.headlineSmall(context, 'CLIENTE ${item.cliente.toUpperCase()}'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            goCaixa(context, CaixaModo.venda, item);
          },
          child: Column(
            children: [
              const Icon(
                Icons.payment,
                size: 48,
              ),
              FacileTheme.displayLarge(context, "IR PARA O PAGAMENTO"),
            ],
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            devolverAtendimento(context, item);
          },
          child: FacileTheme.displaySmall(context, "DEVOLVER PARA FILA DE ATENDIMENTO"),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            reImprime(context, 'REIMPRESSÃO PEDIDO ${item.id}', item);
          },
          child: FacileTheme.displaySmall(context, "VISUALIZAR / REIMPRIMIR"),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: FacileTheme.displaySmall(context, 'CANCELA'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );

    showCupertinoModalPopup(context: context, builder: (context) => action).then((value) {});
  }

  void menuAtender(context, AtendimentoLoja item) {
    final action = CupertinoActionSheet(
      title: FacileTheme.headlineSmall(context, 'CLIENTE ${item.cliente.toUpperCase()}'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            atender(context, item);
          },
          child: Column(
            children: [
              const Icon(
                Icons.emoji_emotions_outlined,
                size: 48,
              ),
              FacileTheme.displayLarge(context, "ATENDER"),
            ],
          ),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: FacileTheme.displaySmall(context, 'CANCELA'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );

    showCupertinoModalPopup(context: context, builder: (context) => action).then((value) {});
  }

  Future<void> atender(context, AtendimentoLoja item) async {
    Map<String, String> params = {
      'Funcao': 'AlteraStatusPedidoEmAtendimento',
      'idVenda': item.idVenda,
    };

    var aResult = await facilePostEx(context, 'facileFlutterApp.php', params, showProc: false);

    if (aResult == null) {
    } else if (aResult != null && aResult['Status'] == 'OK') {
      snackBarMsg(context, aResult['Msg'], dur: 2000);
      load(context);
      //menuEmAtendimento(context, item);
    } else {
      snackBarMsg(context, aResult['Msg'], dur: 2000);
      load(context);
    }
  }

  Future<void> devolverAtendimento(context, AtendimentoLoja item) async {
    Map<String, String> params = {
      'Funcao': 'AlteraStatusPedidoEmAberto',
      'idVenda': item.idVenda,
    };

    var aResult = await facilePostEx(context, 'facileFlutterApp.php', params, showProc: false);

    if (aResult == null) {
    } else if (aResult != null && aResult['Status'] == 'OK') {
      snackBarMsg(context, aResult['Msg'], dur: 2000);
      load(context);
    } else {
      snackBarMsg(context, aResult['Msg'], dur: 2000);
      load(context);
    }
  }

  void goCaixa(context, CaixaModo modo, AtendimentoLoja item) {
    timerLigado = false;
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => CaixaPage(modo: modo, idVenda: item.idVenda, idVendaImagem: item.imagem),
      ),
    ).then((value) {
      //log('value=$value');
      load(context);
      timerLigado = true;
    });
  }

  void checkTimer(context) {
    Timer(const Duration(milliseconds: 5000), () {
      if (mounted) {
        if (timerLigado) {
          log('TIMER-ON!');
          load(context);
        } else {
          log('TIMER-OFF!');
        }
        checkTimer(context);
      }
    });
  }
}
