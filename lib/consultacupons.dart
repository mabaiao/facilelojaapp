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
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'dados/venda.dart';
import 'imprimecupom.dart';

/// **************************
/// Produtos
///

class ConsultaCuponsPage extends StatefulWidget {
  const ConsultaCuponsPage({super.key});

  @override
  State<ConsultaCuponsPage> createState() => _ConsultaCuponsState();
}

class _ConsultaCuponsState extends State<ConsultaCuponsPage> {
  bool isLoad = true;

  final FocusNode controllerListNode = FocusNode();
  final ScrollController controllerList = ScrollController();

  late List<Venda> listCupons = List.empty();

  NumberFormat format = NumberFormat('###,##0.00', 'pt_BR');

  DateTime date = DateTime.now();

  List<dynamic> sumario = List.empty();
  List<dynamic> sumarioHora = List.empty();
  List<dynamic> sumarioAutorizacao = List.empty();

  String filtroTipoMovimento = '';
  String filtroHora = '';
  String filtroidVendaFiscal = '';

  @override
  void initState() {
    super.initState();

    load(context);
  }

  void scrollToTop() {
    if (controllerList.hasClients) {
      if (gDevice.isWindows) {
        controllerListNode.requestFocus();
      }
      controllerList.jumpTo(0);
    }
  }

  void load(context) async {
    isLoad = true;
    setState(() {});

    if (mounted) {
      String data = date.toString().substring(0, 10);

      Map<String, String> params = {
        'Funcao': 'ListagemPorData',
        'data': data,
        'filtroTipoMovimento': filtroTipoMovimento,
        'filtroHora': filtroHora,
        'filtroidVendaFiscal': filtroidVendaFiscal,
      };

      var aResult = await facilePostEx(context, 'facileFlutterApp.php', params, showProc: false);

      if (aResult == null) {
      } else if (aResult != null && aResult['Status'] == 'OK') {
        Iterable v = await aResult['listCupons'];
        listCupons = v.map((model) => Venda.fromMap(model)).toList();

        sumario = List.from(aResult['listSumario']);
        sumarioHora = List.from(aResult['listSumarioHora']);
        sumarioAutorizacao = List.from(aResult['listSumarioAutorizacao']);

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

    List<FormFloatingActionButton> listFloatingActionButton = [];

    listIconButton.add(FormIconButton(
      icon: Icons.refresh_outlined,
      caption: getTextWindowsKey(gDevice.isPhoneAll ? '' : 'Scanner', 'F3'),
      onTap: () {
        load(context);
      },
    ));

    listIconButton.add(FormIconButton(
      icon: Icons.filter_alt_outlined,
      caption: getTextWindowsKey(gDevice.isPhoneAll ? '' : 'Scanner', 'F3'),
      onTap: () {
        menuFiltro(context);
      },
    ));

    listIconButton.add(FormIconButton(
      icon: Icons.calendar_month_outlined,
      caption: getTextWindowsKey(gDevice.isPhoneAll ? '' : 'Scanner', 'F3'),
      onTap: () {
        selecionarData(context);
      },
    ));

    listIconButton.add(FormIconButton(
      icon: Icons.menu,
      caption: getTextWindowsKey(gDevice.isPhoneAll ? '' : 'Scanner', 'F3'),
      onTap: () {
        menuGeral(context);
      },
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
            itemCount: listCupons.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                //focusNode: index == 0 && gDevice.isWindows ? controllerListNode : null,
                onTap: () {
                  ///
                  /// Menu
                  ///

                  menuCupom(context, listCupons[index]);
                },
                child: cardFila(context, index),
              );
            }),
      )
    ];

