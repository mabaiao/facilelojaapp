import 'dart:async';
import 'package:facilelojaapp/dados/produtovariacao.dart';
import 'package:facilelojaapp/main.dart';
import 'package:facilelojaapp/util.dart';
import 'package:facilelojaapp/utiltema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/svg.dart';
import 'dados/inventario.dart';
import 'dados/produto.dart';
import 'inventariolog.dart';
import 'utilpost.dart';

enum ModoEntradaProdutos {
  verificandoEntrada,
  criandoEntrada,
  coletandoEntrada,
  aguardandoEnvioColeta,
  entradaEnviadaSucesso,
  inventarioEmAndamento,
}

class EntradaProdutosPage extends StatefulWidget {
  const EntradaProdutosPage({super.key});

  @override
  State<EntradaProdutosPage> createState() => _EntradaProdutosState();
}

class _EntradaProdutosState extends State<EntradaProdutosPage> {
  List<Widget> bg = [];
  String svg = '';
  String svgOk = '';

  bool isLoad = true;
  late String codigo = '';
  late String codigoProduto = '';
  late String nomeProduto = '';
  late String precoProduto = '';
  ModoEntradaProdutos modo = ModoEntradaProdutos.verificandoEntrada;
  Inventario? inventarioSelecionado;

  int quantidade = 0;
  int estoqueAtual = 0;

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
    svg = await getFileData('imagens/produto.svg');
    svgOk = await getFileData('imagens/ok.svg');

    FacileResponse response = await facileRouter(context, '/gadget/inventarioentrada_leratual', {}, showProc: false, addParam: true);

