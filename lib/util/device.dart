import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:beep_player/beep_player.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;

import '../dados/filaimpresao.dart';
import '../utilpost.dart';

/// **************************
/// Controle usuario logado
///

class FacileDevice {
  static const BeepFile _beepFile = BeepFile('sounds/Ok.wav');
  static const BeepFile _beepFileErr = BeepFile('sounds/Err.wav');

  bool printServiceRunning = false;
  bool isWindows = false;
  bool isAndroid = false;
  bool isWeb = false;
  String host = '';
  bool isPhoneSmall = false;
  bool isPhone = false;
  bool isPhoneAll = false;
  bool isTabletPortrait = false;
  bool isTabletLandscape = false;
  bool isTabletAll = false;

  double sizeWidth = 0;
  double sizeHeight = 0;

  String release = '';

  FacileDevice();

  Future<void> load(context) async {
    isWindows = false;
    isAndroid = false;
    isWeb = false;
    host = '';
    release = '';

    if (!Platform.isWindows) {
      BeepPlayer.load(_beepFile);
      BeepPlayer.load(_beepFileErr);
    }

    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

      if (kIsWeb) {
        WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
        host = webBrowserInfo.browserName.toString();
        isWeb = true;
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        host = androidInfo.host.toString();
        release = androidInfo.version.release;
        isAndroid = true;
      } else if (Platform.isWindows) {
        WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
        host = windowsInfo.computerName.toString();
        isWindows = true;
      }
    } catch (e) {
      host = 'unico';
    }

    update(context);
  }

  Future<void> update(context) async {
    final MediaQueryData data = MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.single);
    Size x = Size(data.size.width, data.size.height);

    isPhoneSmall = false;
    isPhone = false;
    isPhoneAll = false;
    isTabletPortrait = false;
    isTabletLandscape = false;
    isTabletAll = false;
    sizeWidth = 0;
    sizeHeight = 0;

    sizeWidth = x.width;
    sizeHeight = x.height;

    if (data.size.width <= 360 && data.size.height <= 620) {
      // maquininha
      isPhoneSmall = true;
      isPhoneAll = true;
    } else if (data.size.width <= 540) {
      isPhone = true;
      isPhoneAll = true;
    } else {
      if (data.size.width < data.size.height) // em pe
      {
        isTabletPortrait = true;
        isTabletAll = true;
      } else {
        isTabletLandscape = true;
        isTabletAll = true;
      }
    }

    print();
  }

  void print() {
    log('DEVICE::isWindows::$isWindows');
    log('DEVICE::isAndroid::$isAndroid');
    log('DEVICE::release::$release');
    log('DEVICE::isWeb::$isWeb');
    log('DEVICE::host::$host');
    log('DEVICE::isPhoneSmall::$isPhoneSmall');
    log('DEVICE::isPhone::$isPhone');
    log('DEVICE::isPhoneAll::$isPhoneAll');
    log('DEVICE::isTabletPortrait::$isTabletPortrait');
    log('DEVICE::isTabletLandscape::$isTabletLandscape');
    log('DEVICE::isTabletAll::$isTabletAll');
    log('DEVICE::sizeWidth::$sizeWidth');
    log('DEVICE::sizeHeight::$sizeHeight');
  }

  void beep() {
    if (!Platform.isWindows) {
      BeepPlayer.play(_beepFile);
    }
  }

  void beepErr() {
    if (!Platform.isWindows) {
      BeepPlayer.play(_beepFileErr);
    }
  }

  void startPrintService(context) {
    log('DEVICE::PrintService::Iniciado !');
    printServiceRunning = true;
    evalPrintService(context);
  }

  void stopPrintService(context) {
    printServiceRunning = false;
    log('DEVICE::PrintService::Parado !');
  }

  Future<void> evalPrintService(context) async {
    log('DEVICE::PrintService::Processando...');

    Map<String, String> params = {
      'Funcao': 'LeFilaImpressao',
    };

    var aResult = await facilePostEx(context, 'facileFlutterApp.php', params, showProc: false);

    if (aResult == null) {
    } else if (aResult != null && aResult['Status'] == 'OK') {
      Iterable v = await aResult['FilaImpressao'];
      List<FilaImpressao> filaList = v.map((model) => FilaImpressao.fromMap(model)).toList();

      log('DEVICE::PrintService::Pendentes::${filaList.length}');

      List<String> ids = [];

      for (FilaImpressao item in filaList) {
        String filename = 'print/print_${item.id}.pdf';
        Uint8List bytes = base64Decode(item.file);
        await File(filename).writeAsBytes(bytes);

        ids.add(item.id);
      }

      if (ids.isNotEmpty) {
        freePrintService(context, ids);
      }

      if (printServiceRunning) {
        Timer(const Duration(milliseconds: 3000), () {
          if (context.mounted) {
            evalPrintService(context);
          }
        });
      }
    } else {}
  }

  Future<void> freePrintService(context, ids) async {
    log('DEVICE::PrintService::Processando...');

    Map<String, String> params = {
      'Funcao': 'ConfirmaFilaImpressaoPorIds',
      'IDs': json.encode(ids),
    };

    var aResult = await facilePostEx(context, 'facileFlutterApp.php', params, showProc: false);

    if (aResult == null) {
    } else if (aResult != null && aResult['Status'] == 'OK') {
    } else {}
  }
}
