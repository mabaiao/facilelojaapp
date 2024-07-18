import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:facilelojaapp/main.dart';
// import 'package:facilelojaapp/produtos.dart';
import 'package:facilelojaapp/profile.dart';
import 'package:facilelojaapp/util.dart';
import 'package:facilelojaapp/utiltema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

//import 'caixa.dart.txt';
// import 'filaatendimento.dart';
import 'entradaprodutos.dart';
import 'inventario.dart';
import 'terminalconsulta.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool isLoad = false;
  List<Widget> bg = [];

  @override
  void initState() {
    super.initState();
    load(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void load(context) async {}

  void onFocusKey(context, RawKeyEvent event) {
    var s = event.logicalKey.keyLabel.toString().replaceAll('Numpad ', '').replaceAll('Digit ', '').replaceAll('Key ', '').replaceAll('Space', ' ');

    if (event.runtimeType == RawKeyDownEvent) {
      //log('AberturaPage::onFocusKey::$s');

      if (s == 'Escape') {
        Navigator.pop(context);
      }
      if (s == 'F2') {
        //goCaixa(context, CaixaModo.venda);
      }
      if (s == 'F3') {
        menuPedido(context);
      }
      if (s == 'F4') {
        goProdutos(context);
      }
      if (s == 'F6') {
        consultaPrecos(context);
      }
      if (s == 'F7') {
        gTema.changeColor(context);
      }
      if (s == 'F8') {
        gTema.changeTheme(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (bg.isEmpty) {
      bg = getBackground(context);
    }

    List<FormFloatingActionButton> listFloatingActionButton = [];

    if (gDevice.isWindows) {
      listFloatingActionButton.add(FormFloatingActionButton(
          icon: CupertinoIcons.back,
          caption: getTextWindowsKey((gDevice.isWindows ? 'VOLTAR' : ''), 'ESC'),
          onTap: () {
            Navigator.pop(context);
          }));
    }

    List<FormIconButton> listIconButton = [];

    if (gDevice.isWindows) {
      listIconButton.add(FormIconButton(
        icon: CupertinoIcons.printer,
        caption: getTextWindowsKey(gDevice.isPhoneAll ? '' : 'Scanner', 'F4'),
        onTap: () {
          if (gDevice.printServiceRunning) {
            gDevice.stopPrintService(context);
          } else {
            gDevice.startPrintService(context);
          }
          setState(() {});
        },
      ));
    }

    List<Widget> w1 = [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  blurRadius: gDevice.isTabletAll ? 18 : 18,
                  color: FacileTheme.getColorPrimary(context),
                  offset: const Offset(0, 0),
                )
              ],
            ),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () async {
                showCupertinoModalBottomSheet(
                  duration: getCupertinoModalBottomSheetDuration(),
                  context: context,
                  builder: (context) => const ProfilePage(),
                ).then(
                  (value) {
                    setState(() {});
                  },
                );
              },
              child: Hero(
                tag: 'imageProfile',
                child: ClipOval(
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(
                      getMaxSizedImagemProfile(context),
                    ),
                    child: Image.network(
                      gFuncionario!.imagem,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          getEspacadorVertical(),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    FacileTheme.headlineMedium(context, 'Olá ${gFuncionario!.nome}'),
                  ],
                ),
                Row(
                  children: [
                    FacileTheme.displaySmall(context, gCargo!.nome),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ];

    List<FormIconButton> listFormIconButton = [];

    if (gDevice.isAndroid && (gCargo!.sigla == 'adm' || gCargo!.sigla == 'ads' || gCargo!.sigla == 'ger')) {
      listFormIconButton.add(
        FormIconButton(
          caption: getTextWindowsKey('Dash', 'F1'),
          icon: Icons.dashboard_outlined,
          onTap: () {},
        ),
      );
    }

    if (gCargo!.sigla == 'adm' || gCargo!.sigla == 'ads' || gCargo!.sigla == 'ger' || gCargo!.sigla == 'ope') {
      listFormIconButton.add(
        FormIconButton(
          caption: getTextWindowsKey('Caixa', 'F2'),
          icon: Icons.point_of_sale_outlined,
          onTap: () {
            menuCaixa(context);
          },
        ),
      );
    }

    if (gCargo!.sigla == 'adm' || gCargo!.sigla == 'ads' || gCargo!.sigla == 'ger' || gCargo!.sigla == 'ven') {
      listFormIconButton.add(
        FormIconButton(
          caption: getTextWindowsKey('Pedidos', 'F3'),
          icon: Icons.app_registration_outlined,
          onTap: () {
            menuPedido(context);
          },
        ),
      );
    }

    // listFormIconButton.add(
    //   FormIconButton(
    //     caption: getTextWindowsKey('Mesas', ''),
    //     icon: Icons.restaurant_menu_outlined,
    //     onTap: () {},
    //   ),
    // );
    // listFormIconButton.add(
    //   FormIconButton(
    //     caption: getTextWindowsKey('Delivery', ''),
    //     icon: Icons.delivery_dining_outlined,
    //     onTap: () {},
    //   ),
    // );

    listFormIconButton.add(
      FormIconButton(
        caption: getTextWindowsKey('Produtos', 'F4'),
        icon: CupertinoIcons.barcode,
        onTap: () {
          goProdutos(context);
        },
      ),
    );

    if (gDevice.isAndroid && (gCargo!.sigla == 'adm' || gCargo!.sigla == 'ads' || gCargo!.sigla == 'ger' || gCargo!.sigla == 'inv')) {
      //if ((gCargo!.sigla == 'adm' || gCargo!.sigla == 'ads' || gCargo!.sigla == 'ger' || gCargo!.sigla == 'inv')) {
      listFormIconButton.add(
        FormIconButton(
          caption: getTextWindowsKey('Inventário', 'F5'),
          icon: Icons.qr_code_scanner_sharp,
          onTap: () {
            inventario(context);
          },
        ),
      );
    }

    if (gDevice.isAndroid && (gCargo!.sigla == 'adm' || gCargo!.sigla == 'ads' || gCargo!.sigla == 'ger' || gCargo!.sigla == 'inv')) {
      listFormIconButton.add(
        FormIconButton(
          caption: getTextWindowsKey('Entrada produtos', 'F5'),
          icon: Icons.inventory_outlined,
          onTap: () {
            entradaprodutos(context);
          },
        ),
      );
    }

    // listFormIconButton.add(
    //   FormIconButton(
    //     caption: getTextWindowsKey('Impressora', 'F8'),
    //     icon: Icons.print_outlined,
    //     onTap: () {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => const ConfiguraImpressoraExPage(),
    //         ),
    //       ).then((value) {});
    //     },
    //   ),
    // );

    listFormIconButton.add(
      FormIconButton(
        caption: getTextWindowsKey('Consulta de Preços', 'F6'),
        icon: Icons.search_outlined,
        onTap: () {
          consultaPrecos(context);
        },
      ),
    );

    listFormIconButton.add(
      FormIconButton(
        caption: getTextWindowsKey('Cor', 'F7'),
        icon: Icons.color_lens_outlined,
        onTap: () {
          gTema.changeColor(context);
        },
      ),
    );

    listFormIconButton.add(
      FormIconButton(
        caption: getTextWindowsKey('Escuro/Claro', 'F8'),
        icon: Icons.mode_night_outlined,
        onTap: () {
          gTema.changeTheme(context);
        },
      ),
    );

    // listFormIconButton.add(
    //   FormIconButton(
    //     caption: getTextWindowsKey('Configurações', 'F9'),
    //     icon: Icons.settings_outlined,
    //     onTap: () {},
    //   ),
    // );

    List<Widget> w2 = [
      SizedBox(
        width: getMaxSizedBoxWidth(context),
        height: getMaxSizedBoxHeight(context) *
            (gDevice.isTabletLandscape
                ? 0.85
                : gDevice.isWindows
                    ? 1
                    : gDevice.isPhoneSmall
                        ? 0.75
                        : 0.8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 15,
                crossAxisCount: gDevice.isPhoneAll
                    ? 2
                    : gDevice.isTabletPortrait
                        ? 3
                        : 3,
                mainAxisSpacing: 5,
                mainAxisExtent: gDevice.isTabletLandscape ? 170 : 170,
              ),
              itemCount: listFormIconButton.length,
              itemBuilder: (BuildContext context, int index) {
                var boxShadow = const [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.transparent,
                    offset: Offset(3, 3),
                  )
                ];

                Widget card = Card(
                  shadowColor: Colors.transparent,
                  elevation: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FacileTheme.displaySmall(context, listFormIconButton[index].caption),
                      Hero(
                        tag: 'heroPad$index',
                        child: Icon(
                          listFormIconButton[index].icon,
                          size: 60,
                        ),
                      ),
                    ],
                  ),
                );

                if (index == 0 && gDevice.isAndroid && (gCargo!.sigla == 'adm' || gCargo!.sigla == 'ads' || gCargo!.sigla == 'ger')) {
                  var gradient = const LinearGradient(
                    colors: [
                      Colors.orange,
                      Colors.red,
                      Colors.pink,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  );

                  card = Container(
                    padding: getPaddingDefault(context),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: gradient,
                      boxShadow: boxShadow,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FacileTheme.displaySmall(context, listFormIconButton[index].caption),
                        Hero(
                          tag: 'heroPad$index',
                          child: Icon(
                            listFormIconButton[index].icon,
                            size: 60,
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate(
                        onPlay: (controller) => controller.repeat(),
                      )
                      .shimmer(delay: 1500.ms, duration: 2000.ms);
                }

                return SizedBox(
                  width: getMaxSizedBoxWidth(context) * 0.2,
                  height: getMaxSizedBoxHeight(context) * 0.5,
                  child: InkWell(
                    onTap: listFormIconButton[index].onTap,
                    child: card,
                  ),
                );
              }),
        ),
      ),
    ];

    log('gDevice.printServiceRunning XXXXXXXXXXXXXXXXX ${gDevice.printServiceRunning}');

    return Focus(
      autofocus: true,
      onKey: (node, event) {
        onFocusKey(context, event);
        return KeyEventResult.ignored;
      },
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: SafeArea(
          child: Scaffold(
            floatingActionButton: getFormFloatingActionButtonList(listFloatingActionButton),
            appBar: getCupertinoAppBar(context, 'MENU', listIconButton, isBack: true, addClose: true),
            body: Stack(
              children: [
                getStackCupertino(
                  context,
                  getBackground(context),
                  getBody(context, w1, w2, flex1: 4, flex2: 6, mainAxisAlignment: MainAxisAlignment.center),
                ),
                gDevice.isWindows && gUsuario.terminalImpressao == 'S'
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: AvatarGlow(
                              glowColor: gDevice.printServiceRunning ? FacileTheme.getColorHard(context) : Colors.grey,
                              endRadius: 60,
                              duration: const Duration(milliseconds: 1000),
                              repeat: true,
                              showTwoGlows: true,
                              repeatPauseDuration: const Duration(milliseconds: 100),
                              child: Material(
                                elevation: 8.0,
                                shape: const CircleBorder(),
                                child: CircleAvatar(
                                  backgroundColor: gDevice.printServiceRunning ? FacileTheme.getColorHard(context) : Colors.grey,
                                  radius: 30,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        (gDevice.printServiceRunning ? Icons.print_outlined : Icons.print_disabled_outlined),
                                        size: 25,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void goCaixa(context, CaixaModo modo) {
  // Navigator.push(
  //   context,
  //   CupertinoPageRoute(
  //     builder: (context) => CaixaPage(modo: modo),
  //   ),
  // ).then((value) {
  //   //log('value=$value');
  // });
  // }

  void goAtendimento(context) {
    // Navigator.push(
    //   context,
    //   CupertinoPageRoute(
    //     builder: (context) => const FilaAtendimentoPage(),
    //   ),
    // ).then((value) {
    //   //log('value=$value');
    // });
  }

  void goProdutos(context) {
    // Navigator.push(
    //   context,
    //   CupertinoPageRoute(
    //     builder: (context) => const ProdutosPage(modo: ProdutosModo.editar, find: ''),
    //   ),
    // ).then((value) {
    //   //log('value=$value');
    // });
  }

  void inventario(context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const InventarioPage(),
      ),
    ).then((value) {
      //log('value=$value');
    });
  }

  void entradaprodutos(context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const EntradaProdutosPage(),
      ),
    ).then((value) {
      //log('value=$value');
    });
  }

  void consultaPrecos(context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const ConsultaPrecosPage(),
      ),
    ).then((value) {
      //log('value=$value');
    });
  }

  void menuPedido(context) {
    // final action = CupertinoActionSheet(
    //   title: FacileTheme.headlineSmall(context, 'SELECIONE A FORMA DE ATENDIMENTO'),
    //   actions: <Widget>[
    //     CupertinoActionSheetAction(
    //       isDefaultAction: true,
    //       onPressed: () async {
    //         Navigator.pop(context);
    //         goCaixa(context, CaixaModo.pedidoLoja);
    //       },
    //       child: Column(
    //         children: [
    //           const Icon(
    //             Icons.store_outlined,
    //             size: 48,
    //           ),
    //           FacileTheme.displayMedium(context, "ATENDIMENTO LOJA"),
    //         ],
    //       ),
    //     ),
    //     CupertinoActionSheetAction(
    //       isDefaultAction: true,
    //       onPressed: () async {
    //         Navigator.pop(context);
    //         goCaixa(context, CaixaModo.pedidoZap);
    //       },
    //       child: Column(
    //         children: [
    //           const Icon(
    //             Icons.chat_outlined,
    //             size: 48,
    //           ),
    //           FacileTheme.displayMedium(context, "ATENDIMENTO WHATSAPP"),
    //         ],
    //       ),
    //     ),
    //   ],
    //   cancelButton: CupertinoActionSheetAction(
    //     child: FacileTheme.displaySmall(context, 'CANCELA'),
    //     onPressed: () {
    //       Navigator.pop(context);
    //     },
    //   ),
    // );

    // showCupertinoModalPopup(context: context, builder: (context) => action).then((value) {});
  }

  void menuCaixa(context) {
    // final action = CupertinoActionSheet(
    //   title: FacileTheme.headlineSmall(context, 'SELECIONE A FORMA DE VENDA'),
    //   actions: <Widget>[
    //     CupertinoActionSheetAction(
    //       isDefaultAction: true,
    //       onPressed: () async {
    //         Navigator.pop(context);
    //         goCaixa(context, CaixaModo.venda);
    //       },
    //       child: Column(
    //         children: [
    //           const Icon(
    //             Icons.person_2_outlined,
    //             size: 48,
    //           ),
    //           FacileTheme.displayMedium(context, "DIRETO COM CLIENTE"),
    //         ],
    //       ),
    //     ),
    //     CupertinoActionSheetAction(
    //       isDefaultAction: true,
    //       onPressed: () async {
    //         Navigator.pop(context);
    //         goAtendimento(context);
    //       },
    //       child: Column(
    //         children: [
    //           const Icon(
    //             Icons.groups_2_outlined,
    //             size: 48,
    //           ),
    //           FacileTheme.displayMedium(context, "FILA DE ATENDIMENTO"),
    //         ],
    //       ),
    //     ),
    //   ],
    //   cancelButton: CupertinoActionSheetAction(
    //     child: FacileTheme.displaySmall(context, 'CANCELA'),
    //     onPressed: () {
    //       Navigator.pop(context);
    //     },
    //   ),
    // );

    // showCupertinoModalPopup(context: context, builder: (context) => action).then((value) {});
  }
}
