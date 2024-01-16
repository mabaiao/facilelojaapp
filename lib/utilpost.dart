// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:facilelojaapp/main.dart';
import 'package:facilelojaapp/util.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:http/http.dart' as http;

class FacilePost {
  late String url = '';

  Future<void> load() async {
    url = await getFileData('imagens/facile.ini');
    log('POST::url::$url');
  }
}

///
/// Acesso
///

Future<dynamic> facilePostEx(
  BuildContext context,
  String prg,
  Map<String, String> params, {
  showProc = false,
  addParam = true,
}) async {
  params['viaApp'] = 'S';

  ///
  /// Adiciona os parametros do usuario
  ///

  if (addParam) {
    params['Subdominio'] = gUsuario.subdominio.trim();
    params['idFuncionario'] = gUsuario.idFuncionario;
    params['hostTerminalId'] = gUsuario.terminalId.trim();
    params['hostTerminal'] = gUsuario.terminalHost.trim();
    params['host'] = gUsuario.host;
    params['idLojaFisica'] = gUsuario.idLojaFisica;
  }

  ///
  /// Url obtida pela classe FacilePost no arquivo facile.ini
  ///

  var url = Uri.parse("${gUrlPost.url}/$prg");

  log('POST::prg::$url');
  log('POST::params::$params');

  var msg = '';

  if (showProc) {
    showLoading(context);
  }

  try {
    var response = await http
        .post(url,
            headers: <String, String>{
              'Accept': 'application/json; charset=UTF-8',
            },
            body: params)
        .timeout(
      const Duration(seconds: 25),
      onTimeout: () {
        log('POST::Erro de timeout connection 408');
        return http.Response('Error', 408); // Request Timeout response status code
      },
    );

    if (response.statusCode == 200) {
      ///
      /// Sucesso
      ///
      var aResponse = jsonDecode(response.body);

      log('POST::Status::' + aResponse['Status']);
      log('POST::Msg::' + aResponse['Msg']);
      log('POST::MsgError::' + aResponse['MsgError']);

      if (showProc) {
        Navigator.pop(context);
      }

      return aResponse;
    } else {
      ///
      /// Falha
      ///

      msg = 'Conexão de internet indisponível (!200), tente novamente !';
    }
  } on SocketException {
    msg = 'Sem conexão de internet (SocketException) !';
  } on HttpException {
    msg = 'Conexão de internet muito lenta (HttpException) !';
  } on FormatException {
    msg = 'Erro na conexão de internet (FormatException) !';
  }

  ///
  /// Aviso de falha
  ///

  if (showProc) {
    Navigator.pop(context);
  }

  log('POST::$msg');

  showAlertError(context, 'INTERNET', msg);

  return null;
}
