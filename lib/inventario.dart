import 'dart:async';
import 'dart:io';
import 'package:facilelojaapp/dados/lojafisica.dart';
import 'package:facilelojaapp/dados/produtovariacao.dart';
import 'package:facilelojaapp/main.dart';
import 'package:facilelojaapp/util.dart';
import 'package:facilelojaapp/utiltema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/svg.dart';
import 'dados/inventario.dart';
import 'dados/produto.dart';
import 'inventariolog.dart';
import 'utilpost.dart';

enum ModoInventario {
  selecionandoLoja,
  semLojaDisponivel,
  coletando,
  aguardandoEnvio,
}

class InventarioPage extends StatefulWidget {
  const InventarioPage({super.key});

  @override
  State<InventarioPage> createState() => _InventarioState();
}

class _InventarioState extends State<InventarioPage> {
  List<Widget> bg = [];
  String svg = '';
  String svgOk = '';

  bool isLoad = true;
  late String codigo = '';
  late String codigoProduto = '';
  late String nomeProduto = '';
  late String precoProduto = '';
  ModoInventario modo = ModoInventario.semLojaDisponivel;
  List<Inventario> inventarios = [];
  List<LojaFisica> lojasFisicas = [];
  LojaFisica? lojaSelecionada;
  Inventario? inventarioSelecionado;

  final FocusNode _focusNode = FocusNode();
  bool leitorPorText = Platform.isAndroid && double.parse(gDevice.release) < 10;
  final TextEditingController controllerEan = TextEditingController();

  int quantidade = 0;
  int estoqueAtual = 0;

