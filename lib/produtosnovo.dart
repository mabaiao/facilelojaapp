import 'dart:developer';

import 'package:facilelojaapp/main.dart';
import 'package:facilelojaapp/util.dart';
import 'package:facilelojaapp/utilpost.dart';
import 'package:facilelojaapp/utiltema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// **************************
/// ProdutosPesquisa
///

class ProdutosNovoPage extends StatefulWidget {
  final String modo;

  const ProdutosNovoPage({super.key, required this.modo});

  @override
  State<ProdutosNovoPage> createState() => _ProdutosPesquisaState();
}

class _ProdutosPesquisaState extends State<ProdutosNovoPage> {
  String svg = '';
  List<Widget> bg = [];

  final TextEditingController _controllerNovoProdutoValidador = TextEditingController();
  final TextEditingController _controllerEanFornecedorValidador = TextEditingController();
  final TextEditingController _controllerNovoProdutoPrecoValidador = TextEditingController();

  @override
  void initState() {
    super.initState();
    load(context);
  }

  void load(context) async {
    _controllerNovoProdutoValidador.text = '';
    _controllerEanFornecedorValidador.text = '';
    _controllerNovoProdutoPrecoValidador.text = '0.00';

    svg = await getFileData('imagens/produto.svg');
    setState(() {});
  }

  void onFocusKey(context, RawKeyEvent event) {
    var s = event.logicalKey.keyLabel.toString().replaceAll('Numpad ', '').replaceAll('Digit ', '').replaceAll('Key ', '').replaceAll('Space', ' ');

    if (event.runtimeType == RawKeyDownEvent) {
      log('ProdutosNovoPage::onFocusKey::$s');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (bg.isEmpty) {
      bg = getBackground(context, minimize: true);
    }

    List<Widget> w1 = [
      SizedBox(
        height: getMaxSizedBoxLottie(context) / 2,
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
      ///
      /// Ean
      ///

      Row(
        children: [
          FacileTheme.headlineSmall(context, widget.modo == 'ean' ? 'CÓDIGO DE BARRAS' : 'IDENTIFICAÇÃO'),
        ],
      ),
      getEspacadorDuplo(),
      widget.modo == 'ean'
          ? TextField(
              inputFormatters: [LengthLimitingTextInputFormatter(20), UpperCaseTextFormatter()],
              controller: _controllerEanFornecedorValidador,
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
            )
          : const SizedBox(),

      widget.modo == 'nome'
          ? TextField(
              inputFormatters: [LengthLimitingTextInputFormatter(120)],
              textCapitalization: TextCapitalization.sentences,
              controller: _controllerNovoProdutoValidador,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.text_format),
                hintText: 'Informe até 120 caracteres',
                label: Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      WidgetSpan(
                        child: Text(
                          'Nome do produto',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const SizedBox(),

      getEspacadorTriplo(),

      ///
      /// Preços
      ///

      Row(
        children: [
          FacileTheme.headlineSmall(context, 'PREÇO'),
        ],
      ),
      getEspacadorDuplo(),
      TextField(
        inputFormatters: [CurrencyInputFormatter(), LengthLimitingTextInputFormatter(11)],
        controller: _controllerNovoProdutoPrecoValidador,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textAlign: TextAlign.end,
        style: const TextStyle(fontSize: 20),
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
          appBar: getCupertinoAppBar(context, 'NOVO PRODUTO', []),
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
      _controllerEanFornecedorValidador.text = barcodeScanRes;
      setState(() {});
    } else {}
  }

  Future<void> aplicar(context) async {
    if (widget.modo == 'ean' && _controllerEanFornecedorValidador.text.trim().isEmpty) {
      return;
    }

    if (widget.modo == 'nome' && _controllerNovoProdutoValidador.text.trim().isEmpty) {
      return;
    }

    if (double.parse(_controllerNovoProdutoPrecoValidador.text) <= 0) {
      return;
    }

    Map<String, String> params = {
      'Funcao': widget.modo == 'ean' ? 'IncluiViaGtin' : 'Inclui',
      'ID': '0',
      'gtin': widget.modo == 'ean' ? _controllerEanFornecedorValidador.text : _controllerNovoProdutoValidador.text,
      'nome': widget.modo == 'ean' ? _controllerEanFornecedorValidador.text : _controllerNovoProdutoValidador.text,
      'precoVendaVarejo': _controllerNovoProdutoPrecoValidador.text,
    };

    var aResult = await facilePostEx(context, 'cadastros-produtos.php', params, showProc: true);

    if (aResult == null) {
    } else if (aResult != null && aResult['Status'] == 'OK') {
      snackBarMsg(context, aResult['Msg']);
      Navigator.pop(context, PopReturns('okClick', ''));
    } else {
      facileSnackBarError(context, 'Ops!', aResult['Msg'], dur: 15000);
    }
  }
}
