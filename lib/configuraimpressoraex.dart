// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:developer';
import 'package:facilelojaapp/main.dart';
import 'package:facilelojaapp/util.dart';
import 'package:facilelojaapp/utiltema.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

/// **************************
/// ConfiguraImpressoraEx
///

class ConfiguraImpressoraExPage extends StatefulWidget {
  const ConfiguraImpressoraExPage({super.key});

  @override
  State<ConfiguraImpressoraExPage> createState() => _ConfiguraImpressoraExState();
}

class _ConfiguraImpressoraExState extends State<ConfiguraImpressoraExPage> {
  List<Widget> bg = [];
  String scanModo = 'wait';
  String svg = '';

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _device;

  @override
  void initState() {
    super.initState();

    /// **************************
    /// Força pedir permissão se precisar
    ///
    log('ConfiguraImpressoraExPage::Solicitando permissão...');
    load(context);
  }

  void load(context) async {
    svg = await getFileData('imagens/search.svg');
    setState(() {});
  }

  @override
  void dispose() {
    log('ConfiguraImpressoraExPage::Fim da conexão dispose.');
    super.dispose();
  }

  void onFocusKey(context, RawKeyEvent event) {
    var s = event.logicalKey.keyLabel.toString().replaceAll('Numpad ', '').replaceAll('Digit ', '').replaceAll('Key ', '').replaceAll('Space', ' ');

    if (event.runtimeType == RawKeyDownEvent) {
      log('ConfiguraImpressoraExPage::onFocusKey::$s');

      if (s == 'Escape') {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (bg.isEmpty) {
      bg = getBackground(context);
    }

    List<Widget> w1 = [
      const Hero(
        tag: 'heroPad7',
        child: Icon(
          Icons.print_outlined,
          size: 100,
        ),
      ),
    ];

    if (scanModo == 'wait') {
      w1.add(
        // SizedBox(
        //   width: getMaxSizedBoxLottie(context),
        //   child: Lottie.asset('imagens/configuraimpressoraWait.json'),
        // ),
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
      );
    }

    if (scanModo == 'scan') {
      w1.add(
        SizedBox(
          width: getMaxSizedBoxLottie(context),
          child: Lottie.asset('imagens/configuraimpressoraBlue.json'),
        ),
      );
    }

    if (scanModo == 'ok') {
      w1.add(
        SizedBox(
          width: getMaxSizedBoxLottie(context),
          child: Lottie.asset('imagens/configuraimpressoraOk.json'),
        ),
      );
    }

    List<Widget> w2 = [
      (gUsuario.printerName.isEmpty || scanModo == 'scan' ? const SizedBox() : FacileTheme.displaySmall(context, 'Em ${gUsuario.printerName}')),
      (gUsuario.printerName.isEmpty || scanModo == 'scan' ? const SizedBox() : FacileTheme.displaySmall(context, gUsuario.printerAddress)),
      getEspacadorDuplo(),
      (scanModo == 'scan'
          ? FacileTheme.headlineMedium(context, 'BUSCANDO...')
          : (scanModo == 'ok'
              ? FacileTheme.headlineMedium(context, 'IMPRESSORA CONFIGURADA !')
              : Column(
                  children: [
                    ElevatedButtonNoIconEx(
                      caption: 'BUSCAR IMPRESSORAS',
                      style: ElevatedButton.styleFrom(),
                      onPressed: () {
                        scanModo = 'scan';
                        setState(() {});

                        Timer(const Duration(milliseconds: 1000), () {
                          buscaImpressora();
                        });
                      },
                    ),
                  ],
                )))
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
          floatingActionButton: getFormFloatingActionButtonList([]),
          appBar: getCupertinoAppBarCheck(context, 'CONFIGURAR IMPRESSORA CUPOM', [], false),
          body: getStackCupertino(
            context,
            bg,
            getBody(context, w1, w2, flex1: 5, flex2: 5, mainAxisAlignment: MainAxisAlignment.start, delay: false),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Future<Uint8List> getPrintTest() async {
    final doc = pw.Document();

    final fontTitulo = await PdfGoogleFonts.staatlichesRegular();

    double inch = 72.0;
    double mm = inch / 25.4;

    String impressaoTamanhoPapel = '58';
    double impressaoTamanhoFonteTitulo = 14;

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(double.parse(impressaoTamanhoPapel) * mm, double.infinity, marginAll: 1 * mm),
        build: (pw.Context context) {
          return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text(
              'Nome da sua empresa',
              style: pw.TextStyle(font: fontTitulo, fontSize: impressaoTamanhoFonteTitulo, fontWeight: pw.FontWeight.normal),
              textAlign: pw.TextAlign.center,
            ),
          ]);
        },
      ),
    );

    //Printing.sharePdf(bytes: await doc.save());

    // final appDir = await syspaths.getTemporaryDirectory();
    // log('ConfiguraImpressoraExPage::FILE::$appDir');
    // File file = File('${appDir.path}/example.pdf');
    // await file.writeAsBytes(await doc.save());

    return await doc.save();
  }

  Future<void> buscaImpressora() async {
    await bluetooth.isConnected;

    try {
      _devices = await bluetooth.getBondedDevices();
      printBluetoothSuccess('Sucesso devices bluetooth lidos !');
    } on PlatformException {
      printBluetoothError('Erro em bluetooth getBondedDevices !');
    }

    bluetooth.onStateChanged().listen(
      (state) async {
        switch (state) {
          case BlueThermalPrinter.CONNECTED:
            printBluetoothSuccess('Sucesso impressora ${gUsuario.printerName} bluetooth conectado !');
            printBluetoothTest();
            break;
          case BlueThermalPrinter.STATE_ON:
            printBluetoothSuccess('Sucesso bluetooth estado conectado !');
            if (printBluetoothFindPrinter()) {
              printBluetoothSave();
              log('ConfiguraImpressoraExPage::conectando...');

              // Future<bool?> bConn = bluetooth.isDeviceConnected(_device!);
              // if (!bConn) {
              //   bluetooth.disconnect();
              // }

              try {} on PlatformException {
                log('Desconecta impressora não necessário !');
              }

              try {
                bluetooth.connect(_device!);
              } on PlatformException {
                log('Erro conectando impressora !');
              } on Exception {
                log('Erro conectando impressora2 !');
              } finally {
                log('Erro conectando impressora F !');
              }
            } else {
              printBluetoothError('Impressora não encontrada !');
            }

          case BlueThermalPrinter.DISCONNECTED:
            printBluetoothError('Erro bluetooth desconectando !');
            break;

          case BlueThermalPrinter.DISCONNECT_REQUESTED:
            printBluetoothError('Erro bluetooth desconectado requisição !');
            break;

          case BlueThermalPrinter.STATE_TURNING_OFF:
            printBluetoothError('Erro bluetooth desligando !');
            break;

          case BlueThermalPrinter.STATE_OFF:
            printBluetoothError('Erro bluetooth desligado !');
            break;

          case BlueThermalPrinter.STATE_TURNING_ON:
            printBluetoothError('Erro bluetooth ligando !');
            break;

          case BlueThermalPrinter.ERROR:
            printBluetoothError('Erro bluetooth generico !');
            break;

          default:
            break;
        }
      },
    );

    //     _devices = devices;

    //     log('ConfiguraImpressoraExPage::_devices$_devices');

    //     for (var device in _devices) {
    //       log('ConfiguraImpressoraExPage::${device.name}');
    //       log('ConfiguraImpressoraExPage::${device.address}');

    //       if (device.name.toString() == 'BlueTooth Printer') {
    //         log('ConfiguraImpressoraExPage::Impressora encontrada!');
    //         find = true;
    //         _device = device;
    //         break;
    //       }
    //     }

    //     if (find && scanModo == 'scan') {
    //       log('ConfiguraImpressoraExPage::Scan completo!');

    //       try {
    //         log('ConfiguraImpressoraExPage::Inico teste de impressao...');
    //         bluetooth.connect(_device!);
    //         Uint8List b = await getPrintTest();
    //         //bluetooth.writeBytes(b);
    //         log('ConfiguraImpressoraExPage::Fim teste de impressao!');

    //         gUsuario.printerAddress = _device!.address.toString();
    //         gUsuario.printerName = _device!.name.toString();
    //         gUsuario.update();
    //         scanModo = 'ok';
    //         log('ConfiguraImpressoraExPage::Impressora configurada!');
    //       } on PlatformException {
    //         gUsuario.printerAddress = '';
    //         gUsuario.printerName = '';
    //         gUsuario.update();
    //         scanModo = '';
    //         log('Abortando por teste não realizado!');
    //         if (mounted) {
    //           facileSnackBarError(context, 'Ops!', 'Impressora não respondeu ao teste!');
    //         }
    //       }
    //     } else {
    //       gUsuario.printerAddress = '';
    //       gUsuario.printerName = '';
    //       gUsuario.update();
    //       scanModo = '';
    //       log('Abortando por impressora não econtrada!');
    //       if (mounted) {
    //         facileSnackBarError(context, 'Ops!', 'Impressora não encontrada, tente novamente!');
    //       }
    //     }

    //     if (mounted) {
    //       setState(() {});
    //     }
    //   }
  }

  void printBluetoothTest() {
    log('ConfiguraImpressoraExPage::Desconectado impressora ${gUsuario.printerName} bluetooth !');
    try {
      //bluetooth.disconnect();
    } on PlatformException {
      log('Erro desconectando impressora !');
    } on Exception {
      log('Erro desconectando impressora2 !');
    } finally {
      log('Erro desconectando impressora F !');
    }
  }

  void printBluetoothSuccess(msg) {
    log('ConfiguraImpressoraExPage::$msg');
  }

  bool printBluetoothSave() {
    bool result = false;

    gUsuario.printerAddress = _device!.address.toString();
    gUsuario.printerName = _device!.name.toString();
    gUsuario.update();
    scanModo = 'ok';
    log('ConfiguraImpressoraExPage::Impressora ${gUsuario.printerName} em ${gUsuario.printerAddress} configurada !');

    setState(() {});
    return result;
  }

  bool printBluetoothFindPrinter() {
    bool result = false;

    for (var device in _devices) {
      log('ConfiguraImpressoraExPage::${device.name}');
      log('ConfiguraImpressoraExPage::${device.address}');

      if (device.name.toString() == 'BlueTooth Printer') {
        log('ConfiguraImpressoraExPage::Impressora encontrada !');
        result = true;
        _device = device;
        break;
      }
    }

    return result;
  }

  void printBluetoothError(msg) {
    gUsuario.printerAddress = '';
    gUsuario.printerName = '';
    gUsuario.update();
    scanModo = '';
    log('ConfiguraImpressoraExPage::$msg');
    if (mounted) {
      facileSnackBarError(context, 'Ops!', msg);
      setState(() {});
    }
  }
}