  @override
  void initState() {
    load(context);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void load(context) async {
    svg = await getFileData('imagens/produto.svg');
    svgOk = await getFileData('imagens/ok.svg');

    FacileResponse response = await facileRouter(context, '/gadget/listarinventariosemcoleta', {}, showProc: true, addParam: true);

    if (response.isOk()) {
      ///
      /// disponiveis
      ///
      Iterable v = await response.getMapList('inventarios');
      inventarios = v.map((model) => Inventario.fromMap(model)).toList();

      ///
      /// loja
      ///
      v = await response.getMapList('lojas');
      lojasFisicas = v.map((model) => LojaFisica.fromMap(model)).toList();

      modo = ModoInventario.selecionandoLoja;
    } else {
      modo = ModoInventario.semLojaDisponivel;
    }

    setState(() {
      isLoad = false;
    });
  }

  void onFocusKey(context, KeyEvent event) {
    if (leitorPorText) {
      return;
    }

    var s = event.logicalKey.keyLabel.toString().replaceAll('Numpad ', '').replaceAll('Digit ', '').replaceAll('Key ', '').replaceAll('Space', ' ');

    if (event.runtimeType == KeyDownEvent) {
      debugPrint('RegistroPage::onFocusKey::$s');

      if (s == 'Escape') {
        Navigator.pop(context);
      } else if (s == 'Enter' && codigo.isNotEmpty) {
        buscarProdutoPorEan(context);
      } else if (' 01234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ'.contains(s)) {
        if (modo == ModoInventario.coletando) {
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
    List<FormIconButton> listIconButton = [];

    if (gDevice.isWindows) {
      listFloatingActionButton.add(FormFloatingActionButton(
          icon: CupertinoIcons.chevron_down,
          caption: getTextWindowsKey((gDevice.isWindows ? 'VOLTAR' : ''), 'ESC'),
          onTap: () {
            Navigator.pop(context);
          }));
    }

    if (inventarioSelecionado != null && modo == ModoInventario.coletando) {
      listFloatingActionButton.add(FormFloatingActionButton(
          icon: Icons.barcode_reader,
          caption: getTextWindowsKey((gDevice.isWindows ? 'VOLTAR' : 'CONFERIR'), 'ESC'),
          onTap: () {
            verLogs(context);
          }));
    }

    List<Widget> w1 = [];
    List<Widget> w2 = [];

    ///
    /// sem loja disponivel
    ///
    if (modo == ModoInventario.semLojaDisponivel) {
      w1 = [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FacileTheme.headlineLarge(context, 'NENHUMA LOJA DISPONÍVEL PARA COLETA !'),
            ),
          ],
        ),
      ];
    }

    ///
    /// selecionando
    ///
    else if (modo == ModoInventario.selecionandoLoja) {
      w1 = [];

      w1.add(
        FacileTheme.headlineLarge(context, 'SELECIONE A LOJA:'),
      );

      w1.add(getEspacadorDuplo());

      for (var item in inventarios) {
        LojaFisica loja = lojasFisicas.firstWhere((loja) => loja.id == item.idLojaFisica);

        w1.add(
          ElevatedButtonNoIconEx(
            style: ElevatedButton.styleFrom(),
            caption: truncateString(loja.nome, 30),
            onPressed: () async {
              lojaSelecionada = loja;
              inventarioSelecionado = item;
              setState(() {
                modo = ModoInventario.coletando;
              });
            },
          ),
        );

        w1.add(getEspacadorDuplo());
      }
    }

    ///
    /// coletando
    ///
    else if (modo == ModoInventario.coletando) {
      w1 = [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FacileTheme.headlineMedium(context, truncateString(lojaSelecionada!.nome, 25)),
          ],
        ),
        getEspacadorDuplo(),
        SizedBox(
          height: getMaxSizedBoxLottieHeight(context),
          child: svg.isEmpty
              ? const SizedBox()
              : SizedBox(
                  child: SvgPicture.string(
                  svg.replaceAll('#B0BEC5', gTema.colorArray[gTema.cor].toHex().replaceAll('#ff', '#')),
                )
                      .animate(
                        onPlay: (controller) => controller.repeat(reverse: true),
                      )
                      .move(duration: 1000.ms)),
        ),
      ];

      Widget winput = const SizedBox();

      if (leitorPorText) {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        FocusScope.of(context).hasPrimaryFocus;

        winput = TextField(
          onSubmitted: (value) {
            codigo = controllerEan.text;
            controllerEan.text = '';
            buscarProdutoPorEan(context);
          },
          inputFormatters: [
            LengthLimitingTextInputFormatter(80),
          ],
          autofocus: true,
          focusNode: _focusNode,
          controller: controllerEan,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixIcon: Icon(CupertinoIcons.barcode),
            hintText: 'Código de barras...',
            label: Text.rich(
              TextSpan(
                children: <InlineSpan>[
                  WidgetSpan(
                    child: Text(
                      'Ean do produto',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        _focusNode.requestFocus();
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        FocusScope.of(context).hasPrimaryFocus;
      }

      w2 = [
        FacileTheme.headlineLarge(context, 'PASSE O LEITOR', fontSize: gDevice.isTabletAll ? 40 : 30).animate(onPlay: (controller) => controller.repeat()).shimmer(delay: 400.ms, duration: 1000.ms, color: Colors.grey),
        winput,
      ];

      listFloatingActionButton.add(FormFloatingActionButton(
          icon: Icons.document_scanner,
          caption: '',
          onTap: () {
            scanCodigoBarrasEanFornecedor(context);
          }));
    }

    ///
    /// selecionando
    ///
    else if (modo == ModoInventario.aguardandoEnvio) {
      var total = estoqueAtual + quantidade;

      w1 = [
        FacileTheme.displayLarge(context, codigoProduto),
        FacileTheme.headlineMedium(context, nomeProduto),
        FacileTheme.headlineLarge(context, 'ESTOQUE ATUAL: $total').animate(onPlay: (controller) => controller.repeat()).shimmer(delay: 400.ms, duration: 4000.ms, color: Colors.grey),
      ];
      w2 = [
        InkWell(
          onTap: () {
            setState(() {
              quantidade = 0;
            });
          },
          child: PhysicalModel(
            color: Colors.transparent,
            shadowColor: Colors.black,
            elevation: 15.0,
            shape: BoxShape.circle,
            child: ClipOval(
              child: Container(
                color: FacileTheme.getColorHard(context),
                width: 100, // Largura do oval
                height: 100, // Altura do oval
                alignment: Alignment.center,
                child: Text(
                  quantidade.toString(),
                  style: const TextStyle(
                    color: Colors.white, // Cor do texto
                    fontSize: 30, // Tamanho do texto
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        getEspacadorDuplo(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: btnNumero(context, '-')),
            getEspacadorVertical(),
            Expanded(child: btnNumero(context, '+')),
          ],
        ),
        getEspacadorDuplo(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: btnNumero(context, '+3')),
            getEspacadorVertical(),
            Expanded(child: btnNumero(context, '+6')),
            getEspacadorVertical(),
            Expanded(child: btnNumero(context, '+12')),
            getEspacadorVertical(),
            Expanded(child: btnNumero(context, '+24')),
          ],
        ),
        getEspacadorDuplo(),
        ElevatedButtonNoIconEx(
          style: ElevatedButton.styleFrom(),
          caption: 'ENVIAR',
          onPressed: () async {
            adicionarColeta(context);
          },
        ),
        getEspacadorDuplo(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: btnNumero(context, 'Zerar')),
            getEspacadorVertical(),
            Expanded(child: btnNumero(context, 'Voltar')),
          ],
        ),
      ];
    }

    ///
    /// escaneado e pronto para enviar
    ///

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
          appBar: getCupertinoAppBar(context, 'INVENTÁRIO LOJA', listIconButton, isBack: true),
          body: getStackCupertinoAlca(
            context,
            bg,
            getBody(context, w1, w2, flex1: 5, flex2: 5, delay: false),
          ),
        ),
      ),
    );
  }

  Widget btnNumero(context, String caption) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: (caption.substring(0, 1) == '+' || caption.substring(0, 1) == '-') ? Colors.white : FacileTheme.getColorPrimary(context),
        backgroundColor: (caption.substring(0, 1) == '+' || caption.substring(0, 1) == '-') ? FacileTheme.getColorHard(context) : FacileTheme.getShadowColor(context),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      onPressed: () {
        if (caption == 'Voltar') {
          modo = ModoInventario.coletando;
        } else if (caption == 'Zerar') {
          showSimNao(
            context,
            'Aviso',
            'O estoque deste produto será zerado, confirma ?',
            () {
              Navigator.pop(context);
              excluirColeta(context);
            },
          );
        } else if (caption == '+') {
          quantidade += 1;
        } else if (caption == '-') {
          if (quantidade > 0) {
            quantidade -= 1;
          }
        } else if (caption == '+3') {
          quantidade += 3;
        } else if (caption == '+6') {
          quantidade += 6;
        } else if (caption == '+12') {
          quantidade += 12;
        } else if (caption == '+24') {
          quantidade += 24;
        }

        if (quantidade > 99) {
          quantidade = 99;
        }
        setState(() {});
      },
      child: Text(caption),
    );
  }

