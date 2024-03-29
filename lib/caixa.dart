// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:facilelojaapp/produtos.dart';
import 'package:facilelojaapp/produtospesquisa.dart';
import 'package:facilelojaapp/utilpost.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_svg/svg.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'autoriza.dart';
import 'cupom.dart';
import 'dados/cadastrounico.dart';
import 'dados/funcionario.dart';
import 'dados/produto.dart';
import 'dados/produtovariacao.dart';
import 'imprimecupom.dart';
import 'lecliente.dart';
import 'leformapagamento.dart';
import 'levalor.dart';
import 'main.dart';
import 'util.dart';
import 'utiltema.dart';

enum CaixaModo {
  pedidoLoja,
  pedidoZap,
  venda,
}

class CaixaPage extends StatefulWidget {
  final CaixaModo modo;

  const CaixaPage({super.key, required this.modo});

  @override
  State<CaixaPage> createState() => _CaixaPageState();
}

class _CaixaPageState extends State<CaixaPage> {
  String svgSemFoto = '';
  final FocusNode controllerListNode = FocusNode();
  final ScrollController controllerList = ScrollController();

  late Cupom _cupom;

  final TextEditingController controllerBuscaValidador = TextEditingController();

  String stringPesquisa = '';

  double tamanhoFonte = 0;
  bool negritoFonte = false;

  bool painelDeExpansaoPreco = false;

  var vendaPorAtacado = 'N';

  late List<Funcionario> listVendedores = List.empty();
  late CadastroUnico registroCliente;
  late LeClienteModo modoCliente;

  @override
  void initState() {
    loadFuncionarios(context);
    loadSvg(context);

    _cupom = Cupom(
      idLojaFisica: gUsuario.idLojaFisica,
      idEmpresa: gUsuario.idEmpresa,
      idFuncionario: gUsuario.idFuncionario,
      tipoMovimento: (gUsuario.siglaCargo == 'ven' ? CupomTipoMovimento.pedido.index.toString() : CupomTipoMovimento.venda.index.toString()),
      host: gUsuario.host,
    );

    controllerList.addListener(scrollListener);

    super.initState();
  }

  Future<void> loadFuncionarios(context) async {
    Map<String, String> params = {
      'Funcao': 'ListagemVendedores',
    };

    var aResult = await facilePostEx(context, 'funcionarios-consultar.php', params, showProc: false);

    if (aResult == null) {
    } else if (aResult != null && aResult['Status'] == 'OK') {
      Iterable v = await aResult['listVendedores'];
      listVendedores = v.map((model) => Funcionario.fromMap(model)).toList();
    } else {
      facileSnackBarError(context, 'Ops!', aResult['Msg']);
    }
  }

  scrollListener() {
    if (controllerList.offset >= controllerList.position.maxScrollExtent && !controllerList.position.outOfRange) {}
    if (controllerList.offset <= controllerList.position.minScrollExtent && !controllerList.position.outOfRange) {}
  }

  void loadSvg(context) async {
    svgSemFoto = await getFileData('imagens/semfoto.svg');
  }

  void scrollToBottom() {
    if (controllerList.hasClients) {
      final position = controllerList.position.maxScrollExtent + 200;
      controllerList.jumpTo(position);
    }
  }

  void onFocusKey(context, RawKeyEvent event) {
    var s = event.logicalKey.keyLabel.toString().replaceAll('Numpad ', '').replaceAll('Digit ', '').replaceAll('Key ', '').replaceAll('Space', ' ');

    if (event.runtimeType == RawKeyDownEvent) {
      log('CaixaPage::onFocusKey::$s');

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
        //load(context);
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
      buscarProdutoPorEan(context, true);
    } else if (stringPesquisa.isEmpty) {}
  }

