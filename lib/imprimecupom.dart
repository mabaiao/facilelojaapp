import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:facilelojaapp/main.dart';
import 'package:facilelojaapp/util.dart';
import 'package:facilelojaapp/utiltema.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:confetti/confetti.dart';

import 'cupom.dart';
import 'dados/empresa.dart';
import 'dados/venda.dart';
import 'dados/vendaitem.dart';
import 'utilpost.dart';

class ImprimeCupomPage extends StatefulWidget {
  final String title;
  final String idVenda;

  const ImprimeCupomPage({super.key, required this.title, required this.idVenda});

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
          digitado: item.digitado,
          eanSistema: item.eanSistema,
          eanFornecedor: item.eanFornecedor,
          nomeCampoVarA: item.nomeCampoVarA,
          nomeCampoVarB: item.nomeCampoVarB,
          nomeCampoVarC: item.nomeCampoVarC,
          qCom: double.parse(item.qCom),
          vUnCom: double.parse(item.vUnCom),
          custoAtual: double.parse(item.custoAtual),
          imagemPrincipal: '',
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

      cupomLido.recalcula();

      if (mounted) {
        setState(() {
          isLoad = false;
          _controllerCenter.play();
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
      caption: getTextWindowsKey('Compartilhar', 'F2'),
      onTap: () {
        imprime(context, 'compartilhar');
      },
    ));

    listFloatingActionButton.add(FormFloatingActionButton(
      icon: Icons.view_list_outlined,
      caption: getTextWindowsKey('Visualizar', 'F2'),
      onTap: () {
        imprime(context, 'visualizar');
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

  void imprime(context, String modo) {
    cupomLido.impressaoCupom(
      context,
      empresa,
      venda,
      opcoesImpressao,
      modo,
    );
  }
}
