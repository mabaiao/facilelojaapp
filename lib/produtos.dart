import 'dart:async';
import 'dart:developer';
import 'package:facilelojaapp/dados/categoria.dart';
import 'package:facilelojaapp/dados/produto.dart';
import 'package:facilelojaapp/main.dart';
import 'package:facilelojaapp/produtosedita.dart';
import 'package:facilelojaapp/produtosnovo.dart';
import 'package:facilelojaapp/produtospesquisa.dart';
import 'package:facilelojaapp/util.dart';
import 'package:facilelojaapp/utilpost.dart';
import 'package:facilelojaapp/utiltema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:highlightable/highlightable.dart';
import 'package:badges/badges.dart' as badges;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

/// **************************
/// Produtos
///

enum ProdutosModo {
  editar,
  selecionarUnico,
  selecionarVarios,
}

class ProdutosPage extends StatefulWidget {
  final ProdutosModo modo;
  final String find;

  const ProdutosPage({super.key, required this.modo, required this.find});

  @override
  State<ProdutosPage> createState() => _ProdutosState();
}

class _ProdutosState extends State<ProdutosPage> {
  bool isLoad = true;

  final FocusNode controllerListNode = FocusNode();
  final ScrollController controllerList = ScrollController();

  final TextEditingController controllerBuscaValidador = TextEditingController();
  String idsCategorias = '';

  String svg = '';
  String svgSemFoto = '';
  String stringPesquisa = '';

  late List<Categoria> listCategorias = List.empty();
  late List<Produto> listProdutos = List.empty();
  int listProdutosQuantidade = 0;
  int totalGeralProdutos = 0;
  int totalProdutosNoFiltro = 0;

  double tamanhoFonte = 0;
  bool negritoFonte = false;

  @override
  void initState() {
    super.initState();

    stringPesquisa = '';
    controllerBuscaValidador.text = widget.find;

    loadSvg(context);
    load(context);
  }

  void scrollToTop() {
    Timer(200.ms, () {
      if (controllerList.hasClients) {
        if (gDevice.isWindows) {
          controllerListNode.requestFocus();
        }
        controllerList.jumpTo(0);
      }
    });
  }

  void loadSvg(context) async {
    svg = await getFileData('imagens/search.svg');
    svgSemFoto = await getFileData('imagens/semfoto.svg');
  }

  void load(context) async {
    isLoad = true;
    setState(() {});

    controllerBuscaValidador.text = controllerBuscaValidador.text.trim();

    Map<String, String> params = {
      'Funcao': 'ListagemProdutos',
      'Modo': 'listar',
      'nome': controllerBuscaValidador.text,
      'idsCategorias': idsCategorias,
    };

    var aResult = await facilePostEx(context, 'facileFlutterApp.php', params, showProc: false);

    if (aResult == null) {
    } else if (aResult != null && aResult['Status'] == 'OK') {
      listProdutosQuantidade = int.parse(aResult['listProdutosQuantidade']);
      totalGeralProdutos = int.parse(aResult['totalGeralProdutos']);
      totalProdutosNoFiltro = int.parse(aResult['totalProdutosNoFiltro']);

      Iterable vProduto = await aResult['listProdutos'];
      listProdutos = vProduto.map((model) => Produto.fromMap(model)).toList();

      Iterable vCategoria = await aResult['listCategorias'];
      listCategorias = vCategoria.map((model) => Categoria.fromMap(model)).toList();

      if (mounted) {
        isLoad = false;
        scrollToTop();
        setState(() {});
      }
    } else {
      facileSnackBarError(context, 'Ops!', aResult['Msg']);
    }
  }

  void onFocusKey(context, RawKeyEvent event) {
    var s = event.logicalKey.keyLabel.toString().replaceAll('Numpad ', '').replaceAll('Digit ', '').replaceAll('Key ', '').replaceAll('Space', ' ');

    if (event.runtimeType == RawKeyDownEvent) {
      log('ProdutosPage::onFocusKey::$s');

      if (s == 'Escape') {
        if (stringPesquisa.isNotEmpty) {
          stringPesquisa = '';
          setState(() {});
        } else {
          Navigator.pop(context);
        }
      } else if (s == 'F1') {
        controllerBuscaValidador.text = '';
        stringPesquisa = '';
        load(context);
      } else if (s == 'Enter' && stringPesquisa.isNotEmpty) {
        avaliaEnter(context);
      } else if (' 01234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ'.contains(s)) {
        stringPesquisa += s;
        setState(() {});
      } else if (event.physicalKey == PhysicalKeyboardKey.keyA) {}
    }
  }

