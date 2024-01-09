import 'package:facilelojaapp/dados/produto.dart';
import 'package:facilelojaapp/dados/produtovariacao.dart';
import 'package:facilelojaapp/main.dart';
import 'package:facilelojaapp/produtosimagens.dart';
import 'package:facilelojaapp/util.dart';
import 'package:facilelojaapp/utiltema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'utilpost.dart';

///
/// Editar produto
///

class EditaProdutoVariacao extends StatefulWidget {
  final Produto produto;
  final ProdutoVariacao variacao;
  final PopReturns popReturns;
  final String svgSemFoto;

  const EditaProdutoVariacao({
    super.key,
    required this.produto,
    required this.variacao,
    required this.popReturns,
    required this.svgSemFoto,
  });

  @override
  State<EditaProdutoVariacao> createState() => _EditaProdutoVariacaoState();
}

class _EditaProdutoVariacaoState extends State<EditaProdutoVariacao> {
  final TextEditingController controllereanFornecedorValidador = TextEditingController();
  final TextEditingController controllerPrecoVendaVarejoValidador = TextEditingController();
  final TextEditingController controllerPrecoVendaPromocionalValidador = TextEditingController();
  final TextEditingController controllerPrecoVendaAtacadoValidador = TextEditingController();

  List<Widget> bg = [];

  @override
  void initState() {
    load(context);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void load(context) async {
    controllereanFornecedorValidador.text = widget.variacao.eanFornecedor;
    controllerPrecoVendaVarejoValidador.text = widget.variacao.precoVendaVarejo;
    controllerPrecoVendaPromocionalValidador.text = widget.variacao.precoVendaPromocional;
    controllerPrecoVendaAtacadoValidador.text = widget.variacao.precoVendaAtacado;

    setState(() {});
  }

  void onFocusKey(context, RawKeyEvent event) {
    var s = event.logicalKey.keyLabel.toString().replaceAll('Numpad ', '').replaceAll('Digit ', '').replaceAll('Key ', '').replaceAll('Space', ' ');

    if (event.runtimeType == RawKeyDownEvent) {
      debugPrint('ProdutoVariacao::onFocusKey::$s');

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
      Row(
        children: [
          Expanded(
            child: FacileTheme.displaySmall(context, widget.produto.nome),
          ),
        ],
      ),
      getEspacadorDuplo(),
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
          //width: getMaxSizedBoxLottieHeight(context) * .5,
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: widget.produto.imagemPrincipal.contains('sem-foto')
                ? SvgPicture.string(
                    widget.svgSemFoto.replaceAll(
                      '#B0BEC5',
                      gTema.colorArray[gTema.cor].toHex().replaceAll('#ff', '#'),
                    ),
                    width: getMaxSizedBoxLottieHeight(context) * .8,
                  )
                : getImageDefault(context, widget.produto.imagemPrincipal),
          ),
        ),
      ),
      getEspacadorDuplo(),
    ];

    List<Widget> w2 = [
      Row(
        children: [
          Expanded(
            child: FacileTheme.headlineMedium(context, '${widget.variacao.nomeCampoVarA} ${widget.variacao.nomeCampoVarB}'),
          ),
        ],
      ),
      getEspacadorDuplo(),

      ///
      /// Ean
      ///

      Row(
        children: [
          FacileTheme.headlineSmall(context, 'CÓDIGO DE BARRAS'),
        ],
      ),
      getEspacadorDuplo(),
      TextField(
        inputFormatters: [LengthLimitingTextInputFormatter(20), UpperCaseTextFormatter()],
        controller: controllereanFornecedorValidador,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          errorMaxLines: 5,
          prefixIcon: const Icon(CupertinoIcons.barcode),
          hintText: 'EAN Fornecedor',
          label: const Text.rich(
            TextSpan(
              children: <InlineSpan>[
                WidgetSpan(
                  child: Text(
                    'EAN Fornecedor',
                  ),
                ),
              ],
            ),
          ),
          suffixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.document_scanner),
                onPressed: () {
                  scanCodigoBarrasEanFornecedor(context);
                },
              ),
            ],
          ),
        ),
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
              readOnly: widget.produto.temVariacaoUnica == 'S',
              inputFormatters: [CurrencyInputFormatter(), LengthLimitingTextInputFormatter(11)],
              controller: controllerPrecoVendaVarejoValidador,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.end,
              //style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                label: Text.rich(
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
              readOnly: widget.produto.temVariacaoUnica == 'S',
              inputFormatters: [CurrencyInputFormatter(), LengthLimitingTextInputFormatter(11)],
              controller: controllerPrecoVendaAtacadoValidador,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.end,
              //style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                label: Text.rich(
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
              readOnly: widget.produto.temVariacaoUnica == 'S',
              inputFormatters: [CurrencyInputFormatter(), LengthLimitingTextInputFormatter(11)],
              controller: controllerPrecoVendaPromocionalValidador,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.end,
              //style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                label: Text.rich(
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
      /// Go
      ///

      ElevatedButtonEx(
        caption: 'APLICAR',
        icon: const Icon(Icons.check),
        onPressed: () async {
          aplicar(context);
        },
        style: ElevatedButton.styleFrom(),
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

  Future<void> scanCodigoBarrasEanFornecedor(context) async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'CANCELA', true, ScanMode.BARCODE);
    } on PlatformException {
      //facileBeep(context);
      barcodeScanRes = '';
    }

    if (barcodeScanRes.isNotEmpty && barcodeScanRes != '-1') {
      controllereanFornecedorValidador.text = barcodeScanRes;
      setState(() {});
    } else {}
  }

  Future<void> aplicar(context) async {
    Map<String, String> params = {
      'Funcao': 'AlteraVariacao',
      'id': widget.variacao.id,
      'eanFornecedor': controllereanFornecedorValidador.text,
      'precoVendaVarejo': controllerPrecoVendaVarejoValidador.text,
      'precoVendaAtacado': controllerPrecoVendaAtacadoValidador.text,
      'precoVendaPromocional': controllerPrecoVendaPromocionalValidador.text,
      'temVariacaoUnica': widget.produto.temVariacaoUnica,
    };

    var aResult = await facilePostEx(context, 'facileFlutterApp.php', params, showProc: true);

    if (aResult == null) {
    } else if (aResult != null && aResult['Status'] == 'OK') {
      widget.variacao.eanFornecedor = controllereanFornecedorValidador.text;
      widget.variacao.precoVendaVarejo = controllerPrecoVendaVarejoValidador.text;
      widget.variacao.precoVendaAtacado = controllerPrecoVendaAtacadoValidador.text;
      widget.variacao.precoVendaPromocional = controllerPrecoVendaPromocionalValidador.text;
      widget.variacao.precoVendaVarejoF = aResult['precoVendaVarejoF'];
      widget.variacao.precoVendaAtacadoF = aResult['precoVendaVarejoF'];
      widget.variacao.precoVendaPromocionalF = aResult['precoVendaVarejoF'];

      widget.popReturns.param = 'alterado';
      snackBarMsg(context, 'Variação atualizada !');
      Navigator.pop(context);
    } else {
      facileSnackBarError(context, 'Ops!', aResult['Msg'], dur: 15000);
    }
  }
}
