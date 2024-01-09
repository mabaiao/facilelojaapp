import 'dart:convert';
import 'dart:ui';
import 'package:facilelojaapp/dados/produto.dart';
import 'package:facilelojaapp/dados/produtoimagem.dart';
import 'package:facilelojaapp/dados/produtovariacao.dart';
import 'package:facilelojaapp/main.dart';
import 'package:facilelojaapp/util.dart';
import 'package:facilelojaapp/utilpost.dart';
import 'package:facilelojaapp/utiltema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_flutter/qr_flutter.dart';

///
/// Editar imagens do produto
///

class ProdutosImagensAvancadoPage extends StatefulWidget {
  final Produto produto;

  const ProdutosImagensAvancadoPage({
    super.key,
    required this.produto,
  });

  @override
  State<ProdutosImagensAvancadoPage> createState() => _ProdutosImagensAvancadoPageState();
}

class _ProdutosImagensAvancadoPageState extends State<ProdutosImagensAvancadoPage> {
  List<Widget> bg = [];
  String svg = '';
  bool isLoad = true;

  late List<ProdutoImagem> listImagensProduto = List.empty();
  List<ProdutoVariacao> _listProdutoVariacao = List.empty();

  final GlobalKey _globalKey = GlobalKey();

  bool checkDescricaoDetalhada = true;
  bool checkPrecoVarejo = true;
  bool checkPrecoAtacado = true;
  bool checkPrecoPromocional = true;
  List<bool> checkFotos = [];

  @override
  void initState() {
    Iterable va = jsonDecode(widget.produto.variacoes);
    _listProdutoVariacao = va.map((model) => ProdutoVariacao.fromMap(model)).toList();

    load(context);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void load(context) async {
    isLoad = true;
    setState(() {});

    svg = await getFileData('imagens/compartilha.svg');

    Map<String, String> params = {
      'Funcao': 'LeProduto',
      'ID': widget.produto.id,
    };

    var aResult = await facilePostEx(context, 'facileFlutterApp.php', params, showProc: false);

    if (aResult == null) {
    } else if (aResult != null && aResult['Status'] == 'OK') {
      String imagens = aResult['registro']['jsonImagens'];

      if (imagens.isNotEmpty) {
        Iterable lp = jsonDecode(imagens);
        listImagensProduto = lp.map((model) => ProdutoImagem.fromMap(model)).toList();

        checkFotos = List.filled(listImagensProduto.length, true);
      }

      if (mounted) {
        isLoad = false;
        setState(() {});
      }
    } else {
      facileSnackBarError(context, 'Ops!', aResult['Msg']);
    }
  }

  void onFocusKey(context, RawKeyEvent event) {
    var s = event.logicalKey.keyLabel.toString().replaceAll('Numpad ', '').replaceAll('Digit ', '').replaceAll('Key ', '').replaceAll('Space', ' ');

    if (event.runtimeType == RawKeyDownEvent) {
      debugPrint('ProdutosImagensAvancadoPage::onFocusKey::$s');

      if (s == 'Escape') {
        Navigator.pop(context, PopReturns('cancelClick', ''));
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
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: FacileTheme.headlineMedium(context, 'Configure aqui o que será compartilhado')),
        ],
      ),
      SwitchListTile(
        title: const Text('Descrição detalhada'),
        value: checkDescricaoDetalhada,
        onChanged: (bool value) {
          setState(() {
            checkDescricaoDetalhada = value;
          });
        },
        secondary: const Icon(Icons.share_outlined),
      ),
      SwitchListTile(
        title: const Text('Preço varejo'),
        value: checkPrecoVarejo,
        onChanged: (bool value) {
          setState(() {
            checkPrecoVarejo = value;
          });
        },
        secondary: const Icon(Icons.share_outlined),
      ),
      SwitchListTile(
        title: const Text('Preço atacado'),
        value: checkPrecoAtacado,
        onChanged: (bool value) {
          setState(() {
            checkPrecoAtacado = value;
          });
        },
        secondary: const Icon(Icons.share_outlined),
      ),
      SwitchListTile(
        title: const Text('Preço promocional'),
        value: checkPrecoPromocional,
        onChanged: (bool value) {
          setState(() {
            checkPrecoPromocional = value;
          });
        },
        secondary: const Icon(Icons.share_outlined),
      ),
    ];

    for (var item in listImagensProduto) {
      w1.add(
        SwitchListTile(
          title: Text('Foto ${item.id}'),
          value: checkFotos[int.parse(item.id) - 1],
          onChanged: (bool value) {
            setState(() {
              checkFotos[int.parse(item.id) - 1] = value;
            });
          },
          secondary: const Icon(Icons.share_outlined),
        ),
      );
    }

