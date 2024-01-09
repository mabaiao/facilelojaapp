import 'dart:developer';

import 'package:facilelojaapp/main.dart';
import 'package:facilelojaapp/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// **************************
/// ProdutosPesquisa
///

class ProdutosPesquisaPage extends StatefulWidget {
  final String param;

  const ProdutosPesquisaPage({super.key, required this.param});

  @override
  State<ProdutosPesquisaPage> createState() => _ProdutosPesquisaState();
}

class _ProdutosPesquisaState extends State<ProdutosPesquisaPage> {
  final TextEditingController controllerBuscaValidador = TextEditingController();
  String svg = '';
  String stringPesquisa = '';
  List<Widget> bg = [];

  @override
  void initState() {
    super.initState();
    controllerBuscaValidador.text = widget.param;
    load(context);
  }

  void load(context) async {
    svg = await getFileData('imagens/search.svg');
    setState(() {});
  }

  void onFocusKey(context, RawKeyEvent event) {
    var s = event.logicalKey.keyLabel.toString().replaceAll('Numpad ', '').replaceAll('Digit ', '').replaceAll('Key ', '').replaceAll('Space', ' ');

    if (event.runtimeType == RawKeyDownEvent) {
      log('ProdutosPage::onFocusKey::$s');

      if (s == 'Enter' && stringPesquisa.isNotEmpty) {
        controllerBuscaValidador.text = stringPesquisa;
        Navigator.pop(context, PopReturns('searchClick', controllerBuscaValidador.text.trim()));
      } else if (' 01234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ'.contains(s)) {
        stringPesquisa += s;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (bg.isEmpty) {
      bg = getBackground(context, minimize: true);
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
      getEspacadorDuplo(),
      TextField(
        textInputAction: TextInputAction.search,
        autofocus: (gDevice.isTabletAll || gDevice.isWindows ? true : true),
        onSubmitted: (value) {
          Navigator.pop(context, PopReturns('searchClick', controllerBuscaValidador.text.trim()));
        },
        controller: controllerBuscaValidador,
        keyboardType: TextInputType.text,
        style: const TextStyle(fontSize: 20),
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.keyboard,
            size: 32,
          ),
          hintText: 'Digite ou passe o leitor...',
          suffixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.close,
                  size: 32,
                ),
                onPressed: () {
                  controllerBuscaValidador.text = '';
                  stringPesquisa = '';
                  setState(() {});
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.search,
                  size: 32,
                ),
                onPressed: () {
                  Navigator.pop(context, PopReturns('searchClick', controllerBuscaValidador.text.trim()));
                  load(context);
                },
              ),
            ],
          ),
        ),
      ),
    ];

    return Focus(
      autofocus: true,
      onKey: (node, event) {
        onFocusKey(context, event);
        return KeyEventResult.ignored;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: getCupertinoAppBar(context, 'PESQUISA DE PRODUTOS', []),
          body: getStackCupertino(
            context,
            bg,
            getBody(
              context,
              w1,
              w2,
              flex1: 5,
              flex2: 5,
              mainAxisAlignment: MainAxisAlignment.start,
            ),
          ),
        ),
      ),
    );
  }
}