  Future<void> buscarProdutoPorEan(context) async {
    if (codigo.length == 12) {
      codigo = '0$codigo';
    }

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

      codigoProduto = codigo;
      nomeProduto = produto.nome;
      precoProduto = variacao.preco.toStringAsFixed(2);

      if (mounted) {
        setState(() {
          modo = ModoInventario.aguardandoEnvio;
          estoqueColeta(context);
        });
      }
    } else {
      gDevice.beepErr();
      snackBarMsg(context, response.descricao);
    }

    if (mounted) {
      setState(() {
        codigo = '';
      });
    }
  }

  Future<void> adicionarColeta(context) async {
    if (quantidade == 0) {
      snackBarMsg(context, 'Informe uma quantidade !');
      return;
    }

    Map<String, String> params = {
      'idInventario': inventarioSelecionado!.id.toString(),
      'codigo': codigoProduto,
      'quantidade': quantidade.toString(),
      'modo': 'log',
    };

    FacileResponse response = await facileRouter(context, '/gadget/adicionarcoleta', params, showProc: true, addParam: true);

    if (response.isOk()) {
      snackBarMsg(context, response.descricao);
      setState(() {
        quantidade = 0;
        modo = ModoInventario.coletando;
      });
    } else {
      gDevice.beepErr();
      facileSnackBarError(context, 'Ops!', response.descricao);
    }
  }

  Future<void> excluirColeta(context) async {
    Map<String, String> params = {
      'idInventario': inventarioSelecionado!.id.toString(),
      'codigo': codigoProduto,
    };

    FacileResponse response = await facileRouter(context, '/gadget/excluircoleta', params, showProc: true, addParam: true);

    if (response.isOk()) {
      snackBarMsg(context, response.descricao);
      setState(() {
        quantidade = 0;
        modo = ModoInventario.coletando;
      });
    } else {
      gDevice.beepErr();
      facileSnackBarError(context, 'Ops!', response.descricao);
    }
  }

  Future<void> estoqueColeta(context) async {
    Map<String, String> params = {
      'idInventario': inventarioSelecionado!.id.toString(),
      'codigo': codigoProduto,
    };

    FacileResponse response = await facileRouter(context, '/gadget/estoquecoleta', params, showProc: false, addParam: true);

    if (response.isOk()) {
      estoqueAtual = int.parse(await response.getResult('estoqueAtual', 'data'));
      snackBarMsg(context, response.descricao);
      setState(() {});
    } else {}
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
      codigo = barcodeScanRes;
      buscarProdutoPorEan(context);
    } else {}
  }

  void verLogs(context) async {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => InventarioLogPage(idInventario: inventarioSelecionado!.id),
      ),
    ).then((value) {
      //log('value=$value');
    });

    // showCupertinoModalBottomSheet(
    //   backgroundColor: FacileTheme.getShadowColor(context),
    //   duration: getCupertinoModalBottomSheetDuration(),
    //   context: context,
    //   builder: (context) => InventarioLogPage(idInventario: inventarioSelecionado.id),
    // ).then(
    //   (value) {},
    // );
  }
}
