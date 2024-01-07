import 'dart:convert';
import 'dart:developer';

import 'package:facilelojaapp/dados/categoria.dart';
import 'package:facilelojaapp/dados/produto.dart';
import 'package:facilelojaapp/dados/produtovariacao.dart';
import 'package:facilelojaapp/main.dart';
import 'package:facilelojaapp/produtosimagens.dart';
import 'package:facilelojaapp/util.dart';
import 'package:facilelojaapp/utilpost.dart';
import 'package:facilelojaapp/utiltema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'produtosvariacoes.dart';

///
/// Editar produto
///

class ProdutosEditar extends StatefulWidget {
  final Produto produto;
  final List<Categoria> listCategorias;
  final PopReturns popReturns;
  final String svgSemFoto;

  const ProdutosEditar({
    super.key,
    required this.produto,
    required this.listCategorias,
    required this.popReturns,
    required this.svgSemFoto,
  });

  @override
  State<ProdutosEditar> createState() => _ProdutosEditarState();
}

class _ProdutosEditarState extends State<ProdutosEditar> {
  final TextEditingController controllerNomeValidador = TextEditingController();
  String? controllerNomeValidadorErrorText;
  final controllerNomeValidadorNode = FocusNode();

  final TextEditingController controllerPrecoVendaVarejoValidador = TextEditingController();
  String? controllerPrecoVendaVarejoValidadorErrorText;
  final controllerPrecoVendaVarejoValidadorNode = FocusNode();

  final TextEditingController controllerPrecoVendaPromocionalValidador = TextEditingController();
  String? controllerPrecoVendaPromocionalValidadorErrorText;
  final controllerPrecoVendaPromocionalValidadorNode = FocusNode();

  final TextEditingController controllerPrecoVendaAtacadoValidador = TextEditingController();
  String? controllerPrecoVendaAtacadoValidadorErrorText;
  final controllerPrecoVendaAtacadoValidadorNode = FocusNode();

  List<ProdutoVariacao> _listProdutoVariacao = List.empty();

  Categoria? idCategoria;

  List<Widget> bg = [];

