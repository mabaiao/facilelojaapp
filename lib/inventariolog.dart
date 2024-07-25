import 'dart:async';
import 'dart:io';

import 'package:facilelojaapp/main.dart';
import 'package:facilelojaapp/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/services.dart';
import 'dados/inventariolog.dart';
import 'utilpost.dart';
import 'utiltema.dart';

class InventarioLogPage extends StatefulWidget {
  final int idInventario;

  const InventarioLogPage({super.key, required this.idInventario});

  @override
  State<InventarioLogPage> createState() => _InventarioLogState();
}

class _InventarioLogState extends State<InventarioLogPage> {
  List<Widget> bg = [];
  List<InventarioLog> logs = [];
  bool isLoad = true;

  @override
  void initState() {
    super.initState();
    load(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void load(context) async {
    Timer(const Duration(milliseconds: 100), () {
      loadLogs(context);
    });
  }

  Future<void> loadLogs(context) async {
    Map<String, String> params = {
      'idInventario': widget.idInventario.toString(),
    };

    FacileResponse response = await facileRouter(context, '/gadget/listarinventariolog', params, showProc: true, addParam: true);

    if (response.isOk()) {
      Iterable v = await response.getMapList('inventariolog');
      logs = v.map((model) => InventarioLog.fromMap(model)).toList();

      setState(() {
        isLoad = false;
      });
    } else {}
  }

  void onFocusKey(context, KeyEvent event) {
    var s = event.logicalKey.keyLabel.toString().replaceAll('Numpad ', '').replaceAll('Digit ', '').replaceAll('Key ', '').replaceAll('Space', ' ');

    if (event.runtimeType == KeyDownEvent) {
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

    List<FormFloatingActionButton> listFloatingActionButton = [];

    if (gDevice.isWindows) {
      listFloatingActionButton.add(FormFloatingActionButton(
          icon: CupertinoIcons.chevron_down,
          caption: getTextWindowsKey((gDevice.isWindows ? 'VOLTAR' : ''), 'ESC'),
          onTap: () {
            Navigator.pop(context);
          }));
    }

    List<Widget> w2 = [
      SizedBox(
        height: getMaxSizedBoxHeight(context) *
            (gDevice.isWindows
                ? 0.95
                : gDevice.isTabletLandscape
                    ? 0.85
                    : gDevice.isPhoneAll
                        ? 0.85
                        : 0.9),
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 400),
          itemCount: logs.length,
          itemBuilder: (context, index) {
            InventarioLog prod = logs[index];

            return Container(
              height: gDevice.isTabletAll ? 110 : 130,
              margin: EdgeInsets.only(
                left: 8,
                top: gDevice.isTabletAll ? 5 : 10,
                right: 8,
              ),
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: FacileTheme.getColorPrimary(context),
                  width: 1,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                //color: (widget.idVenda.isNotEmpty && _cupom.itens[index].daVez) ? null : Theme.of(context).colorScheme.surface,
              ),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: gDevice.isTabletAll ? 220 : 150,
                        height: 28,
                        decoration: BoxDecoration(
                          color: FacileTheme.getColorHard(context),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: FacileTheme.displaySmall(context, prod.dataCadastro, invert: true),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FacileTheme.headlineMedium(context, prod.codigo),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: FacileTheme.displaySmall(context, prod.nome, align: TextAlign.left),
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
                          ClipOval(
                            child: Container(
                              color: FacileTheme.getColorHard(context),
                              width: 70,
                              height: 70,
                              alignment: Alignment.center,
                              child: Text(
                                prod.quantidade.toStringAsFixed(0),
                                style: const TextStyle(
                                  color: Colors.white, // Cor do texto
                                  fontSize: 30, // Tamanho do texto
                                  fontWeight: FontWeight.bold,
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
            );
          },
        ),
      ),
    ];
    List<Widget> w1 = [];

    if (gDevice.isTabletLandscape) {
      w1 = [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FacileTheme.headlineLarge(context, 'COLETAS'),
          ],
        ),
      ];
    }

    int coletas = logs.length;

    ///
    /// go
    ///
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        onFocusKey(context, event);
        setState(() {});
        return KeyEventResult.ignored;
      },
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: getFormFloatingActionButtonList(listFloatingActionButton, isLoad: isLoad),
          appBar: getCupertinoAppBar(context, 'MINHAS COLETAS ($coletas)', [], isBack: true),
          body: getStackCupertino(
            context,
            bg,
            getBody(context, w1, w2, flex1: 5, flex2: 5, delay: false),
          ),
        ),
      ),
    );
  }
}