  @override
  Widget build(BuildContext context) {
    List<FormIconButton> listIconButton = [];
    List<FormFloatingActionButton> listFloatingActionButton = [];

    if (!painelDeExpansaoPreco) {
      listFloatingActionButton.add(FormFloatingActionButton(
        icon: Icons.menu,
        caption: getTextWindowsKey(gDevice.isPhoneAll ? '' : 'MENU', 'F2'),
        onTap: () {
          var x = painelDeExpansaoPreco;
          setState(() {
            painelDeExpansaoPreco = false;
          });

          Timer(Duration(milliseconds: x ? 499 : 0), () {
            menuPrincipal(context);
          });
        },
      ));
    }

    listIconButton.add(FormIconButton(
      icon: CupertinoIcons.trash,
      caption: getTextWindowsKey(gDevice.isPhoneAll ? '' : 'Scanner', 'F4'),
      onTap: () {
        limparCupom(context);
      },
    ));

    listIconButton.add(FormIconButton(
      icon: CupertinoIcons.barcode,
      caption: getTextWindowsKey(gDevice.isPhoneAll ? '' : 'Scanner', 'F3'),
      onTap: () {
        setState(() {
          painelDeExpansaoPreco = false;
        });
        scanCodigoBarrasEanFornecedor(context);
      },
    ));

    listIconButton.add(FormIconButton(
      icon: Icons.percent_outlined,
      caption: getTextWindowsKey(gDevice.isPhoneAll ? '' : 'Desconto', 'F8'),
      onTap: () {
        menuDescontoGeral(context);
      },
    ));

    if (gUsuario.siglaCargo != 'ven' && widget.modo == CaixaModo.venda) {
      listIconButton.add(FormIconButton(
        icon: Icons.person_2_outlined,
        caption: getTextWindowsKey(gDevice.isPhoneAll ? '' : 'Atendimento', 'F9'),
        onTap: () {
          selecionaAtendimento(context);
        },
      ));
    }

    listIconButton.add(FormIconButton(
      icon: Icons.add_reaction_outlined,
      caption: getTextWindowsKey(gDevice.isPhoneAll ? '' : 'Cliente', 'F9'),
      onTap: () {
        menuInformarCliente(context);
      },
    ));

    listIconButton.add(FormIconButton(
      icon: Icons.credit_card,
      caption: getTextWindowsKey(gDevice.isPhoneAll ? '' : 'Atendimento', 'F9'),
      onTap: () {
        informarMeioPagamento(context);
      },
    ));

    if (gUsuario.siglaCargo == 'ven') {
      _cupom.idFuncionarioComissionado = gUsuario.idFuncionario;
      _cupom.primeiroNomeComissionado = gUsuario.nome;
    }

    listIconButton.add(FormIconButton(
      icon: CupertinoIcons.search,
      caption: getTextWindowsKey(gDevice.isPhoneAll ? '' : 'Busca', 'F4'),
      onTap: () {
        pesquisar(context);
      },
    ));

    List<Widget> w1 = [
      SizedBox(
        height: getMaxSizedBoxHeight(context) *
            (gDevice.isWindows
                ? 0.95
                : gDevice.isTabletLandscape
                    ? 0.95
                    : gDevice.isPhoneAll
                        ? 0.95
                        : 1),
        child: Stack(
          children: [
            getCupomItens(context),
            getMeioPagamento(context),
            getCliente(context),
            getAtendimento(context),
            getFooter(context),
            !painelDeExpansaoPreco && _cupom.itens.isNotEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 40, right: 15),
                            child: getSlogan(context,
                                proporcao: 0.3,
                                title: (widget.modo == CaixaModo.venda
                                    ? 'CAIXA'
                                    : widget.modo == CaixaModo.pedidoLoja
                                        ? 'LOJA'
                                        : 'ZAP')),
                          ),
                        ],
                      ),
                    ],
                  )
                : const SizedBox(),

            ///
            /// Info de quantidade
            ///

            _cupom.itens.isEmpty
                ? const SizedBox()
                : Opacity(
                    opacity: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: gDevice.isTabletAll ? 60 : 30,
                              height: gDevice.isTabletAll ? 60 : 30,
                              decoration: const BoxDecoration(
                                color: Colors.yellow,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  _cupom.qtdProdutos.toStringAsFixed(0),
                                  style: GoogleFonts.anton(
                                    fontWeight: Theme.of(context).textTheme.headlineMedium?.fontWeight,
                                    fontSize: Theme.of(context).textTheme.headlineMedium?.fontSize,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

            ///
            /// Botao pagar
            ///
            !painelDeExpansaoPreco
                ? const SizedBox()
                : Opacity(
                    opacity: .9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        facileDelayedDisplay(
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  ///
                                  /// Verifica obrigacao de informar cliente
                                  ///

                                  if (widget.modo != CaixaModo.venda && (_cupom.idCliente == '0' || registroCliente.nome.isEmpty || registroCliente.nome == 'Sem nome')) {
                                    snackBarMsg(context, 'Informar cliente!', dur: 1000);
                                    setState(() {
                                      painelDeExpansaoPreco = false;
                                    });
                                    Timer(const Duration(milliseconds: 1000), () {
                                      menuInformarCliente(context);
                                    });

                                    return;
                                  }

                                  ///
                                  /// Verifica obrigacao de informar sugestao de pagamento, somente pedido loja
                                  ///

                                  if (widget.modo == CaixaModo.pedidoLoja && _cupom.idSugestaoMeioPagamento == '0') {
                                    snackBarMsg(context, 'Informar meio de pagamento!', dur: 1000);
                                    setState(() {
                                      painelDeExpansaoPreco = false;
                                    });
                                    Timer(const Duration(milliseconds: 1000), () {
                                      informarMeioPagamento(context);
                                    });

                                    return;
                                  }

                                  ///
                                  /// Verifica obrigacao de fazer o pagamento para
                                  ///

                                  if (widget.modo == CaixaModo.venda && _cupom.pagtos.isEmpty) {
                                    snackBarMsg(context, 'Informar pagamento!', dur: 1000);
                                    setState(() {
                                      painelDeExpansaoPreco = false;
                                    });
                                    Timer(const Duration(milliseconds: 1000), () {
                                      //informarMeioPagamento(context);
                                    });

                                    return;
                                  }

                                  emitir(context);
                                },
                                child: AvatarGlow(
                                  glowColor: Colors.green.shade900,
                                  endRadius: 120,
                                  duration: const Duration(milliseconds: 1000),
                                  repeat: true,
                                  showTwoGlows: true,
                                  repeatPauseDuration: const Duration(milliseconds: 100),
                                  child: Material(
                                    elevation: 8.0,
                                    shape: const CircleBorder(),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.green.shade900,
                                      radius: gDevice.isTabletAll ? 80 : 50,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            (gUsuario.siglaCargo == 'ven' ? Icons.send : Icons.point_of_sale_outlined),
                                            size: gDevice.isTabletAll ? 80 : 40,
                                            color: Colors.white,
                                          ),
                                          FacileTheme.headlineMedium(
                                            context,
                                            (gUsuario.siglaCargo == 'ven' ? 'ENVIAR' : 'PAGAR'),
                                            invert: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

            ///
            /// Menu down
            ///

            // painelDeExpansaoPreco
            //     ? const SizedBox()
            //     : Column(
            //         mainAxisAlignment: MainAxisAlignment.end,
            //         children: [
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               ElevatedButtonEx(
            //                 caption: '',
            //                 icon: const Icon(
            //                   Icons.menu,
            //                 ),
            //                 style: ElevatedButton.styleFrom(
            //                   padding: EdgeInsets.all(gDevice.isTabletAll ? 28 : 0),
            //                   backgroundColor: FacileTheme.getColorButton(context),
            //                 ),
            //                 onPressed: () {
            //                   menuPrincipal(context);
            //                 },
            //               ).animate(onPlay: (controller) => controller.repeat()).shake(delay: 1400.ms, duration: 1000.ms),
            //             ],
            //           )
            //         ],
            //       )
          ],
        ),
      )
    ];

    return Focus(
      autofocus: true,
      onKey: (node, event) {
        onFocusKey(context, event);
        return KeyEventResult.ignored;
      },
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: SafeArea(
          child: Scaffold(
            floatingActionButton: getFormFloatingActionButtonList(
              _cupom.itens.isNotEmpty ? listFloatingActionButton : [],
              mainAxisAlignment: MainAxisAlignment.center,
              mini: gDevice.isPhoneSmall ? true : false,
              animate: true,
            ),
            appBar: gDevice.isWindows
                ? null
                : getCupertinoAppBarCheck(
                    context,
                    '', //'${gDevice.isTabletAll ? 'Itens ' : ''}(${_cupom.qtdProdutos.toStringAsFixed(0)})',
                    listIconButton,
                    false,
                    addCheck: false,
                    addBack: false,
                  ),
            body: Column(
              children: w1,
            ),
          ),
        ),
      ),
    );
  }

  Widget getAtendimento(context) {
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

    return _cupom.primeiroNomeComissionado.isEmpty
        ? const SizedBox()
        : Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: getMaxSizedBoxWidth(context) * 0.7,
                    height: (gDevice.isTabletAll ? 80 : 40),
                    //padding: getPaddingDefault(context) * (gDevice.isTabletAll ? 2 : 1),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      gradient: gradient,
                    ),
                    child: Row(
                      children: [
                        gUsuario.imagem.isEmpty
                            ? const SizedBox()
                            : SizedBox(
                                width: (gDevice.isTabletAll ? 50 : 25),
                                height: (gDevice.isTabletAll ? 50 : 25),
                                child: ClipOval(
                                  child: SizedBox.fromSize(
                                    size: Size.fromRadius(
                                      getMaxSizedImagemProfile(context),
                                    ),
                                    child: Image.network(
                                      gUsuario.imagem,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                        FacileTheme.displayMedium(context, _cupom.primeiroNomeComissionado),
                      ],
                    ),
                  ).animate(onPlay: (controller) => controller.repeat()).shimmer(delay: 400.ms, duration: 4000.ms, color: Colors.black54),
                ],
              ),
            ],
          );
  }

  Widget getMeioPagamento(context) {
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

    return _cupom.idSugestaoMeioPagamento == '0'
        ? const SizedBox()
        : Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      painelDeExpansaoPreco = false;
                      informarMeioPagamento(context);
                    },
                    child: Container(
                      width: getMaxSizedBoxWidth(context) * 0.7,
                      height: (gDevice.isTabletAll ? 80 : 40),
                      //padding: getPaddingDefault(context) * (gDevice.isTabletAll ? 2 : 1),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        gradient: gradient,
                      ),
                      child: Row(
                        children: [
                          Icon(getIcon(_cupom.idSugestaoMeioPagamento), size: gDevice.isTabletAll ? 32 : 24),
                          FacileTheme.displayMedium(context, _cupom.nomeSugestaoMeioPagamento.toUpperCase()),
                        ],
                      ),
                    ).animate(onPlay: (controller) => controller.repeat()).shimmer(delay: 400.ms, duration: 4000.ms, color: Colors.black54),
                  ),
                ],
              ),
              SizedBox(height: ((gDevice.isTabletAll ? 80 : 40) + 2) * 2)
            ],
          );
  }

  Widget getCliente(context) {
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

    return _cupom.idCliente == '0'
        ? const SizedBox()
        : Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      painelDeExpansaoPreco = false;
                      editaCliente(
                        context,
                        modoCliente,
                        registroCliente,
                      );
                    },
                    child: Container(
                      width: getMaxSizedBoxWidth(context) * (gDevice.isTabletAll ? 0.8 : 0.9),
                      height: (gDevice.isTabletAll ? 80 : 40),
                      //padding: getPaddingDefault(context) * (gDevice.isTabletAll ? 2 : 1),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        gradient: gradient,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.emoji_emotions_outlined, size: gDevice.isTabletAll ? 32 : 24),
                          FacileTheme.displayMedium(context, '${_cupom.nomeCliente} - ${(modoCliente.index == LeClienteModo.celular.index ? registroCliente.celular : registroCliente.cpfCnpjF)}'),
                        ],
                      ),
                    ).animate(onPlay: (controller) => controller.repeat()).shimmer(delay: 200.ms, duration: 4000.ms, color: Colors.black54),
                  ),
                ],
              ),
              SizedBox(height: (gDevice.isTabletAll ? 80 : 40) + 2)
            ],
          );
  }

  Widget cardProduto(context, index) {
    return const SizedBox();
  }

  Widget getFooter(context) {
    return _cupom.itens.isEmpty
        ? const SizedBox()
        : Opacity(
            opacity: .9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    ///
                    /// Paindel de resumo
                    ///

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              painelDeExpansaoPreco = !painelDeExpansaoPreco;
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: painelDeExpansaoPreco ? 300 : 600),
                            height: painelDeExpansaoPreco
                                ? gDevice.isTabletAll
                                    ? getMaxSizedBoxWidth(context) * .7
                                    : getMaxSizedBoxWidth(context)
                                : gDevice.isTabletAll
                                    ? 180
                                    : 90,
                            width: painelDeExpansaoPreco
                                ? gDevice.isTabletAll
                                    ? getMaxSizedBoxWidth(context) * .8
                                    : getMaxSizedBoxWidth(context)
                                : gDevice.isTabletAll
                                    ? 180
                                    : 90,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: FacileTheme.getColorButton(context),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(painelDeExpansaoPreco
                                      ? gDevice.isTabletAll
                                          ? 500
                                          : 300
                                      : gDevice.isTabletAll
                                          ? 390
                                          : 190),
                                ),
                                color: FacileTheme.getColorHard(context),
                              ),
                              child: Stack(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          ///
                                          /// Total bruto
                                          ///
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0, right: 2),
                                            child: Row(
                                              children: [
                                                AnimatedDefaultTextStyle(
                                                  duration: Duration(milliseconds: painelDeExpansaoPreco ? 600 : 300),
                                                  style: TextStyle(
                                                    fontSize: painelDeExpansaoPreco ? 15 : 0,
                                                    fontWeight: FontWeight.bold,
                                                    //color: Colors.white,
                                                  ),
                                                  child: const Text(
                                                    '(Total) ',
                                                  ),
                                                ),
                                                AnimatedDefaultTextStyle(
                                                  duration: Duration(milliseconds: painelDeExpansaoPreco ? 600 : 300),
                                                  style: TextStyle(
                                                    fontSize: painelDeExpansaoPreco ? 40 : 0,
                                                    fontWeight: FontWeight.bold,
                                                    //color: Colors.white,
                                                  ),
                                                  child: Text(
                                                    _cupom.subTotalF,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          ///
                                          /// Total desconto
                                          ///
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0, right: 2),
                                            child: Row(
                                              children: [
                                                AnimatedDefaultTextStyle(
                                                  duration: Duration(milliseconds: painelDeExpansaoPreco ? 600 : 300),
                                                  style: TextStyle(
                                                    fontSize: painelDeExpansaoPreco ? 15 : 0,
                                                    fontWeight: FontWeight.bold,
                                                    //color: Colors.white,
                                                  ),
                                                  child: const Text(
                                                    '(Desconto) ',
                                                  ),
                                                ),
                                                AnimatedDefaultTextStyle(
                                                  duration: Duration(milliseconds: painelDeExpansaoPreco ? 600 : 300),
                                                  style: TextStyle(
                                                    fontSize: painelDeExpansaoPreco ? 40 : 0,
                                                    fontWeight: FontWeight.bold,
                                                    //color: Colors.white,
                                                  ),
                                                  child: Text(
                                                    _cupom.desconto.toStringAsFixed(2),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          ///
                                          /// Total liquido
                                          ///
                                          !painelDeExpansaoPreco ? const SizedBox() : FacileTheme.displaySmall(context, '(A pagar) ', invert: true),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0, right: 2),
                                            child: AnimatedDefaultTextStyle(
                                              duration: Duration(milliseconds: painelDeExpansaoPreco ? 600 : 300),
                                              style: TextStyle(
                                                fontSize: painelDeExpansaoPreco
                                                    ? gDevice.isTabletAll
                                                        ? 80
                                                        : 60
                                                    : gDevice.isTabletAll
                                                        ? 28
                                                        : 18,
                                                fontWeight: FontWeight.bold,
                                                //color: Colors.white,
                                              ),
                                              child: Text(
                                                _cupom.totalF,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        getEspacadorVertical(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
  }

  Widget getCupomItens(context) {
    tamanhoFonte = double.parse(gParametros.aparenciaPadraoExibicaoNomeProdutoFonte);
    negritoFonte = gParametros.aparenciaPadraoExibicaoNomeProdutoFonteNegrito == 'S';

    if (_cupom.itens.isNotEmpty) {
      return Opacity(
        opacity: painelDeExpansaoPreco ? 0.4 : 1,
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 200),
          controller: controllerList,
          itemCount: _cupom.itens.length,
          itemBuilder: (context, index) => Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            background: Container(
              color: FacileTheme.getColorButton(context),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(Icons.navigate_before),
                    const Icon(Icons.navigate_before),
                    const Icon(Icons.navigate_before),
                    FacileTheme.displayMedium(context, 'REMOVER'),
                  ],
                ),
              ),
            ),
            //onDismissed: (_) {
            confirmDismiss: (DismissDirection direction) async {
              return await removeItem(context, index);
            },

            ///
            /// Item produto da lista
            ///
            child: Container(
              height: gDevice.isTabletAll ? 170 : 130,
              margin: EdgeInsets.only(
                left: 8,
                top: gDevice.isTabletAll ? 5 : 10,
                right: 8,
              ),
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                border: _cupom.itens[index].daVez
                    ? Border.all(
                        color: FacileTheme.getColorHard(context),
                        width: 2,
                      )
                    : Border.all(
                        color: Colors.grey.shade300,
                        width: 2,
                      ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                color: Theme.of(context).colorScheme.background,
              ),
              child: InkWell(
                onTap: () {
                  final action = CupertinoActionSheet(
                    title: FacileTheme.headlineSmall(context, 'ITEM ${index + 1} DO CUPOM'),
                    actions: <Widget>[
                      CupertinoActionSheetAction(
                        isDefaultAction: true,
                        onPressed: () async {
                          Navigator.pop(context);
                          descontoPercentualCupom(context, index: index);
                        },
                        child: FacileTheme.displaySmall(context, "DESCONTO PERCENTUAL"),
                      ),
                      CupertinoActionSheetAction(
                        isDefaultAction: true,
                        onPressed: () async {
                          Navigator.pop(context);
                          descontoFixoCupom(context, index: index);
                        },
                        child: FacileTheme.displaySmall(context, "DESCONTO FIXO"),
                      ),
                      CupertinoActionSheetAction(
                        isDefaultAction: true,
                        onPressed: () async {
                          Navigator.pop(context);
                          setState(() {
                            _cupom.descontoFixoItem('0', index);
                            snackBarMsg(context, 'Desconto removido !');
                          });
                        },
                        child: FacileTheme.displaySmall(context, "LIMPAR DESCONTO"),
                      ),
                      CupertinoActionSheetAction(
                        isDefaultAction: true,
                        onPressed: () async {
                          Navigator.pop(context);

                          aplicaRemove() {
                            setState(() {
                              if (_cupom.remove(index)) {
                                _cupom.limpa();
                              }
                            });
                          }

                          if (gParametros.vendaPedirPermissaoRemoverItem == 'S') {
                            showCupertinoModalBottomSheet(
                              backgroundColor: FacileTheme.getShadowColor(context),
                              duration: getCupertinoModalBottomSheetDuration(),
                              context: context,
                              builder: (context) => const AutorizaPage(title: 'REMOVER ITEM'),
                            ).then(
                              (value) {
                                if (value != null && value == 'ok') {
                                  aplicaRemove();
                                } else {
                                  setState(() {});
                                }
                              },
                            );
                          } else {
                            showSimNao(context, 'REMOVER ITEM ?', '', () async {
                              Navigator.pop(context);
                              aplicaRemove();
                            });
                          }
                        },
                        child: FacileTheme.displaySmall(context, "REMOVER ESTE ITEM DO CUPOM"),
                      ),
                      // CupertinoActionSheetAction(
                      //   isDefaultAction: true,
                      //   onPressed: () async {
                      //     Navigator.pop(context);
                      //     //produtoFotos(context, _cupom.itens[index].idProduto);
                      //     //_verDetalhe(index);
                      //   },
                      //   child: FacileTheme.displaySmall(context, "VER DETALHES DO PRODUTO"),
                      // ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      child: FacileTheme.displaySmall(context, 'CANCELA'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  );

                  var x = painelDeExpansaoPreco;
                  setState(() {
                    painelDeExpansaoPreco = false;
                  });

                  Timer(Duration(milliseconds: x ? 499 : 0), () {
                    showCupertinoModalPopup(context: context, builder: (context) => action).then((value) {});
                  });
                },
                child: Stack(
                  children: [
                    /// **************************
                    /// Image
                    ///
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        /// **************************
                        /// Imagem
                        ///
                        SizedBox(
                          width: gDevice.isWindows || gDevice.isTabletAll ? 160 : 90,
                          height: gDevice.isWindows || gDevice.isTabletAll ? 160 : 90,
                          child: _cupom.itens[index].imagemPrincipal.contains('sem-foto')
                              ? SvgPicture.string(
                                  svgSemFoto.replaceAll(
                                    '#B0BEC5',
                                    gTema.colorArray[gTema.cor].toHex().replaceAll('#ff', '#'),
                                  ),
                                  height: gDevice.isWindows || gDevice.isTabletAll ? 160 : 90,
                                )
                              : getImageDefault(context, _cupom.itens[index].imagemPrincipal, inList: true),
                        ),

                        /// **************************
                        /// EAN
                        ///
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FacileTheme.headlineSmall(context, _cupom.itens[index].digitado),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _cupom.itens[index].nome,
                                        style: GoogleFonts.ubuntuCondensed(
                                          fontSize: (gDevice.isTabletAll || gDevice.isWindows ? 18 : 14) + tamanhoFonte,
                                          fontWeight: negritoFonte ? FontWeight.w900 : FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// **************************
                    /// Item 00x a esqueda
                    ///
                    Opacity(
                      opacity: 0.8,
                      child: Container(
                        height: gDevice.isTabletAll ? 40 : 30,
                        width: gDevice.isTabletAll ? 60 : 40,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            topLeft: Radius.circular(15),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FacileTheme.displayMedium(
                              context,
                              (index + 1).toString().padLeft(3, '0'),
                              invert: true,
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// **************************
                    /// Botoes
                    ///
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: gDevice.isTabletAll ? 50 : 35,
                                width: gDevice.isTabletAll ? 50 : 35,
                                child: FittedBox(
                                  child: FloatingActionButton.extended(
                                    heroTag: null,
                                    onPressed: () {
                                      setState(() {
                                        _cupom.decrementa(index);
                                      });
                                    },
                                    label: const Row(
                                      children: <Widget>[Icon(Icons.remove)],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: gDevice.isTabletAll ? 35 : 25,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    FacileTheme.displayMedium(
                                      context,
                                      _cupom.itens[index].qCom.round().toString(),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: gDevice.isTabletAll ? 50 : 35,
                                width: gDevice.isTabletAll ? 50 : 35,
                                child: FittedBox(
                                  child: FloatingActionButton.extended(
                                    heroTag: null,
                                    onPressed: () {
                                      setState(() {
                                        _cupom.incrementa(index);
                                      });
                                    },
                                    label: const Row(
                                      children: <Widget>[Icon(Icons.add)],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    /// **************************
                    /// Valores
                    ///
                    Opacity(
                      opacity: .8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: gDevice.isTabletAll ? 45 : 35,
                                      width: gDevice.isTabletPortrait ? getMaxSizedBoxWidth(context) * 0.7 : getMaxSizedBoxWidth(context),
                                      padding: const EdgeInsets.all(0),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(15),
                                          topLeft: Radius.circular(15),
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
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            badges.Badge(
                                              badgeContent: _cupom.itens[index].temDesconto ? Icon(Icons.attach_money, color: Colors.white, size: gDevice.isTabletAll ? 10 : 10) : const SizedBox(),
                                              position: badges.BadgePosition.topEnd(top: -20, end: -0),
                                              badgeColor: _cupom.itens[index].temDesconto ? Colors.red : Colors.transparent,
                                              child: Row(
                                                children: [
                                                  FacileTheme.displayMedium(
                                                    context,
                                                    _cupom.itens[index].linhaTotal,
                                                    invert: true,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    /// **************************
                                    /// Sigla variacao
                                    ///

                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.0, left: 4.0),
                                      child: FacileTheme.displayMedium(
                                        context,
                                        _cupom.itens[index].unidadeSigla,
                                        invert: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    ///
                    /// Fim
                    ///
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getEspacadorTriplo(),
          getEspacadorTriplo(),
          gDevice.isPhoneAll || gDevice.isTabletAll ? const SizedBox() : getEspacadorTriplo(),
          gDevice.isPhoneAll || gDevice.isTabletAll ? const SizedBox() : getEspacadorTriplo(),
          gDevice.isPhoneAll || gDevice.isTabletAll ? const SizedBox() : getEspacadorTriplo(),
          Icon(
            Icons.shopping_cart_outlined,
            size: gDevice.isTabletAll ? 150 : 80,
            color: FacileTheme.getColorHard(context),
          ).animate(onPlay: (controller) => controller.repeat()).shake(delay: 1400.ms, duration: 1000.ms),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FacileTheme.headlineLarge(
                      context,
                      widget.modo == CaixaModo.venda
                          ? 'CAIXA LIVRE'
                          : widget.modo == CaixaModo.pedidoLoja
                              ? 'ATENDIMENTO LOJA'
                              : 'ATENDIMENTO WHATSAPP')
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(delay: 400.ms, duration: 4000.ms, color: Colors.grey),
              //FacileTheme.headlineLarge(context, 'LIVRE').animate(onPlay: (controller) => controller.repeat()).shimmer(delay: 400.ms, duration: 4000.ms, color: Colors.grey),
            ],
          ),
          FacileTheme.headlineSmall(context, gUsuario.nomeLojaFisica).animate(onPlay: (controller) => controller.repeat()).shimmer(delay: 400.ms, duration: 4000.ms, color: Colors.grey),
          FacileTheme.headlineSmall(context, gUsuario.nome),
          FacileTheme.headlineSmall(context, 'Terminal ${gUsuario.host} em ${gUsuario.subdominio.toUpperCase()}'),

          _cupom.itens.isNotEmpty
              ? const SizedBox()
              : AvatarGlow(
                  glowColor: FacileTheme.getColorHard(context),
                  endRadius: gDevice.isPhoneSmall ? 90 : 120,
                  duration: const Duration(milliseconds: 1000),
                  repeat: true,
                  showTwoGlows: true,
                  repeatPauseDuration: const Duration(milliseconds: 100),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context, 'back');
                    },
                    child: Material(
                      elevation: 8.0,
                      shape: const CircleBorder(),
                      child: CircleAvatar(
                        backgroundColor: FacileTheme.getColorHard(context),
                        radius: gDevice.isTabletAll ? 80 : 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout_outlined,
                              size: gDevice.isTabletAll ? 80 : 40,
                              color: Colors.white,
                            ),
                            FacileTheme.headlineMedium(
                              context,
                              'SAIR',
                              invert: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

          ///
          /// Selecoes
          ///

          vendaPorAtacado == 'N'
              ? const SizedBox()
              : Padding(
                  padding: EdgeInsets.only(
                    left: getMaxSizedBoxWidth(context) * 0.1,
                    right: getMaxSizedBoxWidth(context) * 0.1,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FacileTheme.headlineSmall(context, 'ATACADO'),
                      ],
                    ),
                    onPressed: () {
                      _cupom.atacado = 'S';
                    },
                  ),
                ),
          vendaPorAtacado == 'N'
              ? const SizedBox()
              : Padding(
                  padding: EdgeInsets.only(
                    left: getMaxSizedBoxWidth(context) * 0.1,
                    right: getMaxSizedBoxWidth(context) * 0.1,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FacileTheme.headlineSmall(context, 'VAREJO'),
                      ],
                    ),
                    onPressed: () {
                      setState(() {
                        _cupom.atacado = 'S';
                      });
                    },
                  ),
                ),
        ],
      );
    }
  }

  void pesquisar(context) {
    //controllerBuscaValidador.text = 'caixa';

    var x = painelDeExpansaoPreco;
    setState(() {
      painelDeExpansaoPreco = false;
    });

    Timer(Duration(milliseconds: x ? 499 : 0), () {
      showCupertinoModalBottomSheet(
        duration: getCupertinoModalBottomSheetDuration(),
        context: context,
        builder: (context) => ProdutosPesquisaPage(param: controllerBuscaValidador.text),
      ).then(
        (value) {
          if (value != null && value.action == 'searchClick') {
            log('value=${value.param.toString()}');
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ProdutosPage(modo: ProdutosModo.selecionarUnico, find: value.param),
              ),
            ).then(
              (value) {
                if (value != null && value.action == 'idClick') {
                  controllerBuscaValidador.text = value.param;
                  log('value=${value.param.toString()}');
                  buscarProdutoPorEan(context, true);
                }
              },
            );
          }
        },
      );
    });
  }

  Future<bool> removeItem(context, index) async {
    aplicaRemove() {
      setState(() {
        if (_cupom.remove(index)) {
          _cupom.limpa();
        }
      });
    }

    var x = painelDeExpansaoPreco;
    setState(() {
      painelDeExpansaoPreco = false;
    });

    if (gParametros.vendaPedirPermissaoRemoverItem == 'S') {
      Timer(Duration(milliseconds: x ? 499 : 0), () {
        showCupertinoModalBottomSheet(
          backgroundColor: FacileTheme.getShadowColor(context),
          duration: getCupertinoModalBottomSheetDuration(),
          context: context,
          builder: (context) => const AutorizaPage(title: 'REMOVER ITEM'),
        ).then(
          (value) {
            if (value != null && value == 'ok') {
              aplicaRemove();
              return true;
            } else {
              setState(() {});
            }
          },
        );
      });
    } else {
      showSimNao(context, 'REMOVER ITEM ?', '', () async {
        Navigator.pop(context);
        aplicaRemove();
      });
      return true;
    }
    return false;
  }

  Future<void> buscarProdutoPorEan(context, viaScanner, {double qtdDefault = 1}) async {
    if (controllerBuscaValidador.text.length == 12 && controllerBuscaValidador.text.substring(0, 3) == '000') {
      controllerBuscaValidador.text = '0${controllerBuscaValidador.text}';
    }

    if (controllerBuscaValidador.text.length == 13 && viaScanner) {
      if (_cupom.temDigitado(controllerBuscaValidador.text, qtdDefault)) {
        //facileBeep(context);
        snackBarMsg(context, 'Adicionado + 1');
        setState(() {
          controllerBuscaValidador.text = '';
        });

        return;
      }
    }

    Map<String, String> params = {
      'Funcao': 'ListagemProdutos',
      'Modo': 'listar',
      'nome': controllerBuscaValidador.text,
    };

    var aResult = await facilePostEx(context, 'facileFlutterApp.php', params, showProc: false);

    if (aResult == null) {
    } else if (aResult != null && aResult['Status'] == 'OK') {
      Iterable vProduto = await aResult['listProdutos'];
      var listProdutos = vProduto.map((model) => Produto.fromMap(model)).toList();

      if (listProdutos.isEmpty) {
        gDevice.beepErr();
        return;
      }

      var produto = listProdutos.first;

      Iterable vVariacoes = jsonDecode(produto.variacoes);
      var variacoes = vVariacoes.map((model) => ProdutoVariacao.fromMap(model)).toList();

      log('CaixaPage::variacoes::${variacoes.toString()}');

      ///
      /// Com variacao
      ///

      if (produto.temVariacaoUnica == 'N') {
        final List<Widget> actions = [];
        var onAutoPress = () async {};
        var onAutoPressAuto = () async {};

        for (var variacao in variacoes) {
          onAutoPress = () async {
            Navigator.pop(context);

            //facileBeep(context);

            double vUnCom = double.parse(variacao.precoVendaVarejo);

            if (double.parse(variacao.precoVendaPromocional) > 0.00) {
              vUnCom = double.parse(variacao.precoVendaPromocional);
            }

            if (double.parse(variacao.precoVendaAtacado) > 0.00 && _cupom.atacado == 'S') {
              vUnCom = double.parse(variacao.precoVendaAtacado);
            }

            final item = CupomItem(
              idProduto: produto.id,
              nome: produto.nome,
              digitado: viaScanner ? controllerBuscaValidador.text : variacao.eanSistema,
              eanSistema: variacao.eanSistema,
              eanFornecedor: variacao.eanFornecedor,
              nomeCampoVarA: variacao.nomeCampoVarA,
              nomeCampoVarB: variacao.nomeCampoVarB,
              nomeCampoVarC: variacao.nomeCampoVarC,
              qCom: qtdDefault,
              vUnCom: vUnCom,
              custoAtual: double.parse(produto.precoCustoFinal),
              imagemPrincipal: produto.imagemPrincipal,
              unidadeSigla: '${variacao.nomeCampoVarA} ${variacao.nomeCampoVarB}',
              temDesconto: double.parse(variacao.precoVendaPromocional) > 0.00,
              atacado: double.parse(variacao.precoVendaAtacado) > 0.00 && _cupom.atacado == 'S',
              vDesc: 0.00,
              precoAplicadoIndice: '0',
              precoAplicado: 0,
              precoTabela: 0,
              precoDesconto: 0,
              precoPromocional: 0,
              peso: 0,
              estoque: 0,
            );
            _cupom.adicionaItem(item);
            snackBarMsg(context, item.nome);

            setState(() {
              scrollToBottom();
              controllerBuscaValidador.text = '';
            });
          };

          final w = CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: onAutoPress,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FacileTheme.headlineSmall(context, '${variacao.nomeCampoVarA} ${variacao.nomeCampoVarB}'),
                    viaScanner && (controllerBuscaValidador.text == variacao.eanFornecedor || controllerBuscaValidador.text == variacao.eanSistema)
                        ? const Icon(Icons.check, color: Colors.green, size: 36)
                        : const SizedBox(),
                  ],
                ),
                FacileTheme.headlineSmall(context, variacao.precoVendaVarejo),
                double.parse(variacao.precoVendaPromocional) > 0.00 ? FacileTheme.headlineSmall(context, 'Promocional:${variacao.precoVendaPromocional}') : const SizedBox(),
                double.parse(variacao.precoVendaAtacado) > 0.00 ? FacileTheme.headlineSmall(context, 'Atacado:${variacao.precoVendaAtacado}') : const SizedBox(),
                FacileTheme.headlineSmall(context, variacao.eanSistema + (variacao.eanFornecedor != '' ? ' / ${variacao.eanFornecedor}' : '')),
              ],
            ),
          );

          if (viaScanner && (controllerBuscaValidador.text == variacao.eanFornecedor || controllerBuscaValidador.text == variacao.eanSistema)) {
            onAutoPressAuto = () async {
              Navigator.pop(context);

              //facileBeep(context);

              double vUnCom = double.parse(variacao.precoVendaVarejo);

              if (double.parse(variacao.precoVendaPromocional) > 0.00) {
                vUnCom = double.parse(variacao.precoVendaPromocional);
              }

              if (double.parse(variacao.precoVendaAtacado) > 0.00 && _cupom.atacado == 'S') {
                vUnCom = double.parse(variacao.precoVendaAtacado);
              }

              final item = CupomItem(
                idProduto: produto.id,
                nome: produto.nome,
                digitado: viaScanner ? controllerBuscaValidador.text : variacao.eanSistema,
                eanSistema: variacao.eanSistema,
                eanFornecedor: variacao.eanFornecedor,
                nomeCampoVarA: variacao.nomeCampoVarA,
                nomeCampoVarB: variacao.nomeCampoVarB,
                nomeCampoVarC: variacao.nomeCampoVarC,
                qCom: qtdDefault,
                vUnCom: vUnCom,
                custoAtual: double.parse(produto.precoCustoFinal),
                imagemPrincipal: produto.imagemPrincipal,
                unidadeSigla: '${variacao.nomeCampoVarA} ${variacao.nomeCampoVarB}',
                temDesconto: double.parse(variacao.precoVendaPromocional) > 0.00,
                atacado: double.parse(variacao.precoVendaAtacado) > 0.00 && _cupom.atacado == 'S',
                vDesc: 0.00,
                precoAplicadoIndice: '0',
                precoAplicado: 0,
                precoTabela: 0,
                precoDesconto: 0,
                precoPromocional: 0,
                peso: 0,
                estoque: 0,
              );
              _cupom.adicionaItem(item);
              snackBarMsg(context, item.nome);

              setState(() {
                scrollToBottom();
                controllerBuscaValidador.text = '';
              });
            };
          }
          actions.add(w);
        }

        final action = CupertinoActionSheet(
          title: FacileTheme.headlineSmall(context, 'SELECIONE'),
          actions: actions,
          cancelButton: CupertinoActionSheetAction(
            child: FacileTheme.headlineSmall(context, 'CANCELA'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );

        var vendaAutoSelecionarProdutoViaScanner = 'N';

        if (controllerBuscaValidador.text.length == 13 && controllerBuscaValidador.text.substring(0, 3) == '000' && vendaAutoSelecionarProdutoViaScanner == 'S') {
          Timer(const Duration(milliseconds: 1000), () {
            onAutoPressAuto();
            controllerBuscaValidador.text = '';

            //_scrollToBottom();
          });
        }

        showCupertinoModalPopup(context: context, builder: (context) => action).then((value) {
          setState(() {
            if (controllerBuscaValidador.text.length == 13 && controllerBuscaValidador.text.substring(0, 3) == '000' && vendaAutoSelecionarProdutoViaScanner == 'S') {
            } else {
              controllerBuscaValidador.text = '';
            }
          });
        });
      }

      ///
      /// Sem variacao - VU
      ///
      else {
        //facileBeep(context);

        final variacao = variacoes.first;

        double vUnCom = double.parse(variacao.precoVendaVarejo);

        if (double.parse(variacao.precoVendaPromocional) > 0.00) {
          vUnCom = double.parse(variacao.precoVendaPromocional);
        }

        if (double.parse(variacao.precoVendaAtacado) > 0.00 && _cupom.atacado == 'S') {
          vUnCom = double.parse(variacao.precoVendaAtacado);
        }

        final item = CupomItem(
          idProduto: produto.id,
          nome: produto.nome,
          digitado: controllerBuscaValidador.text,
          eanSistema: variacao.eanSistema,
          eanFornecedor: variacao.eanFornecedor,
          nomeCampoVarA: variacao.nomeCampoVarA,
          nomeCampoVarB: variacao.nomeCampoVarB,
          nomeCampoVarC: variacao.nomeCampoVarC,
          qCom: qtdDefault,
          vUnCom: vUnCom,
          custoAtual: double.parse(produto.precoCustoFinal),
          imagemPrincipal: produto.imagemPrincipal,
          unidadeSigla: produto.unidadeSigla,
          temDesconto: double.parse(variacao.precoVendaPromocional) > 0.00,
          atacado: double.parse(variacao.precoVendaAtacado) > 0.00 && _cupom.atacado == 'S',
          vDesc: 0.00,
          precoAplicadoIndice: '0',
          precoAplicado: 0,
          precoTabela: 0,
          precoDesconto: 0,
          precoPromocional: 0,
          peso: 0,
          estoque: 0,
        );
        _cupom.adicionaItem(item);
        snackBarMsg(context, item.nome);

        setState(() {
          scrollToBottom();
          controllerBuscaValidador.text = '';
        });
      }
    } else {
      facileSnackBarError(context, 'Ops!', aResult['Msg'], dur: 500);
      setState(() {
        controllerBuscaValidador.text = '';
      });
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

  void descontoPercentualCupom(context, {index = -1}) {
    aplicaDesconto(value) {
      setState(() {
        if (index == -1) {
          _cupom.descontoPercentual(value.param);
        } else {
          _cupom.descontoPercentualItem(value.param, index);
        }
      });
    }

    showCupertinoModalBottomSheet(
      backgroundColor: FacileTheme.getShadowColor(context),
      duration: getCupertinoModalBottomSheetDuration(),
      context: context,
      builder: (context) => LeValorPage(title: 'PERCENTUAL DE DESCONTO', modo: LeValorModo.percentual, limite: double.parse(gParametros.vendaPercentualMaximoDesconto)),
    ).then(
      (value) {
        if (value != null && value.action == 'okClick') {
          if (gParametros.vendaPedirPermissaoDesconto == 'S') {
            showCupertinoModalBottomSheet(
              backgroundColor: FacileTheme.getShadowColor(context),
              duration: getCupertinoModalBottomSheetDuration(),
              context: context,
              builder: (context) => const AutorizaPage(title: 'AUTORIZAR DESCONTO'),
            ).then(
              (autorizado) {
                if (autorizado != null && autorizado == 'ok') {
                  aplicaDesconto(value);
                }
              },
            );
          } else {
            aplicaDesconto(value);
          }
        }
      },
    );
  }

  void descontoFixoCupom(context, {index = -1}) {
    aplicaDesconto(value) {
      setState(() {
        if (index == -1) {
          _cupom.descontoFixo(value.param);
        } else {
          _cupom.descontoFixoItem(value.param, index);
        }
      });
    }

    showCupertinoModalBottomSheet(
      backgroundColor: FacileTheme.getShadowColor(context),
      duration: getCupertinoModalBottomSheetDuration(),
      context: context,
      builder: (context) => LeValorPage(
        title: 'VALOR DE DESCONTO',
        modo: LeValorModo.monetario,
        limite: index == -1 ? _cupom.total : _cupom.itens[index].vTotal,
      ),
    ).then(
      (value) {
        if (value != null && value.action == 'okClick') {
          if (gParametros.vendaPedirPermissaoDesconto == 'S') {
            showCupertinoModalBottomSheet(
              backgroundColor: FacileTheme.getShadowColor(context),
              duration: getCupertinoModalBottomSheetDuration(),
              context: context,
              builder: (context) => const AutorizaPage(title: 'AUTORIZAR DESCONTO'),
            ).then(
              (autorizado) {
                if (autorizado != null && autorizado == 'ok') {
                  aplicaDesconto(value);
                }
              },
            );
          } else {
            aplicaDesconto(value);
          }
        }
      },
    );
  }

  void menuDescontoGeral(context) {
    if (_cupom.itens.isEmpty) {
      return;
    }

    final action = CupertinoActionSheet(
      title: FacileTheme.headlineSmall(context, 'DESCONTO GERAL NO CUPOM'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            descontoPercentualCupom(context);
          },
          child: FacileTheme.displaySmall(context, "PERCENTUAL"),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            descontoFixoCupom(context);
          },
          child: FacileTheme.displaySmall(context, "FIXO"),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            setState(() {
              _cupom.descontoPercentual('0.00');
              snackBarMsg(context, 'Descontos removidos !');
            });
          },
          child: FacileTheme.displaySmall(context, "LIMPAR DESCONTOS"),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: FacileTheme.displaySmall(context, 'CANCELA'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );

    var x = painelDeExpansaoPreco;
    setState(() {
      painelDeExpansaoPreco = false;
    });

    Timer(Duration(milliseconds: x ? 499 : 0), () {
      showCupertinoModalPopup(context: context, builder: (context) => action).then((value) {});
    });
  }

  void selecionaAtendimento(context) {
    final List<Widget> actions = [];

    for (var func in listVendedores) {
      final w = CupertinoActionSheetAction(
        child: FacileTheme.displaySmall(context, func.nome.toUpperCase()),
        onPressed: () async {
          Navigator.pop(context);

          _cupom.idFuncionarioComissionado = func.id;
          _cupom.primeiroNomeComissionado = func.nome;

          setState(() {});
        },
      );

      actions.add(w);
    }

    final w = CupertinoActionSheetAction(
      child: FacileTheme.displaySmall(context, 'REMOVER ATENDIMENTO'),
      onPressed: () async {
        Navigator.pop(context);

        _cupom.idFuncionarioComissionado = '0';
        _cupom.primeiroNomeComissionado = '';

        setState(() {});
      },
    );

    actions.add(w);

    final action = CupertinoActionSheet(
      title: FacileTheme.headlineSmall(context, 'SELECIONE O ATENDIMENTO'),
      actions: actions,
      cancelButton: CupertinoActionSheetAction(
        child: FacileTheme.displaySmall(context, 'CANCELA'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action).then((value) {});
  }

  void menuInformarCliente(context) {
    if (_cupom.itens.isEmpty) {
      return;
    }

    final action = CupertinoActionSheet(
      title: FacileTheme.headlineSmall(context, 'INFORMAR CLIENTE'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            lerCliente(context, 'CPF', LeClienteModo.cpf);
          },
          child: FacileTheme.displaySmall(context, "POR CPF"),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            lerCliente(context, 'CNPJ', LeClienteModo.cnpj);
          },
          child: FacileTheme.displaySmall(context, "POR CNPJ"),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            lerCliente(context, 'NÚMERO TELEFONE', LeClienteModo.celular);
          },
          child: FacileTheme.displaySmall(context, "POR NÚMERO TELEFONE"),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: FacileTheme.displaySmall(context, 'CANCELA'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );

    var x = painelDeExpansaoPreco;
    setState(() {
      painelDeExpansaoPreco = false;
    });

    Timer(Duration(milliseconds: x ? 499 : 0), () {
      showCupertinoModalPopup(context: context, builder: (context) => action).then((value) {});
    });
  }

  void editaCliente(context, LeClienteModo modo, CadastroUnico registro) {
    setState(() {
      _cupom.idCliente = registro.id;
      _cupom.nomeCliente = registro.nome;
    });

    showCupertinoModalBottomSheet(
      backgroundColor: FacileTheme.getShadowColor(context),
      duration: getCupertinoModalBottomSheetDuration(),
      context: context,
      builder: (context) => EditaClientePage(
        title: 'INFORME OS DADOS DO CLIENTE',
        modo: modo,
        registro: registro,
      ),
    ).then(
      (value) {
        if (value != null && value.action == 'okClick') {
          Timer(const Duration(milliseconds: 1000), () {
            setState(() {
              _cupom.idCliente = registro.id;
              _cupom.nomeCliente = registro.nome;
            });
          });
        }
      },
    );
  }

  void lerCliente(context, title, LeClienteModo modo) {
    aplicaCliente(value) async {
      Map<String, String> params = {
        'Funcao': 'Busca',
        'chave': value,
        'tipoChave': (modo.index == LeClienteModo.cpf.index || modo.index == LeClienteModo.cnpj.index ? 'cpfcnpj' : 'celular'),
      };

      var aResult = await facilePostEx(context, 'cadastros-clientes.php', params, showProc: false);

      if (aResult == null) {
      } else if (aResult != null && aResult['Status'] == 'OK') {
        setState(() {
          List<CadastroUnico> listClientes = List.empty();

          Iterable v = aResult['listClientes'];
          listClientes = v.map((model) => CadastroUnico.fromMap(model)).toList();

          if (listClientes.isEmpty) {
            gDevice.beepErr();
            return;
          }

          modoCliente = modo;
          registroCliente = listClientes.first;

          editaCliente(
            context,
            modoCliente,
            registroCliente,
          );
          snackBarMsg(context, aResult['Msg']);
        });
      } else {
        facileSnackBarError(context, 'Ops!', aResult['Msg']);
      }
    }

    showCupertinoModalBottomSheet(
      backgroundColor: FacileTheme.getShadowColor(context),
      duration: getCupertinoModalBottomSheetDuration(),
      context: context,
      builder: (context) => LeClientePage(title: 'INFORME $title CLIENTE', modo: modo),
    ).then(
      (value) {
        if (value != null && value.action == 'okClick') {
          aplicaCliente(value.param);
        }
      },
    );
  }

  Future<void> emitir(context) async {
    var origem = '';

    if (gUsuario.siglaCargo == 'ven') {
      _cupom.idFuncionarioComissionado = gUsuario.idFuncionario;
      _cupom.status = CupomStatus.emAberto.index.toString();

      if (widget.modo == CaixaModo.pedidoLoja) {
        origem = 'appped';
      } else {
        origem = 'appzap';
      }
    } else {
      _cupom.status = CupomStatus.concluido.index.toString();
      origem = 'appven';
    }

    var jItens = [];

    for (var item in _cupom.itens) {
      jItens.add(<String, dynamic>{
        'hash': getUniqueID(),
        'idProduto': item.idProduto,
        'digitado': item.eanSistema,
        'eanSistema': item.eanSistema,
        'eanFornecedor': item.eanFornecedor,
        'nomeCampoVarA': item.nomeCampoVarA,
        'nomeCampoVarB': item.nomeCampoVarB,
        'nomeCampoVarC': item.nomeCampoVarC,
        'qCom': item.qCom,
        'vUnCom': item.vUnCom,
        'vDesc': item.vDesc,
        'vAcre': item.vAcre,
        'vSubTotal': item.vSubTotal,
        'vTotal': item.vTotal,
        'nome': item.nome,
        'precoAplicadoIndice': item.precoAplicadoIndice,
        'precoAplicadoDescricao': (item.precoAplicadoIndice == '0' ? 'Varejo' : 'Atacado'),
        'precoAplicado': item.vUnCom
      });
    }

    var jPagtos = [];

    for (var pagto in _cupom.pagtos) {
      jPagtos.add(<String, dynamic>{
        'hash': getUniqueID(),
        'idMeioPagamento': pagto.idMeioPagamento,
        'nome': pagto.nome,
        'codigoSefaz': pagto.codigoSefaz,
        'gerarXml': pagto.gerarXml,
        'valor': pagto.valor,
        'parcelas': pagto.parcelas,
      });
    }

    var jVenda = <String, dynamic>{
      'hash': getUniqueID(),
      'host': gUsuario.terminalHost,
      'idLoja': _cupom.idLojaFisica,
      'idEmpresa': _cupom.idEmpresa,
      'idFuncionario': gUsuario.idFuncionario,
      'tipoMovimento': _cupom.tipoMovimento,
      'status': _cupom.status, // pendente
      'origem': origem,
      'acrescimo': _cupom.acrescimo,
      'desconto': _cupom.desconto,
      'devolucao': 0,
      'subTotal': _cupom.subTotal,
      'total': _cupom.total,
      'pagoDinheiro': _cupom.pagoDinheiro,
      'pagoOutros': _cupom.pagoOutros,
      'pago': _cupom.pago,
      'troco': _cupom.troco,
      'aPagar': _cupom.aPagar,
      'comissaoTotal': _cupom.subTotal,
      'idFuncionarioComissionado': _cupom.idFuncionarioComissionado,
      'idSugestaoMeioPagamento': _cupom.idSugestaoMeioPagamento,
      'idCliente': _cupom.idCliente,
      'itens': jItens,
      'pagtos': jPagtos,
      'cpfCnpj': registroCliente.cpfCnpj.isNotEmpty && registroCliente.cpfCnpj.substring(0, 3) == '000' ? '' : registroCliente.cpfCnpj,
      'celular': registroCliente.celular,
    };

    var j = json.encode(jVenda);

    log('cupom::$j');

    Map<String, String> params = {
      'Funcao': 'VendaInclui',
      'jsonVenda': j,
    };

    var aResult = await facilePostEx(context, 'facileFlutterApp.php', params, showProc: true);

    if (aResult == null) {
    } else if (aResult != null && aResult['Status'] == 'OK') {
      _cupom.idVenda = aResult['idVenda'];
      imprime(context);
      // setState(() {
      //   painelDeExpansaoPreco = false;
      //   _cupom.limpa();6
      // });
    } else {
      facileSnackBarError(context, 'Ops!', aResult['Msg']);
    }
  }

  void imprime(context) {
    showCupertinoModalBottomSheet(
      backgroundColor: FacileTheme.getShadowColor(context),
      duration: getCupertinoModalBottomSheetDuration(),
      context: context,
      builder: (context) => ImprimeCupomPage(title: 'PEDIDO ENVIADO COM SUCESSO !', idVenda: _cupom.idVenda),
    ).then(
      (value) {
        if (value != null && value == 'ok') {}
      },
    );
  }

  void menuPrincipal(context) {
    if (_cupom.itens.isEmpty) {
      return;
    }

    final action = CupertinoActionSheet(
      title: FacileTheme.headlineSmall(context, 'MENU'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            limparCupom(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.trash,
                color: FacileTheme.getColorHard(context),
              ),
              FacileTheme.displaySmall(context, "LIMPAR CUPOM"),
            ],
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            setState(() {
              painelDeExpansaoPreco = false;
            });
            scanCodigoBarrasEanFornecedor(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.barcode,
                color: FacileTheme.getColorHard(context),
              ),
              FacileTheme.displaySmall(context, "SCANNER PRODUTO"),
            ],
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            menuDescontoGeral(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.percent_outlined,
                color: FacileTheme.getColorHard(context),
              ),
              FacileTheme.displaySmall(context, "DESCONTO GERAL NO CUPOM"),
            ],
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            menuInformarCliente(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_reaction_outlined,
                color: FacileTheme.getColorHard(context),
              ),
              FacileTheme.displaySmall(context, "INFORMAR CLIENTE"),
            ],
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            informarMeioPagamento(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.payment_outlined,
                color: FacileTheme.getColorHard(context),
              ),
              FacileTheme.displaySmall(context, "INFORMAR MEIO DE PAGAMENTO"),
            ],
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            Navigator.pop(context);
            pesquisar(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.search,
                color: FacileTheme.getColorHard(context),
              ),
              FacileTheme.displaySmall(context, "PESQUISAR PRODUTOS"),
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

    showCupertinoModalPopup(context: context, builder: (context) => action).then((value) {});
  }

  void limparCupom(context) {
    if (_cupom.itens.isEmpty) {
      return;
    }

    var x = painelDeExpansaoPreco;
    setState(() {
      painelDeExpansaoPreco = false;
    });

    Timer(Duration(milliseconds: x ? 499 : 0), () {
      if (gParametros.vendaPedirPermissaoLimparCupom == 'S') {
        showCupertinoModalBottomSheet(
          backgroundColor: FacileTheme.getShadowColor(context),
          duration: getCupertinoModalBottomSheetDuration(),
          context: context,
          builder: (context) => const AutorizaPage(title: 'LIMPAR CUPOM'),
        ).then(
          (value) {
            if (value != null && value == 'ok') {
              setState(() {
                _cupom.limpa();
              });
            }
          },
        );
      } else {
        showSimNao(context, 'LIMPAR CUPOM ?', '', () async {
          Navigator.pop(context);
          setState(() {
            _cupom.limpa();
          });
        });
      }
    });
  }

  void informarMeioPagamento(context) {
    if (_cupom.itens.isEmpty) {
      return;
    }

    showCupertinoModalBottomSheet(
      backgroundColor: FacileTheme.getShadowColor(context),
      duration: getCupertinoModalBottomSheetDuration(),
      context: context,
      builder: (context) => const LeFormaPagamentoPage(),
    ).then((value) {
      if (value != null && value.action == 'okClick') {
        _cupom.idSugestaoMeioPagamento = value.param[0];
        _cupom.nomeSugestaoMeioPagamento = value.param[1];
        setState(() {});
      } else {}
    });
  }

  IconData getIcon(String id) {
    if (id == '1') {
      return Icons.money;
    } else if (id == '2') {
      return CupertinoIcons.qrcode;
    } else if (int.parse(id) >= 14) {
      return CupertinoIcons.creditcard;
    }
    return Icons.credit_card;
  }

  ///
  /// Fim
  ///
}