  @override
  void initState() {
    Iterable va = jsonDecode(widget.produto.variacoes);
    _listProdutoVariacao = va.map((model) => ProdutoVariacao.fromMap(model)).toList();

    load(context);

    controllerNomeValidadorNode.addListener(() {
      if (!controllerNomeValidadorNode.hasFocus) {
        if (controllerNomeValidador.text != widget.produto.nome) {
          alterarCampo(context, 'nome', controllerNomeValidador.text);
        }
      }
    });

    controllerPrecoVendaVarejoValidadorNode.addListener(() {
      if (!controllerPrecoVendaVarejoValidadorNode.hasFocus) {
        if (controllerPrecoVendaVarejoValidador.text != widget.produto.precoVendaVarejo) {
          alterarCampo(context, 'precoVendaVarejo', controllerPrecoVendaVarejoValidador.text);

          if (widget.produto.temVariacaoUnica == 'N') {
            showSimNao(context, 'ALTERAR OS VALORES DAS VARIAÇÕES ?', '', () async {
              Navigator.pop(context);
              alteraPrecosVariacoes(context, 'precoVendaVarejo', controllerPrecoVendaVarejoValidador.text);
            });
          } else {
            ProdutoVariacao produtoVariacaoUnica = _listProdutoVariacao.first;
            produtoVariacaoUnica.precoVendaVarejo = controllerPrecoVendaVarejoValidador.text;
          }
        }
      }
    });
    controllerPrecoVendaPromocionalValidadorNode.addListener(() {
      if (!controllerPrecoVendaPromocionalValidadorNode.hasFocus) {
        if (controllerPrecoVendaPromocionalValidador.text != widget.produto.precoVendaPromocional) {
          alterarCampo(context, 'precoVendaPromocional', controllerPrecoVendaPromocionalValidador.text);

          if (widget.produto.temVariacaoUnica == 'N') {
            showSimNao(context, 'ALTERAR OS VALORES DAS VARIAÇÕES ?', '', () async {
              Navigator.pop(context);
              alteraPrecosVariacoes(context, 'precoVendaPromocional', controllerPrecoVendaPromocionalValidador.text);
            });
          } else {
            ProdutoVariacao produtoVariacaoUnica = _listProdutoVariacao.first;
            produtoVariacaoUnica.precoVendaPromocional = controllerPrecoVendaPromocionalValidador.text;
          }
        }
      }
    });
    controllerPrecoVendaAtacadoValidadorNode.addListener(() {
      if (!controllerPrecoVendaAtacadoValidadorNode.hasFocus) {
        if (controllerPrecoVendaAtacadoValidador.text != widget.produto.precoVendaAtacado) {
          alterarCampo(context, 'precoVendaAtacado', controllerPrecoVendaAtacadoValidador.text);

          if (widget.produto.temVariacaoUnica == 'N') {
            showSimNao(context, 'ALTERAR OS VALORES DAS VARIAÇÕES ?', '', () async {
              Navigator.pop(context);
              alteraPrecosVariacoes(context, 'precoVendaAtacado', controllerPrecoVendaAtacadoValidador.text);
            });
          }
          {
            ProdutoVariacao produtoVariacaoUnica = _listProdutoVariacao.first;
            produtoVariacaoUnica.precoVendaAtacado = controllerPrecoVendaAtacadoValidador.text;
          }
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controllerNomeValidadorNode.dispose();
    controllerPrecoVendaVarejoValidadorNode.dispose();
    controllerPrecoVendaPromocionalValidadorNode.dispose();
    controllerPrecoVendaAtacadoValidadorNode.dispose();
    super.dispose();
  }

  void load(context) async {
    controllerNomeValidador.text = widget.produto.nome;
    controllerPrecoVendaVarejoValidador.text = widget.produto.precoVendaVarejo;
    controllerPrecoVendaPromocionalValidador.text = widget.produto.precoVendaPromocional;
    controllerPrecoVendaAtacadoValidador.text = widget.produto.precoVendaAtacado;

    log(widget.produto.variacoes.toString());

    idCategoria = widget.listCategorias.firstWhere(
      (element) => element.id == widget.produto.idCategoria,
      orElse: () => widget.listCategorias.first,
    );

    setState(() {});
  }

  void onFocusKey(context, RawKeyEvent event) {
    var s = event.logicalKey.keyLabel.toString().replaceAll('Numpad ', '').replaceAll('Digit ', '').replaceAll('Key ', '').replaceAll('Space', ' ');

    if (event.runtimeType == RawKeyDownEvent) {
      debugPrint('ProdutosEditar::onFocusKey::$s');

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

    List<FormIconButton> listIconButton = [];

    ProdutoVariacao produtoVariacaoUnica = _listProdutoVariacao.first;

    List<Widget> w2 = [
      getEspacador(),
      Row(
        children: [
          FacileTheme.headlineSmall(context, 'IDENTIFICAÇÃO'),
        ],
      ),
      getEspacadorDuplo(),

      ///
      /// Nome
      ///

      TextField(
        inputFormatters: [LengthLimitingTextInputFormatter(300)],
        textCapitalization: TextCapitalization.sentences,
        focusNode: controllerNomeValidadorNode,
        controller: controllerNomeValidador,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          errorText: controllerNomeValidadorErrorText,
          prefixIcon: const Icon(Icons.text_format),
          hintText: 'Informe até 300 caracteres',
          label: const Text.rich(
            TextSpan(
              children: <InlineSpan>[
                WidgetSpan(
                  child: Text(
                    'Descrição',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      getEspacadorTriplo(),

      ///
      /// Categoria
      ///

      DropdownButtonFormField<Categoria>(
        isDense: false,
        isExpanded: true,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.list),
          hintText: 'Selecione',
          label: Text.rich(
            TextSpan(
              children: <InlineSpan>[
                WidgetSpan(
                  child: Text(
                    'Categoria',
                  ),
                ),
              ],
            ),
          ),
        ),
        value: idCategoria,
        items: widget.listCategorias.map((Categoria value) {
          return DropdownMenuItem<Categoria>(
            value: value,
            child: Row(
              children: [
                Text(value.nome),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            idCategoria = value;
            alterarCampo(context, 'idCategoria', value?.id.toString());
          });
        },
      ),
      getEspacadorDuplo(),

      ///
      /// Preços
      ///

      Row(
        children: [
          FacileTheme.headlineSmall(context, 'PREÇOS'),
        ],
      ),
      getEspacadorDuplo(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * (gDevice.isTabletLandscape ? 0.15 : 0.25),
            child: TextField(
              inputFormatters: [CurrencyInputFormatter(), LengthLimitingTextInputFormatter(11)],
              focusNode: controllerPrecoVendaVarejoValidadorNode,
              controller: controllerPrecoVendaVarejoValidador,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.end,
              //style: const TextStyle(fontSize: 20),
              decoration: InputDecoration(
                errorText: controllerPrecoVendaVarejoValidadorErrorText,
                label: const Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      WidgetSpan(
                        child: Text(
                          'Varejo',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * (gDevice.isTabletLandscape ? 0.15 : 0.25),
            child: TextField(
              inputFormatters: [CurrencyInputFormatter(), LengthLimitingTextInputFormatter(11)],
              focusNode: controllerPrecoVendaAtacadoValidadorNode,
              controller: controllerPrecoVendaAtacadoValidador,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.end,
              //style: const TextStyle(fontSize: 20),
              decoration: InputDecoration(
                errorText: controllerPrecoVendaAtacadoValidadorErrorText,
                label: const Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      WidgetSpan(
                        child: Text(
                          'Atacado',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * (gDevice.isTabletLandscape ? 0.15 : 0.25),
            child: TextField(
              inputFormatters: [CurrencyInputFormatter(), LengthLimitingTextInputFormatter(11)],
              focusNode: controllerPrecoVendaPromocionalValidadorNode,
              controller: controllerPrecoVendaPromocionalValidador,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.end,
              //style: const TextStyle(fontSize: 20),
              decoration: InputDecoration(
                errorText: controllerPrecoVendaPromocionalValidadorErrorText,
                label: const Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      WidgetSpan(
                        child: Text(
                          'Promocional',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      getEspacadorTriplo(),

      ///
      /// Variaçoes
      ///

      Row(
        children: [
          FacileTheme.headlineSmall(context, 'VARIAÇÕES (${_listProdutoVariacao.length == 1 ? 'única' : _listProdutoVariacao.length})'),
        ],
      ),
      getEspacadorDuplo(),
      widget.produto.temVariacaoUnica == 'S'
          ? Column(
              children: [
                ListTile(
                  leading: FacileTheme.displaySmall(context, 'Produto sem variações !'),
                  trailing: FloatingActionButton(
                    heroTag: null,
                    mini: true,
                    child: const Icon(Icons.edit),
                    onPressed: () async {
                      editaVariacao(context, _listProdutoVariacao.first);
                    },
                  )
                      .animate(
                        onPlay: (controller) => controller.repeat(reverse: true),
                      )
                      .then()
                      .move(duration: 1000.ms, begin: const Offset(5, -5))
                      .then()
                      .shake(duration: 500.ms),
                ),
                const Divider(),
                ListTile(
                  leading: Icon(CupertinoIcons.barcode, size: 32, color: FacileTheme.getColorPrimary(context)),
                  title: FacileTheme.displayMedium(context, produtoVariacaoUnica.eanSistema, align: TextAlign.right),
                  subtitle: FacileTheme.displaySmall(context, 'EAN Sistema', align: TextAlign.right),
                ),
                const Divider(),
                ListTile(
                  leading: Icon(CupertinoIcons.barcode, size: 32, color: FacileTheme.getColorPrimary(context)),
                  title: FacileTheme.displayMedium(context, produtoVariacaoUnica.eanFornecedor.isEmpty ? '-' : produtoVariacaoUnica.eanFornecedor, align: TextAlign.right),
                  subtitle: FacileTheme.displaySmall(context, 'EAN Fornecedor', align: TextAlign.right),
                ),
              ],
            )
          : leVariacoes(context),

      // Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       SizedBox(
      //         height: 350,
      //         child: ListView.builder(
      //           itemCount: _listProdutoVariacao.length,
      //           itemBuilder: (context, index) {
      //             return Column(
      //               children: [
      //                 ListTile(
      //                   leading: headlineMedium(context, '${_listProdutoVariacao[index].nomeCampoVarA} ${_listProdutoVariacao[index].nomeCampoVarB}'),
      //                   trailing: FloatingActionButton(
      //                     heroTag: null,
      //                     mini: true,
      //                     child: const Icon(Icons.edit),
      //                     onPressed: () async {
      //                       editaVariacao(context, _listProdutoVariacao[index]);
      //                     },
      //                   )
      //                       .animate(
      //                         onPlay: (controller) => controller.repeat(reverse: true),
      //                       )
      //                       .then()
      //                       .move(duration: 1000.ms, begin: const Offset(5, -5))
      //                       .then()
      //                       .shake(duration: 500.ms),
      //                 ),
      //                 ListTile(
      //                   minVerticalPadding: 1,
      //                   leading: Icon(CupertinoIcons.barcode, size: 32, color: FacileTheme.getColorPrimary(context)),
      //                   title: FacileTheme.displayMedium(context, _listProdutoVariacao[index].eanSistema, align: TextAlign.right),
      //                   subtitle: FacileTheme.displaySmall(context, 'EAN Sistema', align: TextAlign.right),
      //                   dense: true,
      //                 ),
      //                 ListTile(
      //                   minVerticalPadding: 1,
      //                   leading: Icon(CupertinoIcons.barcode, size: 32, color: FacileTheme.getColorPrimary(context)),
      //                   title: FacileTheme.displayMedium(context, _listProdutoVariacao[index].eanFornecedor.isEmpty ? '-' : _listProdutoVariacao[index].eanFornecedor, align: TextAlign.right),
      //                   subtitle: FacileTheme.displaySmall(context, 'EAN Fornecedor', align: TextAlign.right),
      //                   dense: true,
      //                 ),
      //                 ListTile(
      //                   minVerticalPadding: 1,
      //                   leading: Icon(CupertinoIcons.money_dollar, size: 32, color: FacileTheme.getColorPrimary(context)),
      //                   title: FacileTheme.displaySmall(context, 'Varejo', align: TextAlign.right),
      //                   trailing: FacileTheme.displayMedium(context, _listProdutoVariacao[index].precoVendaVarejoF),
      //                   dense: true,
      //                 ),
      //                 ListTile(
      //                   minVerticalPadding: 1,
      //                   leading: Icon(CupertinoIcons.money_dollar, size: 32, color: FacileTheme.getColorPrimary(context)),
      //                   title: FacileTheme.displaySmall(context, 'Atacado', align: TextAlign.right),
      //                   trailing: FacileTheme.displayMedium(context, _listProdutoVariacao[index].precoVendaAtacadoF),
      //                   dense: true,
      //                 ),
      //                 ListTile(
      //                   minVerticalPadding: 1,
      //                   leading: Icon(CupertinoIcons.money_dollar, size: 32, color: FacileTheme.getColorPrimary(context)),
      //                   title: FacileTheme.displaySmall(context, 'Promocional', align: TextAlign.right),
      //                   trailing: FacileTheme.displayMedium(context, _listProdutoVariacao[index].precoVendaPromocionalF),
      //                   dense: true,
      //                 ),
      //                 const Divider(),
      //               ],
      //             );
      //           },
      //         ),
      //       ),
      //     ],
      //   ),

      getEspacadorTriplo(),
    ];
    List<Widget> w1 = [
      InkWell(
        onTap: () {
          ///
          /// Modo editar imagens
          ///
          PopReturns result = PopReturns('', '');

          showCupertinoModalBottomSheet(
            duration: getCupertinoModalBottomSheetDuration(),
            context: context,
            builder: (context) => ProdutosImagens(
              produto: widget.produto,
              popReturns: result,
              svgSemFoto: widget.svgSemFoto,
            ),
          ).then(
            (value) {
              setState(() {});
              if (result.param == 'alterado') {
                widget.popReturns.param = 'alterado';
              }
            },
          );
        },
        child: Container(
          //width: getMaxSizedBoxLottie(context) * .5,
          margin: const EdgeInsets.all(8),
          child: Hero(
            tag: 'heroProduto${widget.produto.id}',
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: widget.produto.imagemPrincipal.contains('sem-foto')
                  ? SvgPicture.string(
                      widget.svgSemFoto.replaceAll(
                        '#B0BEC5',
                        gTema.colorArray[gTema.cor].toHex().replaceAll('#ff', '#'),
                      ),
                      width: getMaxSizedBoxLottie(context) * .8,
                    )
                  : getImageDefault(context, widget.produto.imagemPrincipal),
            ),
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
          appBar: getCupertinoAppBar(context, 'PRODUTO ID ${widget.produto.id}', listIconButton),
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
          trailing: FloatingActionButton(
            heroTag: null,
            mini: true,
            child: const Icon(Icons.edit),
            onPressed: () async {
              editaVariacao(context, item);
            },
          )
              .animate(
                onPlay: (controller) => controller.repeat(reverse: true),
              )
              .then()
              .move(duration: 1000.ms, begin: const Offset(5, -5))
              .then()
              .shake(duration: 500.ms),
        ),
      );
      w.add(
        ListTile(
          minVerticalPadding: 1,
          leading: Icon(CupertinoIcons.barcode, size: 32, color: FacileTheme.getColorPrimary(context)),
          title: FacileTheme.displayMedium(context, item.eanSistema, align: TextAlign.right),
          subtitle: FacileTheme.displaySmall(context, 'EAN Sistema', align: TextAlign.right),
          dense: true,
        ),
      );
      w.add(
        ListTile(
          minVerticalPadding: 1,
          leading: Icon(CupertinoIcons.barcode, size: 32, color: FacileTheme.getColorPrimary(context)),
          title: FacileTheme.displayMedium(context, item.eanFornecedor.isEmpty ? '-' : item.eanFornecedor, align: TextAlign.right),
          subtitle: FacileTheme.displaySmall(context, 'EAN Fornecedor', align: TextAlign.right),
          dense: true,
        ),
      );
      w.add(
        ListTile(
          minVerticalPadding: 1,
          leading: Icon(CupertinoIcons.money_dollar, size: 32, color: FacileTheme.getColorPrimary(context)),
          title: FacileTheme.displaySmall(context, 'Varejo', align: TextAlign.right),
          trailing: FacileTheme.displayMedium(context, item.precoVendaVarejoF),
          dense: true,
        ),
      );
      w.add(
        ListTile(
          minVerticalPadding: 1,
          leading: Icon(CupertinoIcons.money_dollar, size: 32, color: FacileTheme.getColorPrimary(context)),
          title: FacileTheme.displaySmall(context, 'Atacado', align: TextAlign.right),
          trailing: FacileTheme.displayMedium(context, item.precoVendaAtacadoF),
          dense: true,
        ),
      );
      w.add(
        ListTile(
          minVerticalPadding: 1,
          leading: Icon(CupertinoIcons.money_dollar, size: 32, color: FacileTheme.getColorPrimary(context)),
          title: FacileTheme.displaySmall(context, 'Promocional', align: TextAlign.right),
          trailing: FacileTheme.displayMedium(context, item.precoVendaPromocionalF),
          dense: true,
        ),
      );
      w.add(
        const Divider(),
      );
    }

    return Column(children: w);
  }

  void alterarCampo(context, campo, conteudo) async {
    Map<String, String> params = {
      'Funcao': 'AlteraCampo',
      'id': widget.produto.id,
      'campo': campo,
      'conteudo': conteudo,
    };

    var aResult = await facilePostEx(context, 'facileFlutterApp.php', params, showProc: false);

    if (aResult == null) {
    } else if (aResult != null && aResult['Status'] == 'OK') {
      widget.popReturns.param = 'alterado';
      snackBarMsg(context, 'Atualizado !');
    } else {
      facileSnackBarError(context, 'Ops!', aResult['Msg']);
    }
  }

  void alteraPrecosVariacoes(context, campo, conteudo) async {
    Map<String, String> params = {
      'Funcao': 'AlteraPrecosVariacoes',
      'id': widget.produto.id,
      'campo': campo,
      'conteudo': conteudo,
    };

    var aResult = await facilePostEx(context, 'facileFlutterApp.php', params, showProc: false);

    if (aResult == null) {
    } else if (aResult != null && aResult['Status'] == 'OK') {
      for (var variacao in _listProdutoVariacao) {
        if (campo == 'precoVendaVarejo') {
          variacao.precoVendaVarejoF = aResult['precoVendaVarejoF'];
        } else if (campo == 'precoVendaAtacado') {
          variacao.precoVendaAtacadoF = aResult['precoVendaAtacadoF'];
        } else if (campo == 'precoVendaPromocional') {
          variacao.precoVendaPromocionalF = aResult['precoVendaPromocionalF'];
        }
      }

      widget.popReturns.param = 'alterado';
      snackBarMsg(context, 'Atualizado !');
      setState(() {});
    } else {
      facileSnackBarError(context, 'Ops!', aResult['Msg']);
    }
  }

  void editaVariacao(context, variacao) {
    ///
    /// Modo editar imagens
    ///
    PopReturns result = PopReturns('', '');

    showCupertinoModalBottomSheet(
      duration: getCupertinoModalBottomSheetDuration(),
      context: context,
      builder: (context) => EditaProdutoVariacao(
        produto: widget.produto,
        variacao: variacao,
        popReturns: result,
        svgSemFoto: widget.svgSemFoto,
      ),
    ).then(
      (value) {
        setState(() {});
        if (result.param == 'alterado') {
          widget.popReturns.param = 'alterado';
        }
      },
    );
  }
}
