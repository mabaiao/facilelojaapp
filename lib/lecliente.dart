import 'package:facilelojaapp/main.dart';
import 'package:facilelojaapp/util.dart';
import 'package:facilelojaapp/utiltema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'dados/cadastrounico.dart';
import 'utilpost.dart';

/// **************************
/// Modos
///

enum LeClienteModo {
  cpf,
  cnpj,
  celular,
}

/// **************************
/// Edita dados do cliente
///

class EditaClientePage extends StatefulWidget {
  final String title;
  final LeClienteModo modo;
  final CadastroUnico registro;

  const EditaClientePage({super.key, required this.title, required this.modo, required this.registro});

  @override
  State<EditaClientePage> createState() => _EditaClientePageState();
}

class _EditaClientePageState extends State<EditaClientePage> {
  String svg = '';
  List<Widget> bg = [];

  final TextEditingController controllerNomeValidador = TextEditingController();
  final TextEditingController controllerCelularValidador = TextEditingController();
  final TextEditingController controllerCpfCnpjValidador = TextEditingController();
  final TextEditingController controllerDiaNascimentoValidador = TextEditingController();
  final TextEditingController controllerMesNascimentoValidador = TextEditingController();
  final TextEditingController controllerAnoNascimentoValidador = TextEditingController();

  @override
  void initState() {
    load(context);

    super.initState();
  }

  void load(context) async {
    svg = await getFileData('imagens/documento.svg');

    if (widget.registro.nome.isNotEmpty && widget.registro.nome != 'Sem nome') {
      controllerNomeValidador.text = widget.registro.nome;
    }

    controllerCelularValidador.text = widget.registro.celular;

    if (widget.registro.cpfCnpj.isNotEmpty && widget.registro.cpfCnpj.substring(0, 3) != '000') {
      controllerCpfCnpjValidador.text = widget.registro.cpfCnpj;
    }

    if (widget.registro.diaNascimento.isNotEmpty && widget.registro.diaNascimento != '0') {
      controllerDiaNascimentoValidador.text = widget.registro.diaNascimento;
    }
    if (widget.registro.mesNascimento.isNotEmpty && widget.registro.mesNascimento != '0') {
      controllerMesNascimentoValidador.text = widget.registro.mesNascimento;
    }
    if (widget.registro.anoNascimento.isNotEmpty && widget.registro.anoNascimento != '0') {
      controllerAnoNascimentoValidador.text = widget.registro.anoNascimento;
    }

    setState(() {});
  }

