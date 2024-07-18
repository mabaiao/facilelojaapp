import 'dart:async';
import 'dart:developer';

import 'package:facilelojaapp/dados/produtovariacao.dart';
import 'package:facilelojaapp/main.dart';
import 'package:facilelojaapp/util.dart';
import 'package:facilelojaapp/utiltema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'dados/produto.dart';
import 'utilpost.dart';

class ConsultaPrecosPage extends StatefulWidget {
  const ConsultaPrecosPage({super.key});

  @override
  State<ConsultaPrecosPage> createState() => _ConsultaPrecosState();
}

class _ConsultaPrecosState extends State<ConsultaPrecosPage> {
  List<Widget> bg = [];
  String svg = '';
  String svgOk = '';

  bool isLoad = true;
  late String codigo = '';
  late String nomeProduto = '';
  late String precoProduto = '';
  bool exibindo = false;
  bool piscando = false;

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
    svg = await getFileData('imagens/produto.svg');
    svgOk = await getFileData('imagens/ok.svg');

    setState(() {
      isLoad = false;
    });
  }

  void onFocusKey(context, KeyEvent event) {
    var s = event.logicalKey.keyLabel.toString().replaceAll('Numpad ', '').replaceAll('Digit ', '').replaceAll('Key ', '').replaceAll('Space', ' ');

    if (event.runtimeType == KeyDownEvent) {
      debugPrint('RegistroPage::onFocusKey::$s');

      if (s == 'Escape') {
        Navigator.pop(context);
      } else if (s == 'Enter' && codigo.isNotEmpty) {
        buscarProdutoPorEan(context);
      } else if (' 01234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ'.contains(s)) {
        if (!exibindo) {
          codigo += s;
          setState(() {});
        }
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

    List<Widget> w1 = [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FacileTheme.headlineLarge(context, ''),
        ],
      ),
      SizedBox(
        height: getMaxSizedBoxLottieHeight(context),
        child: svg.isEmpty
            ? const SizedBox()
            : SizedBox(
                child: SvgPicture.string(
                exibindo ? svgOk.replaceAll('#B0BEC5', gTema.colorArray[gTema.cor].toHex().replaceAll('#ff', '#')) : svg.replaceAll('#B0BEC5', gTema.colorArray[gTema.cor].toHex().replaceAll('#ff', '#')),
              )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .move(duration: 1000.ms)),
      ),
    ];

    Widget wnome =
        FacileTheme.headlineLarge(context, 'PASSE O LEITOR', fontSize: gDevice.isTabletAll ? 40 : 30).animate(onPlay: (controller) => controller.repeat()).shimmer(delay: 400.ms, duration: 1000.ms, color: Colors.grey);
    Widget wpreco = const SizedBox();

    if (exibindo) {
      if (piscando) {
        wnome = FacileTheme.headlineLarge(context, nomeProduto, fontSize: gDevice.isTabletAll ? 40 : 30)
            .animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            )
            .fadeOut(curve: Curves.easeInOut);
        wpreco = FacileTheme.headlineLarge(context, precoProduto, fontSize: gDevice.isTabletAll ? 100 : 70)
            .animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            )
            .fadeOut(curve: Curves.easeInOut);
      } else {
        wnome = FacileTheme.headlineLarge(context, nomeProduto, fontSize: gDevice.isTabletAll ? 40 : 30).animate(onPlay: (controller) => controller.repeat()).shimmer(delay: 400.ms, duration: 1000.ms, color: Colors.grey);
        wpreco =
            FacileTheme.headlineLarge(context, precoProduto, fontSize: gDevice.isTabletAll ? 100 : 70).animate(onPlay: (controller) => controller.repeat()).shimmer(delay: 400.ms, duration: 1000.ms, color: Colors.grey);
      }
    }

    List<Widget> w2 = [
      wnome,
      exibindo ? const SizedBox() : FacileTheme.headlineLarge(context, codigo),
      wpreco,
    ];

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
          appBar: getCupertinoAppBar(context, 'CONSULTA DE PREÇOS', [], isBack: true),
          body: getStackCupertinoAlca(
            context,
            bg,
            getBody(context, w1, w2, flex1: 5, flex2: 5, delay: false),
          ),
        ),
      ),
    );
  }

  Future<void> buscarProdutoPorEan(context) async {
    if (codigo.isEmpty || exibindo) {
      return;
    }
    if (codigo.length == 12) {
      codigo = '0$codigo';
    }

    log('buscando...$codigo');

    Map<String, String> params = {
      'busca': codigo,
    };

    FacileResponse response = await facileRouter(context, '/gadget/consultapreco', params, showProc: true, addParam: true);

    if (response.isOk()) {
      Iterable v;
      v = await response.getMap('produto');
      Produto produto = Produto.fromMap(v.first);

      v = await response.getMap('variacao');
      ProdutoVariacao variacao = ProdutoVariacao.fromMap(v.first);

      gDevice.beep();

      nomeProduto = produto.nome;
      precoProduto = variacao.preco.toStringAsFixed(2);

      Timer(3000.ms, () {
        if (mounted) {
          setState(() {
            piscando = true;
          });
        }
      });

      Timer(5000.ms, () {
        if (mounted) {
          setState(() {
            exibindo = false;
            piscando = false;
          });
        }
      });

      if (mounted) {
        setState(() {
          exibindo = true;
        });
      }
    } else {
      gDevice.beepErr();
      facileSnackBarError(context, 'Ops!', response.descricao);
    }

    if (mounted) {
      setState(() {
        codigo = '';
      });
    }
  }
}