  void avaliaEnter(context, {int index = -1}) {
    log('avaliaEnter::$index');

    if (index == -1) {
      controllerBuscaValidador.text = stringPesquisa;
      stringPesquisa = '';
      load(context);
    } else if (!isLoad && stringPesquisa.isEmpty) {
      Navigator.pop(
          context,
          PopReturns(
            'idClick',
            listProdutos[index].primeiroEanSistema,
          ));
    }
  }

  Future<void> scanCodigoBarrasEanFornecedor(context) async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'CANCELA', true, ScanMode.BARCODE);
    } on PlatformException {
      //facileBeep(context);
      barcodeScanRes = '';
    }

    if (barcodeScanRes.isNotEmpty && barcodeScanRes != '-1') {
      stringPesquisa = barcodeScanRes;
      avaliaEnter(context);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    List<FormIconButton> listIconButton = [];

    listIconButton.add(FormIconButton(
      icon: CupertinoIcons.barcode,
      caption: getTextWindowsKey(gDevice.isPhoneAll ? '' : 'Scanner', 'F3'),
      onTap: () {
        scanCodigoBarrasEanFornecedor(context);
      },
    ));

    listIconButton.add(FormIconButton(
      icon: CupertinoIcons.plus,
      caption: getTextWindowsKey(gDevice.isPhoneAll ? '' : 'Novo', 'F4'),
      onTap: () {
        novoProduto(context);
      },
    ));

    List<FormFloatingActionButton> listFloatingActionButton = [];

    listFloatingActionButton.add(FormFloatingActionButton(
        icon: Icons.refresh_outlined,
        caption: getTextWindowsKey(gDevice.isPhoneAll ? '' : 'Atualizar', 'F1'),
        onTap: () {
          controllerBuscaValidador.text = '';
          stringPesquisa = '';
          load(context);
        }));

    if (!gDevice.isWindows) {
      listFloatingActionButton.add(
        FormFloatingActionButton(
          icon: Icons.search_outlined,
          caption: getTextWindowsKey(gDevice.isPhoneAll ? '' : 'Pesquisar', 'F2'),
          onTap: () {
            pesquisar(context);
          },
        ),
      );
    }

    tamanhoFonte = double.parse(gParametros.aparenciaPadraoExibicaoNomeProdutoFonte);
    negritoFonte = gParametros.aparenciaPadraoExibicaoNomeProdutoFonteNegrito == 'S';

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
                  ? 140
                  : gDevice.isWindows || gDevice.isTabletLandscape
                      ? 80
                      : 120,
            ),
            itemCount: listProdutosQuantidade,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                focusNode: index == 0 && gDevice.isWindows ? controllerListNode : null,
                onLongPress: () {
                  setState(() {
                    listProdutos[index].cest = (listProdutos[index].cest == 'selecionado' ? '' : 'selecionado');
                  });
                },
                onTap: () {
                  ///
                  /// Modo selecionar
                  ///
                  if (widget.modo == ProdutosModo.selecionarUnico) {
                    Timer(100.ms, () {
                      avaliaEnter(context, index: index);
                    });

                    return;
                  }

                  ///
                  /// Windows nao pode editar
                  ///
                  if (gDevice.isWindows) {
                    return;
                  }

                  ///
                  /// Modo editar
                  ///
                  PopReturns result = PopReturns('', '');

                  showCupertinoModalBottomSheet(
                    duration: getCupertinoModalBottomSheetDuration(),
                    context: context,
                    builder: (context) => ProdutosEditar(
                      produto: listProdutos[index],
                      listCategorias: listCategorias,
                      popReturns: result,
                      svgSemFoto: svgSemFoto,
                    ),
                  ).then(
                    (value) {
                      if (result.param == 'alterado') {
                        Timer(100.ms, () {
                          load(context);
                        });
                      }
                    },
                  );
                },
                child: cardProduto(context, index),
              );
            }),
      )
    ];

    var gradient = LinearGradient(
      colors: [
        (gTema.modo == 'dark' ? Colors.grey.withOpacity(0.5) : Colors.grey.withOpacity(0.5)),
        (gTema.modo == 'dark' ? Colors.grey.withOpacity(0.5) : Colors.grey.withOpacity(0.5)),
        (gTema.modo == 'dark' ? Colors.grey.withOpacity(0.5) : Colors.grey.withOpacity(0.5)),
        (gTema.modo == 'dark' ? Colors.grey.withOpacity(0.5) : Colors.grey.withOpacity(0.5)),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

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
            appBar: gDevice.isWindows ? null : getCupertinoAppBarCheck(context, 'PRODUTOS', listIconButton, isLoad, addCheck: false),
            body: (isLoad
                ? Center(
                    child: SizedBox(
                      width: getMaxSizedBoxLottie(context),
                      child: Lottie.asset(
                        'imagens/loading.json',
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                : Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: getMaxSizedBoxHeight(context) * .1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 100,
                                  width: getMaxSizedBoxWidth(context) * 0.8,
                                  padding: getPaddingDefault(context),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient: gradient,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      gDevice.isWindows ? FacileTheme.displaySmall(context, stringPesquisa.isEmpty ? 'digite sua pesquisa' : stringPesquisa) : const SizedBox(),
                                      gDevice.isPhoneAll
                                          ? Column(
                                              children: [
                                                controllerBuscaValidador.text.isEmpty ? const SizedBox() : FacileTheme.displaySmall(context, controllerBuscaValidador.text),
                                                FacileTheme.displaySmall(context, 'Exibindo $listProdutosQuantidade de $totalProdutosNoFiltro ($totalGeralProdutos)').animate().shake(duration: 1000.ms),
                                              ],
                                            )
                                          : FacileTheme.displaySmall(context, '${controllerBuscaValidador.text} / Exibindo $listProdutosQuantidade de $totalProdutosNoFiltro ($totalGeralProdutos)')
                                              .animate()
                                              .shake(duration: 1000.ms),
                                    ],
                                  ),
                                )
                                    .animate(
                                      onPlay: (controller) => controller.repeat(reverse: true),
                                    )
                                    .move(duration: 1000.ms),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(children: w1),
                    ],
                  )),
          ),
        ),
      ),
    );
  }

  cardProduto(context, index) {
    List<String> search = controllerBuscaValidador.text.split(' ').map((String text) => (text)).cast<String>().toList();
    var ind = index + 1;

    double heightPreco = gDevice.isTabletPortrait ? 30 : 30;
    //double heightCard = gDevice.isTabletPortrait ? 140 : 100;

    Widget preco = Container(
      height: heightPreco,
      width: gDevice.isTabletAll || gDevice.isWindows ? 150 : 80,
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
              child: FacileTheme.displaySmall(
                context,
                listProdutos[index].precoVendaVarejoF,
                invert: true,
              ),
            ),
          ],
        ),
      ),
    );

    Widget precoPromocional = double.parse(listProdutos[index].precoVendaPromocional) > 0.00
        ? Container(
            margin: const EdgeInsets.only(right: 4),
            height: heightPreco,
            width: gDevice.isTabletAll || gDevice.isWindows ? 150 : 80,
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
                    badgeContent: Icon(Icons.percent, size: gDevice.isTabletAll || gDevice.isWindows ? 10 : 10, color: Colors.white),
                    position: badges.BadgePosition.topEnd(top: -13, end: -25),
                    badgeColor: Colors.red,
                    child: FacileTheme.displaySmall(
                      context,
                      listProdutos[index].precoVendaPromocionalF,
                      invert: true,
                    ),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox();

    Widget precoVendaAtacado = double.parse(listProdutos[index].precoVendaAtacado) > 0.00
        ? Container(
            margin: const EdgeInsets.only(right: 4),
            height: heightPreco,
            width: gDevice.isTabletAll || gDevice.isWindows ? 150 : 80,
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
                    badgeContent: Icon(Icons.format_color_text, size: gDevice.isTabletAll || gDevice.isWindows ? 10 : 10, color: Colors.white),
                    position: badges.BadgePosition.topEnd(top: -13, end: -25),
                    badgeColor: Colors.red,
                    child: FacileTheme.displaySmall(
                      context,
                      listProdutos[index].precoVendaAtacadoF,
                      invert: true,
                    ),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox();

    //contentPadding: const EdgeInsets.all(0),
    //minVerticalPadding: gDevice.isWindows ? null : 1,
    return Opacity(
      opacity: listProdutos[index].ativo == 'N' ? 0.5 : 1,
      child: Container(
        //height: heightCard,
        //padding: EdgeInsets.all(gDevice.isWindows ? 4 : 2),
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
                  /// Imagem da lista
                  ///
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: SizedBox(
                      width: gDevice.isWindows || gDevice.isTabletAll ? 130 : 80,
                      height: gDevice.isWindows || gDevice.isTabletAll ? 130 : 80,
                      child: Hero(
                        tag: 'heroProduto${listProdutos[index].id}',
                        child: listProdutos[index].imagemPrincipal.contains('sem-foto')
                            ? SvgPicture.string(
                                svgSemFoto.replaceAll(
                                  '#B0BEC5',
                                  gTema.colorArray[gTema.cor].toHex().replaceAll('#ff', '#'),
                                ),
                                height: gDevice.isWindows || gDevice.isTabletAll ? 130 : 70,
                              )
                            : getImageDefault(context, listProdutos[index].imagemPrincipal, inList: true),
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
                          /// Categoria
                          ///

                          Text(
                        listProdutos[index].categoriaNome,
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
                          /// Nome
                          ///
                          Row(
                        children: [
                          Expanded(
                            child: controllerBuscaValidador.text == ''
                                ? Text(
                                    listProdutos[index].nome,
                                    style: GoogleFonts.ubuntuCondensed(
                                      fontSize: (gDevice.isTabletAll || gDevice.isWindows ? 18 : 14) + tamanhoFonte,
                                      fontWeight: negritoFonte ? FontWeight.w900 : FontWeight.w500,
                                    ),
                                  )
                                : HighlightText(
                                    listProdutos[index].nome,
                                    style: GoogleFonts.ubuntuCondensed(
                                      fontSize: (gDevice.isTabletAll || gDevice.isWindows ? 18 : 14) + tamanhoFonte,
                                      fontWeight: negritoFonte ? FontWeight.w900 : FontWeight.w500,
                                    ),
                                    detectWords: true,
                                    highlight: Highlight(words: search),
                                    highlightStyle: GoogleFonts.ubuntuCondensed(
                                      fontSize: ((gDevice.isTabletAll || gDevice.isWindows ? 18 : 14)) + tamanhoFonte,
                                      backgroundColor: Colors.yellow,
                                      color: Colors.black,
                                      fontWeight: negritoFonte ? FontWeight.w900 : FontWeight.w500,
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
            /// Selecionado
            ///

            listProdutos[index].cest == 'selecionado'
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.green.shade900,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 15,
                                color: FacileTheme.getShadowColor(context),
                                offset: const Offset(1, 1),
                              )
                            ],
                          ),
                          child: ClipOval(
                            child: SizedBox.fromSize(
                              size: Size.fromRadius(
                                getMaxSizedImagemProfile(context),
                              ),
                              child: const Icon(
                                Icons.check_outlined,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          )),
                      getEspacador(),
                    ],
                  )
                : const SizedBox(),

            /// **************************
            /// Numeração stack 3
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
                              listProdutos[index].hoje == 'hoje'
                                  ? badges.Badge(
                                      badgeContent: Icon(
                                        Icons.check,
                                        size: gDevice.isTabletAll || gDevice.isWindows ? 15 : 10,
                                        color: Colors.green.shade900,
                                      ),
                                      position: badges.BadgePosition.topEnd(top: -6, end: -15),
                                      badgeColor: Colors.green,
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 20),
                                        child: FacileTheme.displaySmall(
                                          context,
                                          'ID:${listProdutos[index].id} / $ind',
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: FacileTheme.displaySmall(
                                        context,
                                        'ID:${listProdutos[index].id} / $ind',
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
            /// Precos stack 1/2
            ///
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      precoVendaAtacado,
                      precoPromocional,
                      preco,
                      gDevice.isWindows || gDevice.isTabletLandscape ? const SizedBox(width: 150) : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),

            /// **************************
            /// Inativo stack 1/2
            ///

            Center(
              child: Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.identity()..rotateZ(7 * 3.1415927 / 180),
                child: Text(
                  listProdutos[index].ativo == 'N' ? 'PRODUTO INATIVO' : '',
                  style: TextStyle(
                    fontSize: gDevice.isTabletAll || gDevice.isWindows ? 50 : 40,
                    color: Colors.red.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void pesquisar(context) {
    showCupertinoModalBottomSheet(
      duration: getCupertinoModalBottomSheetDuration(),
      context: context,
      builder: (context) => ProdutosPesquisaPage(param: controllerBuscaValidador.text),
    ).then(
      (value) {
        if (value != null && value.action == 'searchClick') {
          controllerBuscaValidador.text = value.param;
          load(context);
        }
      },
    );
  }

  void novoProduto(context) {
    final action = CupertinoActionSheet(
      title: FacileTheme.headlineSmall(context, 'NOVO PRODUTO'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);

            showCupertinoModalBottomSheet(
              duration: getCupertinoModalBottomSheetDuration(),
              context: context,
              builder: (context) => const ProdutosNovoPage(modo: 'ean'),
            ).then(
              (value) {
                if (value != null && value.action == 'okClick') {
                  load(context);
                }
              },
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.barcode,
                color: Theme.of(context).colorScheme.primary,
              ),
              FacileTheme.displaySmall(context, "POR CÓDIGO DE BARRAS"),
            ],
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);

            showCupertinoModalBottomSheet(
              duration: getCupertinoModalBottomSheetDuration(),
              context: context,
              builder: (context) => const ProdutosNovoPage(modo: 'nome'),
            ).then(
              (value) {
                if (value != null && value.action == 'okClick') {
                  load(context);
                }
              },
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.text_format,
                color: Theme.of(context).colorScheme.primary,
              ),
              FacileTheme.displaySmall(context, "POR DESCRIÇÃO"),
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
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }
}