    if (response.isOk()) {
      /**
       * se encontrou desta loja e ativo entra em coleta
       */
      Iterable v = await response.getMap('inventario');
      inventarioSelecionado = Inventario.fromMap(v.first);

      modo = ModoEntradaProdutos.coletandoEntrada;
    } else {
      /** 
       * se nao encontrou entra e modo de criar um novo
       */
      modo = ModoEntradaProdutos.criandoEntrada;
    }
    isLoad = false;
    setState(() {});
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
        if (modo == ModoEntradaProdutos.coletandoEntrada) {
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

    if (inventarioSelecionado != null) {
      listIconButton.add(FormIconButton(
        icon: CupertinoIcons.trash_fill,
        caption: getTextWindowsKey(gDevice.isPhoneAll ? '' : 'Scanner', 'F3'),
        onTap: () {
          cancelarEntrada(context);
        },
      ));
    }

    if (inventarioSelecionado != null) {
      listIconButton.add(FormIconButton(
        icon: Icons.barcode_reader,
        caption: getTextWindowsKey(gDevice.isPhoneAll ? '' : 'Scanner', 'F3'),
        onTap: () {
          verLogs(context);
        },
      ));
    }

    List<Widget> w1 = [];
    List<Widget> w2 = [];

    ///
    /// em andamento nao pode prosseguir
    ///
    if (modo == ModoEntradaProdutos.inventarioEmAndamento) {
      w1 = [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: FacileTheme.headlineLarge(context, 'EXISTE UM INVENTÁRIO EM ANDAMENTO PARA ESTA LOJA !')),
          ],
        ),
      ];
    }

    ///
    /// entrada enviada com sucesso
    ///
    if (modo == ModoEntradaProdutos.entradaEnviadaSucesso) {
      w1 = [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: FacileTheme.headlineLarge(context, 'ESTOQUE ATUALIZADO COM SUCESSO !')),
          ],
        ),
        getEspacadorDuplo(),
        ElevatedButtonNoIconEx(
          style: ElevatedButton.styleFrom(),
          caption: 'CLIQUE PARA FECHAR',
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
      ];
    }

    ///
    /// criar nova entrada
    ///
    if (modo == ModoEntradaProdutos.criandoEntrada) {
      w1 = [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: FacileTheme.headlineLarge(context, 'VAMOS COMEÇAR !')),
          ],
        ),
        getEspacadorDuplo(),
        ElevatedButtonNoIconEx(
          style: ElevatedButton.styleFrom(),
          caption: 'INICIAR ENTRADA PRODUTOS',
          onPressed: () async {
            criarentrada(context);
          },
        ),
      ];
    }

    ///
    /// coletando
    ///

    else if (modo == ModoEntradaProdutos.coletandoEntrada) {
      w1 = [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FacileTheme.headlineMedium(context, truncateString(gLojaFisica!.nome, 25)),
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
      w2 = [
        FacileTheme.headlineLarge(context, 'PASSE O LEITOR', fontSize: gDevice.isTabletAll ? 40 : 30).animate(onPlay: (controller) => controller.repeat()).shimmer(delay: 400.ms, duration: 1000.ms, color: Colors.grey),
        getEspacadorDuplo(),
        ElevatedButtonNoIconEx(
          style: ElevatedButton.styleFrom(),
          caption: 'FINALIZAR ENTRADA PRODUTOS',
          onPressed: () async {
            finalizarEntrada(context);
          },
        ),
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
    else if (modo == ModoEntradaProdutos.aguardandoEnvioColeta) {
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
          appBar: getCupertinoAppBar(context, 'ENTRADA PRODUTOS', listIconButton, isBack: true),
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
          modo = ModoEntradaProdutos.coletandoEntrada;
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
          modo = ModoEntradaProdutos.aguardandoEnvioColeta;
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
      'modo': 'adiciona',
    };

    FacileResponse response = await facileRouter(context, '/gadget/adicionarcoleta', params, showProc: true, addParam: true);

    if (response.isOk()) {
      snackBarMsg(context, response.descricao);
      setState(() {
        quantidade = 0;
        modo = ModoEntradaProdutos.coletandoEntrada;
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
        modo = ModoEntradaProdutos.coletandoEntrada;
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

  Future<void> criarentrada(context) async {
    Map<String, String> params = {};

    FacileResponse response = await facileRouter(context, '/gadget/inventarioentrada_criar', params, showProc: true, addParam: true);

    if (response.isOk()) {
      /**
       * se criou, seleciona
       */
      Iterable v = await response.getMap('inventario');
      inventarioSelecionado = Inventario.fromMap(v.first);

      modo = ModoEntradaProdutos.coletandoEntrada;
    } else {
      /**
       * caso contrario continua
       */
      snackBarMsg(context, response.descricao);
    }
    setState(() {});
  }

  Future<void> finalizarEntrada(context) async {
    showSimNao(
      context,
      'aviso',
      'TUDO CONFERIDO ? ESTA OPERAÇÃO NÃO PODERÁ SER DESFEITA, CONFIRMA ?',
      () async {
        Navigator.pop(context);

        /**
         * enviando
         */

        Map<String, String> params = {
          'idInventario': inventarioSelecionado!.id.toString(),
        };

        FacileResponse response = await facileRouter(context, '/gadget/inventarioentrada_finalizar', params, showProc: true, addParam: true);

        if (response.isOk()) {
          snackBarMsg(context, response.descricao);
          modo = ModoEntradaProdutos.entradaEnviadaSucesso;
        } else {
          gDevice.beepErr();
          facileSnackBarError(context, 'Ops!', response.descricao);
        }

        setState(() {});
      },
    );
  }

  Future<void> cancelarEntrada(context) async {
    showSimNao(
      context,
      'aviso',
      'CANCELAR ENTRADA DE PRODUTOS, CONFIRMA ?',
      () async {
        Navigator.pop(context);

        /**
         * enviando
         */

        Map<String, String> params = {
          'idInventario': inventarioSelecionado!.id.toString(),
        };

        FacileResponse response = await facileRouter(context, '/gadget/inventarioentrada_cancelar', params, showProc: true, addParam: true);

        if (response.isOk()) {
          snackBarMsg(context, response.descricao);
          modo = ModoEntradaProdutos.criandoEntrada;
        } else {
          gDevice.beepErr();
          facileSnackBarError(context, 'Ops!', response.descricao);
        }

        setState(() {});
      },
    );
  }
}