    if (listCupons.isEmpty || isLoad) {
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
                            (isLoad ? 'imagens/loading.json' : 'imagens/vazio.json'),
                            fit: BoxFit.contain,
                            frameRate: FrameRate(1115),
                          ))
                      .animate(
                        onPlay: (controller) => controller.repeat(reverse: true),
                      )
                      .move(duration: 1000.ms),
                  FacileTheme.headlineLarge(
                    context,
                    (isLoad ? 'AGUARDE...' : 'NENHUM MOVIMENTO'),
                  ).animate(onPlay: (controller) => controller.repeat()).shimmer(delay: 400.ms, duration: 4000.ms, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ];
    }
    // if (listCupons.isEmpty) {
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
            appBar: getCupertinoAppBar(context, '(${listCupons.length})', listIconButton, isBack: true, addClose: false, isLoad: isLoad),
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
                format.format(double.parse(listCupons[index].total)),
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
          // Center(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: <Widget>[
          //       /// **************************
          //       /// Imagem do funcionario de atendimento
          //       ///
          //       Padding(
          //         padding: EdgeInsets.only(left: gDevice.isPhoneAll ? 5 : 15),
          //         child: Container(
          //           padding: const EdgeInsets.all(4),
          //           decoration: BoxDecoration(
          //             color: listCupons[index].status == '1' ? Colors.green : Colors.blue,
          //             shape: BoxShape.circle,
          //             boxShadow: [
          //               BoxShadow(
          //                 blurRadius: gDevice.isTabletAll ? 10 : 10,
          //                 color: listCupons[index].status == '1' ? Colors.green : Colors.blue,
          //                 offset: const Offset(2, 2),
          //               )
          //             ],
          //           ),
          //           child: SizedBox(
          //             width: gDevice.isWindows || gDevice.isTabletAll ? 90 : 60,
          //             height: gDevice.isWindows || gDevice.isTabletAll ? 90 : 60,
          //             child: ClipOval(
          //               child: SizedBox.fromSize(
          //                 size: Size.fromRadius(
          //                   getMaxSizedImagemProfile(context),
          //                 ),
          //                 child: Image.network(
          //                   listCupons[index].imagemFuncionarioComissionado,
          //                   fit: BoxFit.cover,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// **************************
                /// Nome
                ///
                Row(
                  children: [
                    FacileTheme.displaySmall(context, '${listCupons[index].dataCadastroF} ${listCupons[index].horaAlteracaoF}', hard: true),
                  ],
                ),

                /// **************************
                /// Tipo de movimento
                ///
                Row(
                  children: [
                    //FacileTheme.displaySmall(context, '${listCupons[index].nomeCliente} - ${listCupons[index].idCliente}', align: TextAlign.start),
                    FacileTheme.headlineMedium(context, listCupons[index].nomeTipoMovimento.toUpperCase(), align: TextAlign.start),

                    (listCupons[index].idFuncionarioComissionado == '0'
                        ? const SizedBox()
                        : Row(
                            children: [
                              getEspacadorVertical(),
                              SizedBox(
                                width: gDevice.isWindows || gDevice.isTabletAll ? 30 : 30,
                                height: gDevice.isWindows || gDevice.isTabletAll ? 30 : 30,
                                child: ClipOval(
                                  child: SizedBox.fromSize(
                                    size: Size.fromRadius(
                                      getMaxSizedImagemProfile(context),
                                    ),
                                    child: Image.network(
                                      listCupons[index].imagemFuncionarioComissionado,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              FacileTheme.displaySmall(context, listCupons[index].nomeFuncionarioComissionado)
                            ],
                          )),
                  ],
                ),

                /// **************************
                /// Pago com
                ///
//                 Row(
//                   children: [
//                     Row(
//                       children: [
// //                        FacileTheme.displaySmall(context, listCupons[index].nomeSugestaoMeioPagamento),
//                       ],
//                     ),
//                   ],
//                 ),

                /// **************************
                /// Status
                ///
                Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            border: Border.all(
                              color: listCupons[index].status == '1' ? Colors.green : Colors.blue,
                              width: 1,
                            ),
                            color: listCupons[index].status == '1' ? Colors.green : Colors.blue,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: FacileTheme.displaySmall(
                              context,
                              listCupons[index].status == '1' ? 'Pendente' : 'Concluído',
                              invert: true,
                            ),
                          ),
                        ),
                        listCupons[index].temCartao == 'S' ? Icon(getIcon('14'), size: gDevice.isTabletAll ? 48 : 32) : const SizedBox(),
                        listCupons[index].temDinheiro == 'S' ? Icon(getIcon('1'), size: gDevice.isTabletAll ? 48 : 32) : const SizedBox(),
                        listCupons[index].temPix == 'S' ? Icon(getIcon('2'), size: gDevice.isTabletAll ? 48 : 32) : const SizedBox(),
                      ],
                    ),
                  ],
                )
              ],
            ),
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
                                'ID:${listCupons[index].idVenda} / $ind',
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

  void reImprime(context, String m, Venda item) {
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
        if (value != null && value == 'ok') {}
      },
    );
  }

  Future<void> selecionarData(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != date) {
      setState(
        () {
          date = picked;
          load(context);
        },
      );
    }
  }

  ///
  /// Menu geral
  ///

  void menuGeral(context) {
    final action = CupertinoActionSheet(
      title: FacileTheme.headlineSmall(context, 'MENU'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
          },
          child: FacileTheme.displaySmall(context, "LEITURA GERENCIAL"),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
          },
          child: FacileTheme.displaySmall(context, "AUTORIZAR VENDAS NO FILTRO ATUAL"),
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

  ///
  /// Menu do cupom
  ///

  void menuCupom(context, Venda item) {
    ///
    /// flagCancelar:
    /// Pedido (2) em aberto (1) pode cancelar
    /// Diferente de Pedido (2) e concluido (2) pode cancalar (venda, leitura, sangria e suprimento)
    ///
    /// flagAutorizar:
    /// Venda (1) e concluido (2) e não fiscal (0) pode autorizar
    ///

    bool flagCancelar = (item.tipoMovimento == '2' && item.status == '1') || (item.tipoMovimento != '2' && item.status == '2');
    bool flagAutorizar = (item.tipoMovimento == '1' && item.status == '2' && item.idVendaFiscal == '0');

    final action = CupertinoActionSheet(
      title: FacileTheme.headlineSmall(context, 'CUPOM No ${item.idVenda}'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            reImprime(context, 'REIMPRESSÃO ${item.nomeTipoMovimento} No ${item.idVenda}', item);
          },
          child: FacileTheme.displaySmall(context, "VISUALIZAR / REIMPRIMIR"),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
          },
          child: FacileTheme.displaySmall(context, "AUTORIZAR NFCe", disable: !flagAutorizar),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            if (flagCancelar) {
              Navigator.pop(context);
            }
          },
          child: FacileTheme.displaySmall(context, "CANCELAR ${item.nomeTipoMovimento.toUpperCase()}", disable: !flagCancelar),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
          },
          child: FacileTheme.displaySmall(context, "TRANFERIR ${item.nomeTipoMovimento.toUpperCase()} DE DATA"),
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

  ///
  /// Menu filtro
  ///
  ///
  void menuFiltro(context) async {
    if (listCupons.isEmpty) {
      return;
    }

    List<Widget> acts = [];

    acts.add(
      CupertinoActionSheetAction(
        isDefaultAction: true,
        onPressed: () async {
          Navigator.pop(context);
          filtroTipoMovimento = '';
          filtroHora = '';
          filtroidVendaFiscal = '';
          load(context);
        },
        child: FacileTheme.displaySmall(context, filtroHora.isEmpty && filtroTipoMovimento.isEmpty && filtroidVendaFiscal.isEmpty ? 'EXIBINDO TUDO' : 'LIMPAR FILTRO', hard: true),
      ),
    );

    for (var i = 0; i < sumario.length; i++) {
      String s = sumario[i]['quantidade'] + ' ' + sumario[i]['nomeTipoMovimento'] + '(s)';

      acts.add(
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            filtroTipoMovimento = sumario[i]['tipoMovimento'];
            load(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FacileTheme.displaySmall(context, s.toUpperCase()),
              filtroTipoMovimento == sumario[i]['tipoMovimento']
                  ? const Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      );
    }

    acts.add(
      CupertinoActionSheetAction(
        isDefaultAction: true,
        onPressed: () async {
          Navigator.pop(context);
          menuFiltroHora(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FacileTheme.displaySmall(context, 'POR HORA${filtroHora.isEmpty ? '' : (' (Entre $filtroHora:00:00 e $filtroHora:59:59)')}'),
            filtroHora.isNotEmpty
                ? const Icon(
                    Icons.check,
                    color: Colors.green,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );

    for (var i = 0; i < sumarioAutorizacao.length; i++) {
      String s = sumarioAutorizacao[i]['quantidade'] + ' ' + sumarioAutorizacao[i]['nome'] + '(S)';

      acts.add(
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            filtroTipoMovimento = '1';
            filtroidVendaFiscal = sumarioAutorizacao[i]['id'];
            load(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FacileTheme.displaySmall(context, s),
              filtroidVendaFiscal.isNotEmpty
                  ? const Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      );
    }

    final action = CupertinoActionSheet(
      title: FacileTheme.headlineSmall(context, 'FILTRO'),
      actions: acts,
      cancelButton: CupertinoActionSheetAction(
        child: FacileTheme.displaySmall(context, 'CANCELA'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );

    showCupertinoModalPopup(context: context, builder: (context) => action).then((value) {});
  }

  ///
  /// Menu filtro hora
  ///

  void menuFiltroHora(context) async {
    if (listCupons.isEmpty) {
      return;
    }

    List<Widget> acts = [];

    acts.add(
      CupertinoActionSheetAction(
        isDefaultAction: true,
        onPressed: () async {
          Navigator.pop(context);
          filtroTipoMovimento = '';
          filtroHora = '';
          filtroidVendaFiscal = '';
          load(context);
        },
        child: FacileTheme.displaySmall(context, 'LIMPAR FILTRO', hard: true),
      ),
    );

    for (var i = 0; i < sumarioHora.length; i++) {
      String s = sumarioHora[i]['quantidade'] + ' movimento(s) entre ' + sumarioHora[i]['hora'] + ':00:00 e ' + sumarioHora[i]['hora'] + ':59:59';

      acts.add(
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            filtroHora = sumarioHora[i]['hora'];
            load(context);
          },
          child: FacileTheme.displaySmall(context, s),
        ),
      );
    }

    final action = CupertinoActionSheet(
      title: FacileTheme.headlineSmall(context, 'FILTRO'),
      actions: acts,
      cancelButton: CupertinoActionSheetAction(
        child: FacileTheme.displaySmall(context, 'CANCELA'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );

    showCupertinoModalPopup(context: context, builder: (context) => action).then((value) {});
  }
}