    w1.add(
      ElevatedButtonEx(
        caption: 'COMPARTILHAR',
        icon: const Icon(Icons.share_outlined),
        onPressed: () async {
          showLoading(context);
          final boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
          final image = await boundary?.toImage(pixelRatio: 6.0);
          final byteData = await image?.toByteData(format: ImageByteFormat.png);
          final imageBytes = byteData?.buffer.asUint8List();
          compartilha(imageBytes, text: gParametros.compartilhamentoTextoPadrao);
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(),
      ),
    );

    w1.add(
      Icon(
        Icons.arrow_downward_sharp,
        size: 80,
        color: FacileTheme.getColorHard(context),
      ),
    );

    w1.add(
      getEspacadorTriplo(),
    );

    List<Widget> wimgs = [];

    int ind = 0;
    for (var item in listImagensProduto) {
      wimgs.add(
        checkFotos[ind]
            ? Container(
                decoration: const BoxDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Image.network(
                        item.url,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: RotatedBox(
                          quarterTurns: -1,
                          child: FacileTheme.headlineSmall(context, gUsuario.nomeLojaFisica, disable: true),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox(),
      );

      ind++;
    }

    Widget wcardimagens = Column(
      children: wimgs,
    );

    List<Widget> w2 = [
      RepaintBoundary(
        key: _globalKey,
        child: Container(
          color: (gTema.modo == 'dark' ? null : Colors.white),
          child: Column(
            children: [
              getEspacadorTriplo(),
              getEspacadorTriplo(),
              getEspacadorTriplo(),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 90,
                          height: 90,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: FacileTheme.getColorButton(context),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: gDevice.isTabletAll ? 25 : 25,
                                  color: FacileTheme.getColorHard(context),
                                  offset: const Offset(0, 0),
                                )
                              ],
                            ),
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                size: Size.fromRadius(
                                  getMaxSizedImagemProfile(context) * 4,
                                ),
                                child: Image.network(
                                  gUsuario.imagem,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        FacileTheme.displaySmall(context, gUsuario.primeiroNome),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      children: [
                        FacileTheme.headlineSmall(context, gUsuario.nomeLojaFisica),
                        QrImageView(
                          data: 'www.facileloja.com.br/catalogo/${gUsuario.subdominio}',
                          version: QrVersions.auto,
                          size: 100.0,
                          eyeStyle: QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: FacileTheme.getColorHard(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              getEspacadorDuplo(),
              const Divider(),
              getEspacadorDuplo(),
              Row(
                children: [
                  Expanded(child: FacileTheme.headlineMedium(context, widget.produto.nome)),
                ],
              ),
              checkDescricaoDetalhada
                  ? Row(
                      children: [
                        Expanded(child: FacileTheme.displaySmall(context, widget.produto.descricaoDetalhada)),
                      ],
                    )
                  : const SizedBox(),
              leVariacoes(context),
              getEspacadorTriplo(),
              wcardimagens,
              getEspacadorTriplo(),
              getEspacadorTriplo(),
              getEspacadorTriplo(),
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
          appBar: getCupertinoAppBar(context, 'PRODUTO ID ${widget.produto.id}', []),
          floatingActionButton: getFormFloatingActionButtonList([], isLoad: isLoad),
          body: SingleChildScrollView(
            child: getStackCupertino(
              context,
              bg,
              getBody(
                context,
                w1,
                w2,
                flex1: 5,
                flex2: 5,
                mainAxisAlignment: MainAxisAlignment.start,
                delay: false,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget leVariacoes(context) {
    List<Widget> w = [];

    for (var item in _listProdutoVariacao) {
      w.add(
        ListTile(
          leading: FacileTheme.headlineMedium(context, '${item.nomeCampoVarA} ${item.nomeCampoVarB}'),
        ),
      );
      w.add(
        ListTile(
          minVerticalPadding: 1,
          leading: Icon(CupertinoIcons.barcode, size: 32, color: FacileTheme.getColorPrimary(context)),
          title: FacileTheme.displayMedium(context, item.eanSistema, align: TextAlign.right),
          dense: true,
        ),
      );
      w.add(
        item.eanFornecedor.isEmpty
            ? const SizedBox()
            : ListTile(
                minVerticalPadding: 1,
                leading: Icon(CupertinoIcons.barcode, size: 32, color: FacileTheme.getColorPrimary(context)),
                title: FacileTheme.displayMedium(context, item.eanFornecedor.isEmpty ? '-' : item.eanFornecedor, align: TextAlign.right),
                dense: true,
              ),
      );
      w.add(
        checkPrecoVarejo
            ? ListTile(
                minVerticalPadding: 1,
                leading: Icon(CupertinoIcons.money_dollar, size: 32, color: FacileTheme.getColorPrimary(context)),
                title: FacileTheme.displaySmall(context, 'Varejo', align: TextAlign.right, disable: true),
                trailing: FacileTheme.headlineMedium(context, item.precoVendaVarejoF),
                dense: true,
              )
            : const SizedBox(),
      );
      w.add(
        checkPrecoAtacado
            ? ListTile(
                minVerticalPadding: 1,
                leading: Icon(CupertinoIcons.money_dollar, size: 32, color: FacileTheme.getColorPrimary(context)),
                title: FacileTheme.displaySmall(context, 'Atacado', align: TextAlign.right, disable: true),
                trailing: FacileTheme.headlineMedium(context, item.precoVendaAtacadoF),
                dense: true,
              )
            : const SizedBox(),
      );
      w.add(
        checkPrecoPromocional
            ? ListTile(
                minVerticalPadding: 1,
                leading: Icon(CupertinoIcons.money_dollar, size: 32, color: FacileTheme.getColorPrimary(context)),
                title: FacileTheme.displaySmall(context, 'Promocional', align: TextAlign.right, disable: true),
                trailing: FacileTheme.headlineMedium(context, item.precoVendaPromocionalF),
                dense: true,
              )
            : const SizedBox(),
      );
      w.add(
        const Divider(),
      );
    }

    return Column(children: w);
  }
}
