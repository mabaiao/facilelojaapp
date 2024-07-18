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
  late String versaoApp = '';
  late String nomeVersaoApp = '';

  Future<void> load() async {
    url = await getFileData('imagens/facile.ini');

    versaoApp = url.substring(0, 6) == 'https:' ? '1.1N' : '1.1L';
    nomeVersaoApp = url.substring(0, 6) == 'https:' ? 'Versão cloud' : 'Versão local';

    log('POST::url::$url');
    log('POST::versaoApp::$versaoApp');
  }

  ///
  ///
  ///

  String getVersaoApp() {
    return versaoApp;
  }

  String getNomeVersaoApp() {
    return nomeVersaoApp;
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

class FacileResponse {
  final String status;
  final String titulo;
  final String descricao;
  final Map<String, dynamic> result;

  FacileResponse({required this.status, required this.titulo, required this.descricao, required this.result});

  bool isOk() {
    return (status.isNotEmpty && status == 'ok');
  }

  bool isNotOk() {
    return (status.isNotEmpty && status == 'erro');
  }

  Future<List<dynamic>> getMapList(from) async {
    List<dynamic> rc = [];

    result.forEach((key, value) {
      if (key == from) {
        if (value is List<dynamic>) {
          rc = value;
        }
      }
    });
    return rc;
  }

  Future<List<dynamic>> getMap(from) async {
    List<dynamic> rc = [];
    result.forEach((key, value) {
      if (key == from) {
        if (value is Map) {
          rc = [value];
        }
      }
    });
    return rc;
  }

  Future<String> getResult(param, from) async {
    dynamic rc = '';

    result[from].forEach((key, value) {
      if (key == param) {
        if (value is int) {
          int v = value;
          rc = v.toString();
        } else if (value is String) {
          rc = value;
        } else if (value is List<dynamic>) {
          rc = value;
        }
      }
    });

    return rc;
  }
}

///
/// Acesso
///

Future<dynamic> facileRouter(
  BuildContext context,
  String uri,
  Map<String, String> params, {
  showProc = false,
  addParam = true,
}) async {
  params['viaApp'] = 'S';

  ///
  /// Adiciona os parametros do usuario
  ///

  if (addParam) {
    params['subdominio'] = gUsuario.subdominio.trim();
    params['idFuncionario'] = gUsuario.idFuncionario;
    params['hostTerminalId'] = gUsuario.terminalId.trim();
    params['hostTerminal'] = gUsuario.terminalHost.trim();
    params['host'] = gUsuario.host;
    params['idLojaFisica'] = gUsuario.idLojaFisica;
  }

  ///
  /// Url obtida pela classe FacilePost no arquivo facile.ini
  ///

  var url = Uri.parse("${gUrlPost.url}/$uri");

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
        return http.Response('Error', 408);
      },
    );

    log('POST::RESPONSE::' + response.body);

    if (response.statusCode == 200) {
      ///
      /// Sucesso
      ///
      ///

      /**
       * "status": "erro",
       * "titulo": "Registra",
       * "descricao": "[Terminal] ativado para outro dispositivo !",
       * "httpCode": 200
       * 
       * ou
       * 
       * "status": "ok",
       * "descricao": "[Dispositivo] registrado !",
       * "titulo": "Registra",
       * "result": []
       * "httpCode": 200,
       */

      var aResponse = jsonDecode(response.body);

      log('POST::status::' + aResponse['status']);
      log('POST::titulo::' + aResponse['titulo']);
      log('POST::descricao::' + aResponse['descricao']);

      if (showProc) {
        Navigator.pop(context);
      }

      var result = FacileResponse(
        status: aResponse['status'],
        titulo: aResponse['titulo'],
        descricao: aResponse['descricao'],
        result: aResponse['status'] == 'ok' ? aResponse['result'] : {},
      );

      return result;
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
