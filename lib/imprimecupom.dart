import 'dart:convert';
import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:facilelojaapp/main.dart';
import 'package:facilelojaapp/util.dart';
import 'package:facilelojaapp/utiltema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:confetti/confetti.dart';

import 'cupom.dart';
import 'dados/empresa.dart';
import 'dados/terminalimpressao.dart';
import 'dados/venda.dart';
import 'dados/vendaitem.dart';
import 'dados/vendapagto.dart';
import 'utilpost.dart';

class ImprimeCupomPage extends StatefulWidget {
  final String title;
  final String idVenda;
  final bool showConfetti;

  const ImprimeCupomPage({super.key, required this.title, required this.idVenda, this.showConfetti = true});

  @override
  State<ImprimeCupomPage> createState() => _ImprimeCupomState();
}

class _ImprimeCupomState extends State<ImprimeCupomPage> {
  late ConfettiController _controllerCenter;
  List<Widget> bg = [];
  String svg = '';

  late Cupom cupomLido;
  late Empresa empresa;
  late Venda venda;
  late List<VendaItem> vendaItens;
  late List<VendaPagto> vendaPagtos;
  late dynamic opcoesImpressao;

  bool isLoad = true;

  @override
  void initState() {
    super.initState();

    _controllerCenter = ConfettiController(duration: const Duration(seconds: 1));

    load(context);
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  void load(context) async {
    svg = await getFileData('imagens/imprime.svg');

    setState(() {});

    ///
    /// Le os dados da venda
    ///

    Map<String, String> params = {
      'Funcao': 'VendaLe',
      'idVenda': widget.idVenda,
    };

    var aResult = await facilePostEx(context, 'facileFlutterApp.php', params, showProc: false);

    if (aResult == null) {
    } else if (aResult != null && aResult['Status'] == 'OK') {
      ///
      /// Empresa
      ///

      Iterable v = await aResult['empresas'];
      List<Empresa> listEmpresa = v.map((model) => Empresa.fromMap(model)).toList();
      empresa = listEmpresa.first;
      log(empresa.toString());

      ///
      /// Venda
      ///

      v = await aResult['vendas'];
      List<Venda> listVenda = v.map((model) => Venda.fromMap(model)).toList();
      venda = listVenda.first;
      log(venda.toString());

      ///
      /// itens da venda
      ///

      v = await aResult['vendaItens'];
      vendaItens = v.map((model) => VendaItem.fromMap(model)).toList();
      log(vendaItens.toString());

      ///
      /// Pagamentos
      ///

      v = await aResult['vendaPagtos'];
      vendaPagtos = v.map((model) => VendaPagto.fromMap(model)).toList();
      log(vendaPagtos.toString());

      ///
      /// Opcoes de impressao
      ///

      opcoesImpressao = aResult['opcoesImpressao'];

      ///
      /// Inicia o cupom
      ///

      cupomLido = Cupom(
        host: venda.host,
        tipoMovimento: venda.tipoMovimento,
        idFuncionario: venda.idFuncionario,
        idLojaFisica: venda.idLoja,
        idEmpresa: venda.idEmpresa,
      );

      cupomLido.idPai = venda.idPai;
      cupomLido.cpfCnpj = venda.cpfCnpj;
      cupomLido.celular = venda.celular;
      cupomLido.email = venda.email;
      cupomLido.nomeCliente = venda.nomeCliente;
      cupomLido.enderecoCliente = venda.enderecoCliente;
      cupomLido.idCliente = venda.idCliente;
      cupomLido.status = venda.status;
      cupomLido.idFuncionarioComissionado = venda.idFuncionarioComissionado;
      cupomLido.primeiroNomeComissionado = venda.nomeFuncionarioComissionado;

      for (var item in vendaItens) {
        var o = CupomItem(
          idProduto: item.idProduto,
          nome: item.nome,
          categoriaNome: item.categoriaNome,
          digitado: item.digitado,
          eanSistema: item.eanSistema,
          eanFornecedor: item.eanFornecedor,
          nomeCampoVarA: item.nomeCampoVarA,
          nomeCampoVarB: item.nomeCampoVarB,
          nomeCampoVarC: item.nomeCampoVarC,
          qCom: double.parse(item.qCom),
          vUnCom: double.parse(item.vUnCom),
          custoAtual: double.parse(item.custoAtual),
          imagemPrincipal: item.imagemPrincipal,
          unidadeSigla: item.nomeCampoVarA,
          temDesconto: double.parse(item.vDesc) > 0.00,
          atacado: false,
          vDesc: double.parse(item.vDesc),
          precoAplicadoIndice: '0',
          precoAplicado: double.parse(item.precoAplicado),
          precoTabela: double.parse(item.custoAtual),
          precoDesconto: 0,
          precoPromocional: 0,
          peso: 0,
          estoque: 0,
        );
        cupomLido.adicionaItem(o);
      }

      for (var item in vendaPagtos) {
        var o = CupomPagto(
          codigoSefaz: item.codigoSefaz,
          idMeioPagamento: item.idMeioPagamento,
          gerarXml: item.gerarXml,
          nome: item.nome,
          parcelas: int.parse(item.parcelas),
          valor: double.parse(item.valor),
        );
        cupomLido.adicionaPagto(context, o);
      }

      cupomLido.recalcula();

      if (mounted) {
        setState(() {
          isLoad = false;
          if (widget.showConfetti) {
            _controllerCenter.play();
          }
        });
      }

      ///
      ///
      ///
    } else {
      facileSnackBarError(context, 'Ops!', aResult['Msg']);
    }
  }

  void onFocusKey(context, RawKeyEvent event) {
    var s = event.logicalKey.keyLabel.toString().replaceAll('Numpad ', '').replaceAll('Digit ', '').replaceAll('Key ', '').replaceAll('Space', ' ');

    if (event.runtimeType == RawKeyDownEvent) {
      debugPrint('RegistroPage::onFocusKey::$s');

      if (s == 'Escape') {
        Navigator.pop(context);
      } else if (s == 'C') {
      } else if (s == 'Enter') {}
    }
  }

  @override
  Widget build(BuildContext context) {
    if (bg.isEmpty) {
      bg = getBackground(context);
    }

    List<FormFloatingActionButton> listFloatingActionButton = [];

    listFloatingActionButton.add(FormFloatingActionButton(
      icon: Icons.share_outlined,
      caption: getTextWindowsKey('', 'F2'),
      onTap: () {
        menuFont(context, 'compartilhar');
      },
    ));

    if (gUrlPost.nomeVersaoApp == 'Versão local') {
      listFloatingActionButton.add(FormFloatingActionButton(
        icon: Icons.window,
        caption: getTextWindowsKey('Windows', 'F4'),
        onTap: () {
          menuEnviaFilaWindows(context);
        },
      ));
    }

    listFloatingActionButton.add(FormFloatingActionButton(
      icon: Icons.view_list_outlined,
      caption: getTextWindowsKey('Ver', 'F2'),
      onTap: () {
        menuVer(context);
      },
    ));

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
          FacileTheme.headlineMedium(context, isLoad ? 'AGUARDE...' : widget.title),
        ],
      ),
    ];

    List<Widget> w2 = [
      InkWell(
        onTap: () {
          imprime(context, 'imprimir');
        },
        child: AvatarGlow(
          glowColor: isLoad ? Colors.grey : FacileTheme.getColorHard(context),
          endRadius: 120,
          duration: const Duration(milliseconds: 1000),
          repeat: true,
          showTwoGlows: true,
          repeatPauseDuration: const Duration(milliseconds: 100),
          child: Material(
            elevation: 8.0,
            shape: const CircleBorder(),
            child: CircleAvatar(
              backgroundColor: isLoad ? Colors.grey : FacileTheme.getColorHard(context),
              radius: gDevice.isTabletAll ? 80 : 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isLoad ? Icons.print_disabled : Icons.print,
                    size: gDevice.isTabletAll ? 80 : 40,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ];

    return Focus(
      autofocus: true,
      onKey: (node, event) {
        onFocusKey(context, event);
        setState(() {});
        return KeyEventResult.ignored;
      },
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: getFormFloatingActionButtonList(listFloatingActionButton, isLoad: isLoad),
          appBar: getCupertinoAppBar(
            context,
            'IMPRESSÃO',
            [],
          ),
          body: Stack(
            children: [
              getStackCupertinoAlca(
                context,
                bg,
                getBody(context, w1, w2, flex1: 5, flex2: 5, delay: false),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  maximumSize: const Size(20, 20),
                  shouldLoop: false,
                  confettiController: _controllerCenter,
                  blastDirectionality: BlastDirectionality.explosive,
                  maxBlastForce: 20,
                  minBlastForce: 8,
                  emissionFrequency: .3,
                  gravity: .1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void imprime(context, String modo, {estilizado = false, noFont = '1'}) {
    cupomLido.impressaoCupom(
      context,
      empresa,
      venda,
      opcoesImpressao,
      modo,
      formato: (modo == 'compartilhar' || estilizado ? 'estilo' : ''),
      noFont: noFont,
    );
  }

  void menuEnviaFilaWindows(context) async {
    if (gUsuario.terminaisImpressao.isEmpty) {
      facileSnackBarError(context, 'Ops!', 'Nenhum impressora windows configurada !');
    }

    List<Widget> acts = [];

    Iterable va = jsonDecode(gUsuario.terminaisImpressao);
    List<TerminalImpressao> listTerminalImpressao = va.map((model) => TerminalImpressao.fromMap(model)).toList();

    for (var item in listTerminalImpressao) {
      acts.add(
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            enviaFilaWindows(context, item);
          },
          child: Column(
            children: [
              FacileTheme.displayLarge(context, item.nome),
              FacileTheme.displaySmall(context, '${item.nomeSistema} (${item.hostTerminal})'),
            ],
          ),
        ),
      );
    }

    final action = CupertinoActionSheet(
      title: FacileTheme.headlineSmall(context, 'SELECIONE A IMPRESSORA'),
      actions: acts,
      cancelButton: CupertinoActionSheetAction(
        child: FacileTheme.displaySmall(context, 'CANCELA'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );

    showCupertinoModalPopup(context: context, builder: (context) => action).then((value) {});
  }

  void enviaFilaWindows(context, TerminalImpressao item) async {
    Uint8List bytes = await cupomLido.impressaoCupom(
      context,
      empresa,
      venda,
      opcoesImpressao,
      'na',
    );

    Map<String, String> params = {
      'Funcao': 'EnviaFilaImpressao',
      'bytes': base64Encode(bytes),
      'idTerminal': item.id,
    };

    var aResult = await facilePostEx(context, 'facileFlutterApp.php', params, showProc: true);

    if (aResult == null) {
    } else if (aResult != null && aResult['Status'] == 'OK') {
      snackBarMsg(context, aResult['Msg'], dur: 3000);
    } else {
      facileSnackBarError(context, 'Ops!', aResult['Msg']);
    }
  }

  void menuVer(context) {
    final action = CupertinoActionSheet(
      title: FacileTheme.headlineSmall(context, 'VISUALIZAR'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            menuFont(context, 'visualizar');
          },
          child: FacileTheme.displaySmall(context, "ESTILIZADO"),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            imprime(context, 'visualizar');
          },
          child: FacileTheme.displaySmall(context, "NORMAL"),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: FacileTheme.displaySmall(context, 'CANCELA'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );

    showCupertinoModalPopup(context: context, builder: (context) => action).then((value) {});
  }

  void menuFont(context, modo) async {
    final action = CupertinoActionSheet(
      title: FacileTheme.headlineSmall(context, 'ESCOLHA O ESTILO'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            imprime(context, modo, estilizado: true, noFont: '1');
          },
          child: Text(
            "ESTE É O ESTILO DA FONTE",
            style: await getFontScr('1'),
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            imprime(context, modo, estilizado: true, noFont: '2');
          },
          child: Text(
            "ESTE É O ESTILO DA FONTE",
            style: await getFontScr('2'),
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            imprime(context, modo, estilizado: true, noFont: '3');
          },
          child: Text(
            "ESTE É O ESTILO DA FONTE",
            style: await getFontScr('3'),
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            imprime(context, modo, estilizado: true, noFont: '4');
          },
          child: Text(
            "ESTE É O ESTILO DA FONTE",
            style: await getFontScr('4'),
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            imprime(context, modo, estilizado: true, noFont: '5');
          },
          child: Text(
            "ESTE É O ESTILO DA FONTE",
            style: await getFontScr('5'),
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            imprime(context, modo, estilizado: true, noFont: '6');
          },
          child: Text(
            "ESTE É O ESTILO DA FONTE",
            style: await getFontScr('6'),
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            imprime(context, modo, estilizado: true, noFont: '7');
          },
          child: Text(
            "ESTE É O ESTILO DA FONTE",
            style: await getFontScr('7'),
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            imprime(context, modo, estilizado: true, noFont: '8');
          },
          child: Text(
            "ESTE É O ESTILO DA FONTE",
            style: await getFontScr('8'),
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            imprime(context, modo, estilizado: true, noFont: '9');
          },
          child: Text(
            "ESTE É O ESTILO DA FONTE",
            style: await getFontScr('9'),
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            imprime(context, modo, estilizado: true, noFont: '10');
          },
          child: Text(
            "ESTE É O ESTILO DA FONTE",
            style: await getFontScr('10'),
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            imprime(context, modo, estilizado: true, noFont: '11');
          },
          child: Text(
            "ESTE É O ESTILO DA FONTE",
            style: await getFontScr('11'),
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            imprime(context, modo, estilizado: true, noFont: '12');
          },
          child: Text(
            "ESTE É O ESTILO DA FONTE",
            style: await getFontScr('12'),
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            imprime(context, modo, estilizado: true, noFont: '13');
          },
          child: Text(
            "ESTE É O ESTILO DA FONTE",
            style: await getFontScr('13'),
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            imprime(context, modo, estilizado: true, noFont: '14');
          },
          child: Text(
            "ESTE É O ESTILO DA FONTE",
            style: await getFontScr('14'),
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            imprime(context, modo, estilizado: true, noFont: '15');
          },
          child: Text(
            "ESTE É O ESTILO DA FONTE",
            style: await getFontScr('15'),
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

    showCupertinoModalPopup(context: context, builder: (context) => action).then((value) {});
  }
}
