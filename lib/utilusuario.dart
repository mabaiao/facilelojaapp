import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// **************************
/// Controle usuario logado
///

class FacileUser {
  late String subdominio = '';
  late String idLojaFisica = '';
  late String idEmpresa = '';
  late String nomeLojaFisica = '';
  late String terminalId = '';
  late String terminalHost = '';
  late String terminalNome = '';
  late String host = '';
  late String pin = '';
  late String idFuncionario = '';
  late String primeiroNome = '';
  late String nome = '';
  late String imagem = '';
  late String idCargo = '';
  late String siglaCargo = '';
  late String nomeCargo = '';
  late String printerAddress = '';
  late String printerName = '';

  Future<void> load({VoidCallback? onLoad}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    subdominio = prefs.getString('subdominio') ?? '';
    pin = prefs.getString('pin') ?? '';
    idLojaFisica = prefs.getString('idLojaFisica') ?? '';
    idEmpresa = prefs.getString('idEmpresa') ?? '';
    nomeLojaFisica = prefs.getString('nomeLojaFisica') ?? '';
    terminalId = prefs.getString('terminalId') ?? '';
    terminalId = prefs.getString('terminalId') ?? '';
    terminalHost = prefs.getString('terminalHost') ?? '';
    terminalNome = prefs.getString('terminalNome') ?? '';
    host = prefs.getString('host') ?? '';
    idFuncionario = prefs.getString('idFuncionario') ?? '';
    primeiroNome = prefs.getString('primeiroNome') ?? '';
    nome = prefs.getString('nome') ?? '';
    imagem = prefs.getString('imagem') ?? '';
    idCargo = prefs.getString('idCargo') ?? '';
    siglaCargo = prefs.getString('siglaCargo') ?? '';
    nomeCargo = prefs.getString('nomeCargo') ?? '';
    printerAddress = prefs.getString('printerAddress') ?? '';
    printerName = prefs.getString('printerName') ?? '';

    print();

    if (onLoad != null) {
      onLoad();
    }
  }

  void clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    load();
    update();
  }

  void update() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('subdominio', subdominio);
    prefs.setString('pin', pin);
    prefs.setString('idLojaFisica', idLojaFisica);
    prefs.setString('idEmpresa', idEmpresa);
    prefs.setString('nomeLojaFisica', nomeLojaFisica);
    prefs.setString('terminalId', terminalId);
    prefs.setString('terminalHost', terminalHost);
    prefs.setString('terminalNome', terminalNome);
    prefs.setString('host', host);
    prefs.setString('idFuncionario', idFuncionario);
    prefs.setString('primeiroNome', primeiroNome);
    prefs.setString('nome', nome);
    prefs.setString('imagem', imagem);
    prefs.setString('idCargo', idCargo);
    prefs.setString('siglaCargo', siglaCargo);
    prefs.setString('nomeCargo', nomeCargo);
    prefs.setString('printerAddress', printerAddress);
    prefs.setString('printerName', printerName);

    print();
  }

  void print() {
    log('USER::subdominio::$subdominio');
    log('USER::pin::$pin');
    log('USER::idLojaFisica::$idLojaFisica');
    log('USER::idEmpresa::$idEmpresa');
    log('USER::nomeLojaFisica::$nomeLojaFisica');
    log('USER::terminalId::$terminalId');
    log('USER::terminalHost::$terminalHost');
    log('USER::terminalNome::$terminalNome');
    log('USER::host::$host');
    log('USER::idFuncionario::$idFuncionario');
    log('USER::primeiroNome::$primeiroNome');
    log('USER::nome::$nome');
    log('USER::imagem::$imagem');
    log('USER::idCargo::$idCargo');
    log('USER::siglaCargo::$siglaCargo');
    log('USER::nomeCargo::$nomeCargo');
    log('USER::printerAddress::$printerAddress');
    log('USER::printerName::$printerName');
  }
}
