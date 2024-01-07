import 'dart:async';
import 'package:facilelojaapp/main.dart';
import 'package:facilelojaapp/util.dart';
import 'package:facilelojaapp/utiltema.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_simple_bluetooth_printer/flutter_simple_bluetooth_printer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';

/// **************************
/// ConfiguraImpressora
///

class ConfiguraImpressoraPage extends StatefulWidget {
  const ConfiguraImpressoraPage({super.key});

  @override
  State<ConfiguraImpressoraPage> createState() => _ConfiguraImpressoraState();
}

class _ConfiguraImpressoraState extends State<ConfiguraImpressoraPage> {
  List<Widget> bg = [];
  String scanModo = '';
  var bluetoothManager = FlutterSimpleBluetoothPrinter.instance;
  var devices = <BluetoothDevice>[];

  @override
  void initState() {
    super.initState();

    /// **************************
    /// Força pedir permissão se precisar
    ///
    debugPrint('PRINTER::Solicitando permissão...');
    bluetoothManager.scan(timeout: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    bluetoothManager.disconnect();
    debugPrint('PRINTER::Fim da conexão dispose.');
    super.dispose();
  }

  void onFocusKey(context, RawKeyEvent event) {
    var s = event.logicalKey.keyLabel.toString().replaceAll('Numpad ', '').replaceAll('Digit ', '').replaceAll('Key ', '').replaceAll('Space', ' ');

    if (event.runtimeType == RawKeyDownEvent) {
      debugPrint('ConfiguraImpressoraPage::onFocusKey::$s');

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

    List<Widget> w1 = [];
    w1.add(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (gUsuario.printerName.isEmpty || scanModo == 'scan' ? const SizedBox() : FacileTheme.displaySmall(context, 'Em ${gUsuario.printerName}')),
          (gUsuario.printerName.isEmpty || scanModo == 'scan' ? const SizedBox() : FacileTheme.displaySmall(context, gUsuario.printerAddress)),
          SizedBox(
            child: Lottie.asset(scanModo.isEmpty ? 'imagens/configuraimpressoraWait.json' : (scanModo == 'scan' ? 'imagens/configuraimpressoraBlue.json' : 'imagens/configuraimpressoraOk.json')),
          ),
          getEspacadorDuplo(),
          (scanModo == 'scan'
              ? FacileTheme.headlineMedium(context, 'BUSCANDO...')
              : (scanModo == 'ok'
                  ? Column(
                      children: [
                        FacileTheme.headlineMedium(context, 'IMPRESSORA CONFIGURADA !'),
                        getEspacadorDuplo(),
                        ElevatedButtonNoIconEx(
                          caption: 'CLIQUE PARA VOLTAR',
                          style: ElevatedButton.styleFrom(),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        ElevatedButtonNoIconEx(
                          caption: 'BUSCAR IMPRESSORAS',
                          style: ElevatedButton.styleFrom(),
                          onPressed: () {
                            scanModo = 'scan';
                            setState(() {});

                            Timer(const Duration(milliseconds: 1000), () {
                              _buscar();
                            });
                          },
                        ),
                      ],
                    )))
        ],
      ),
    );

    List<Widget> w2 = [];
    w2.add(
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getEspacador(),
          ],
        ),
      ),
    );

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
          appBar: getCupertinoAppBar(context, 'CONFIGURAR IMPRESSORA CUPOM', []),
          body: getStackCupertino(
            context,
            bg,
            facileDelayedDisplayBatendo(
              getBody(context, w1, w2, flex1: 5, flex2: 5),
            ),
          ),
        ),
      ),
    );
  }

  void _buscar() async {
    BluetoothDevice? printer;
    bool find = false;

    try {
      debugPrint('PRINTER::iniciando scan...');
      final devices = await bluetoothManager.scan(timeout: const Duration(seconds: 5));
      debugPrint('PRINTER::DEVICES::${devices.toString()}');

      for (var element in devices) {
        BluetoothDevice device = element;

        debugPrint('PRINTER::name::${device.name}');
        debugPrint('PRINTER::address::${device.address}');

        if (!find && device.name == 'BlueTooth Printer') {
          printer = device;
          find = true;
        }
      }
      await bluetoothManager.disconnect();
      debugPrint('PRINTER::Fim da conexão.');
    } on BTException catch (e) {
      // ignore: avoid_print
      print(e);
    }

    if (find) {
      debugPrint('PRINTER::conectando em address::${printer?.address}...');

      try {
        bool isConnected = await bluetoothManager.connect(address: printer!.address, isBLE: !printer.isLE);

        if (isConnected) {
          debugPrint('PRINTER::conectado!');
        } else {
          debugPrint('PRINTER::falha ao conectar!');
        }

        debugPrint('PRINTER::imprimindo...');
        String bytes = "\r\n"
            "\r\n"
            "\r\n"
            "\r\n"
            "\r\n"
            "\r\n"
            "\r\n"
            "TESTE DE IMPRESSAO !!!"
            "\r\n"
            "\r\n"
            "\r\n"
            "\r\n"
            "\r\n"
            "\r\n"
            "\r\n"
            "\r\n"
            "\r\n";

        await bluetoothManager.writeText(_printTeste().toString() + bytes);
        //await bluetoothManager.writeRawData(b);
        await bluetoothManager.disconnect();

        debugPrint('PRINTER::Fim da conexão.');
        scanModo = 'ok';

        gUsuario.printerAddress = printer.address;
        gUsuario.printerName = printer.name;
        gUsuario.update();
      } on BTException catch (e) {
        debugPrint('Fim da conexão por erro.');
        await bluetoothManager.disconnect();
        debugPrint(e.toString());
        scanModo = '';
      }
    } else {
      scanModo = '';
      debugPrint('Abortando conexão por erro.');
      if (mounted) {
        facileSnackBarError(context, 'Ops!', 'Impressora não encontrada, tente novamente!');
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  // ignore: non_constant_identifier_names
  Future<List<int>> _printTeste() async {
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

    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    await for (var page in Printing.raster(await doc.save())) {
      final image = page.asImage();

      debugPrint('PRINTER::IMAGE::$image');
      debugPrint('PRINTER::IMAGEBYTES::${image.buffer.asUint8List()}');

      final Uint8List imgBytes = image.buffer.asUint8List();

      debugPrint('PRINTER::IMGBYTES::$imgBytes');

      bytes += generator.image(image);
      debugPrint('PRINTER::BYTES::$bytes');
    }

    //Future<Uint8List> lay = doc.save();

    return bytes;

    // try {
    //   await Printing.layoutPdf(
    //     onLayout: (PdfPageFormat format) async => doc.save(),
    //     format: impressaoTamanhoPapel == '58' ? PdfPageFormat.roll57 : PdfPageFormat.roll80,
    //     name: 'FACILE',
    //   ).then((value) => () {
    //         Navigator.pop(context);
    //       });
    // } catch (e) {
    //   //facilePrintErro(context);
    // }
  }
}