  void onFocusKey(context, RawKeyEvent event) {
    var s = event.logicalKey.keyLabel.toString().replaceAll('Numpad ', '').replaceAll('Digit ', '').replaceAll('Key ', '').replaceAll('Space', ' ');

    if (event.runtimeType == RawKeyDownEvent) {
      debugPrint('EditaClientePage::onFocusKey::$s');

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

    listIconButton.add(FormIconButton(
      icon: Icons.check,
      caption: getTextWindowsKey(gDevice.isPhoneAll ? '' : 'Scanner', 'F4'),
      onTap: () {
        atualizaCliente(context);
      },
    ));

    List<Widget> w2 = [
      getEspacador(),
      FacileTheme.headlineLarge(context, (widget.modo == LeClienteModo.celular ? widget.registro.celular : widget.registro.cpfCnpjF)),
      getEspacadorTriplo(),
      Row(
        children: [
          FacileTheme.headlineSmall(context, 'IDENTIFICAÇÃO CLIENTE'),
        ],
      ),
      getEspacadorDuplo(),

      ///
      /// Nome
      ///

      TextField(
        inputFormatters: [LengthLimitingTextInputFormatter(300)],
        textCapitalization: TextCapitalization.sentences,
        controller: controllerNomeValidador,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.text_format),
          hintText: 'Informe até 100 caracteres',
          label: Text.rich(
            TextSpan(
              children: <InlineSpan>[
                WidgetSpan(
                  child: Text(
                    'Nome',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      getEspacadorDuplo(),

      Row(
        children: [
          FacileTheme.headlineSmall(context, 'DOCUMENTO OPCIONAL'),
        ],
      ),
      getEspacadorDuplo(),

      widget.modo == LeClienteModo.celular
          ? TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(14),
                MaskTextInputFormatter(mask: "##############", filter: {"#": RegExp(r'[0-9]')})
              ],
              autofocus: false,
              controller: controllerCpfCnpjValidador,
              keyboardType: const TextInputType.numberWithOptions(decimal: false),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.keyboard_alt_outlined),
                hintText: 'Informe 11 para CPF ou 14 para CNPJ',
                label: Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      WidgetSpan(
                        child: Text(
                          'CPF ou CNPJ',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const SizedBox(),

      widget.modo != LeClienteModo.celular
          ? TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(15),
                MaskTextInputFormatter(mask: "(##) #####-####", filter: {"#": RegExp(r'[0-9]')})
              ],
              autofocus: false,
              controller: controllerCelularValidador,
              keyboardType: const TextInputType.numberWithOptions(decimal: false),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.keyboard_alt_outlined),
                hintText: 'Informe telefone celular',
                label: Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      WidgetSpan(
                        child: Text(
                          'Número de celular',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const SizedBox(),

      ///
      /// Preços
      ///

      getEspacadorDuplo(),
      Row(
        children: [
          FacileTheme.headlineSmall(context, 'ANIVERSÁRIO OPCIONAL'),
        ],
      ),
      getEspacadorDuplo(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * (gDevice.isTabletLandscape ? 0.15 : 0.25),
            child: TextField(
              inputFormatters: [LengthLimitingTextInputFormatter(2)],
              controller: controllerDiaNascimentoValidador,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.end,
              decoration: const InputDecoration(
                label: Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      WidgetSpan(
                        child: Text(
                          'Dia',
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
              inputFormatters: [LengthLimitingTextInputFormatter(2)],
              controller: controllerMesNascimentoValidador,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.end,
              decoration: const InputDecoration(
                label: Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      WidgetSpan(
                        child: Text(
                          'Mês',
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
              inputFormatters: [LengthLimitingTextInputFormatter(4)],
              controller: controllerAnoNascimentoValidador,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.end,
              decoration: const InputDecoration(
                label: Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      WidgetSpan(
                        child: Text(
                          'Ano',
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
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FacileTheme.headlineSmall(context, 'CONFIRMAR'),
            ],
          ),
          onPressed: () {
            atualizaCliente(context);
          },
        ),
      ),
      getEspacadorTriplo(),
      getEspacadorTriplo(),
      getEspacadorTriplo(),
      getEspacadorTriplo(),
      getEspacadorTriplo(),
      getEspacadorTriplo(),
      getEspacadorTriplo(),
    ];

    List<Widget> w1 = [
      getEspacadorTriplo(),
      FacileTheme.headlineMedium(context, widget.title),
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
    ];

    return Focus(
      autofocus: true,
      onKey: (node, event) {
        onFocusKey(context, event);
        return KeyEventResult.ignored;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: getCupertinoAppBar(
            context,
            'CLIENTE ID ${widget.registro.id}',
            listIconButton,
            addClose: false,
          ),
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
                delay: true,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void atualizaCliente(context) async {
    widget.registro.nome = controllerNomeValidador.text.trim();
    widget.registro.cpfCnpj = controllerCpfCnpjValidador.text.trim();
    widget.registro.celular = controllerCelularValidador.text.trim();
    widget.registro.diaNascimento = controllerDiaNascimentoValidador.text.trim();
    widget.registro.mesNascimento = controllerMesNascimentoValidador.text.trim();
    widget.registro.anoNascimento = controllerAnoNascimentoValidador.text.trim();

    if (widget.registro.nome.isEmpty) {
      facileSnackBarError(context, 'Ops!', 'Nome do cliente deve ser preenchido!');
      return;
    }

    Map<String, String> params = {
      'Funcao': 'AlteraNomeChave',
      'ID': widget.registro.id,
      'Nome': widget.registro.nome,
      'Celular': widget.registro.celular,
      'CpfCnpj': widget.registro.cpfCnpj,
      'diaNascimento': widget.registro.diaNascimento,
      'mesNascimento': widget.registro.mesNascimento,
      'anoNascimento': widget.registro.anoNascimento,
    };

    var aResult = await facilePostEx(context, 'cadastros-clientes.php', params, showProc: false);

    if (aResult == null) {
    } else if (aResult != null && aResult['Status'] == 'OK') {
      snackBarMsg(context, aResult['Msg'], dur: 1000);
      Navigator.pop(context, PopReturns('okClick', ''));
    } else {
      facileSnackBarError(context, 'Ops!', aResult['Msg']);
    }
  }
}

/// **************************
/// Le chave do cliente
///

class LeClientePage extends StatefulWidget {
  final String title;
  final LeClienteModo modo;

  const LeClientePage({super.key, required this.title, required this.modo});

  @override
  State<LeClientePage> createState() => _LeClienteState();
}

class _LeClienteState extends State<LeClientePage> {
  var btnStyle = TextStyle(fontSize: (gDevice.isWindows ? 30 : 20), fontWeight: FontWeight.bold);
  List<FormFloatingActionButton> listFloatingActionButton = [];
  String senha = '';
  List<Widget> bg = [];
  String svg = '';

  @override
  void initState() {
    super.initState();

    iniciaValor(context);

    if (gDevice.isWindows) {
      listFloatingActionButton.add(
        FormFloatingActionButton(
          icon: CupertinoIcons.chevron_down,
          caption: getTextWindowsKey((gDevice.isWindows ? 'CANCELAR' : ''), 'ESC'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      );
    }

    load(context);
  }

  void load(context) async {
    svg = await getFileData('imagens/documento.svg');
    setState(() {});
  }

  void onFocusKey(context, RawKeyEvent event) {
    var s = event.logicalKey.keyLabel.toString().replaceAll('Numpad ', '').replaceAll('Digit ', '').replaceAll('Key ', '').replaceAll('Space', ' ');

    if (event.runtimeType == RawKeyDownEvent) {
      debugPrint('RegistroPage::onFocusKey::$s');

      if (s == 'Escape') {
        Navigator.pop(context);
      } else if (s == 'C') {
        iniciaValor(context);
      } else if (s == 'Enter') {
        retornarValor(context);
      } else if ('1234567890'.contains(s)) {
        if (widget.modo == LeClienteModo.cpf && senha.length < 11) {
          senha += s;
        } else if (widget.modo == LeClienteModo.cnpj && senha.length < 14) {
          senha += s;
        } else if (widget.modo == LeClienteModo.celular && senha.length < 11) {
          senha += s;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (bg.isEmpty) {
      bg = getBackground(context);
    }

    List<Widget> w1 = [
      FacileTheme.headlineMedium(context, widget.title),
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
    ];

    List<Widget> w2 = [
      FacileTheme.headlineLarge(context, formataModo(senha)),
      getEspacadorDuplo(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: btnNumero(context, '1')),
          getEspacadorVertical(),
          Expanded(child: btnNumero(context, '2')),
          getEspacadorVertical(),
          Expanded(child: btnNumero(context, '3')),
        ],
      ),
      getEspacador(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: btnNumero(context, '4')),
          getEspacadorVertical(),
          Expanded(child: btnNumero(context, '5')),
          getEspacadorVertical(),
          Expanded(child: btnNumero(context, '6')),
        ],
      ),
      getEspacador(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: btnNumero(context, '7')),
          getEspacadorVertical(),
          Expanded(child: btnNumero(context, '8')),
          getEspacadorVertical(),
          Expanded(child: btnNumero(context, '9')),
        ],
      ),
      getEspacador(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: btnNumero(context, 'C')),
          getEspacadorVertical(),
          Expanded(child: btnNumero(context, '0')),
          getEspacadorVertical(),
          Expanded(child: btnNumero(context, 'CR')),
        ],
      )
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
          floatingActionButton: getFormFloatingActionButtonList(listFloatingActionButton),
          appBar: getCupertinoAppBar(
            context,
            'ENTRADA',
            [],
          ),
          body: getStackCupertinoAlca(
            context,
            bg,
            getBody(context, w1, w2, flex1: 5, flex2: 5, delay: false),
          ),
        ),
      ),
    );
  }

  Widget btnNumero(context, caption) {
    if (caption == 'C') {
      return ElevatedButtonNoIconEx(
        caption: caption,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red.shade900,
        ),
        onPressed: () {
          gDevice.beep();

          senha = '';
          setState(() {});
        },
      );
    } else if (caption == 'CR') {
      return ElevatedButtonEx(
        caption: '',
        icon: const Icon(
          Icons.keyboard_return_outlined,
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: FacileTheme.getColorPrimary(context),
        ),
        onPressed: () {
          retornarValor(context);
        },
      );
    }
    return ElevatedButtonNoIconEx(
      caption: caption,
      style: ElevatedButton.styleFrom(),
      onPressed: () {
        gDevice.beep();

        if (widget.modo == LeClienteModo.cpf && senha.length < 11) {
          senha += caption;
        } else if (widget.modo == LeClienteModo.cnpj && senha.length < 14) {
          senha += caption;
        } else if (widget.modo == LeClienteModo.celular && senha.length < 11) {
          senha += caption;
        }
        setState(() {});
      },
    );
  }

  void retornarValor(context) async {
    if (senha.trim().isEmpty) {
      gDevice.beepErr();
      facileSnackBarError(context, 'Ops!', '${widget.title}!');
      return;
    }

    String result = senha;

    if (result.length != 11 && result.length != 14) {
      gDevice.beepErr();
      facileSnackBarError(context, 'Ops!', 'Tamanho inválido !');
      return;
    }

    if (widget.modo == LeClienteModo.cpf) {
      if (!CPFValidator.isValid(result)) {
        gDevice.beepErr();
        facileSnackBarError(context, 'Ops!', 'CPF inválido !');
        return;
      }
    }
    if (widget.modo == LeClienteModo.cnpj) {
      if (!CNPJValidator.isValid(result)) {
        gDevice.beepErr();
        facileSnackBarError(context, 'Ops!', 'CNPJ inválido !');
        return;
      }
    }

    Navigator.pop(context, PopReturns('okClick', result));
  }

  String formataModo(str) {
    String result = str;
    return result;
  }

  void iniciaValor(context) {
    senha = '';
  }
}
