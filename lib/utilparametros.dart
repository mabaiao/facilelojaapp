import 'dart:developer';

import 'package:facilelojaapp/utilpost.dart';

class FacileParams {
  late String vendaPermitirDesconto = '';
  late String vendaPercentualMaximoDesconto = '';
  late String vendaPedirPermissaoDesconto = '';
  late String vendaPedirPermissaoRemoverItem = '';
  late String vendaPedirPermissaoLimparCupom = '';
  late String vendaPedirPermissaoCancelamento = '';
  late String vendaPedirPermissaoLeituraConferencia = '';
  late String vendaSolicitarAtendimento = '';
  late String vendaLimiteProdutoConsulta = '';
  late String pedidoPermitirGerarSemEstoque = '';
  late String compartilhamentoTextoPadrao = '';
  late String aparenciaPadraoExibicaoNomeProduto = '';
  late String aparenciaPadraoExibicaoNomeProdutoFonte = '';
  late String aparenciaPadraoExibicaoNomeProdutoFonteNegrito = '';
  late String aparenciaPreencherFundoImagem = '';
  late String aparenciaPreencherFundoImagemDiversificar = '';
  late String aparenciaPadraoFotosPermitirQualquerTamanho = '';
  late String aparenciaPadraoFotosLargura = '';
  late String aparenciaPadraoFotosAltura = '';

  Future<void> load(context) async {
    log('FacileParams::load()');

    Map<String, String> params = {
      'Funcao': 'LeOpcoes',
    };

    var aResult = await facilePostEx(context, 'facileFlutterApp.php', params, showProc: true);

    if (aResult == null) {
    } else if (aResult != null && aResult['Status'] == 'OK') {
      log(aResult.toString());

      vendaPermitirDesconto = aResult['opcoesGlobais']['_vendaPermitirDesconto'];
      vendaPercentualMaximoDesconto = aResult['opcoesGlobais']['_vendaPercentualMaximoDesconto'];
      vendaPedirPermissaoDesconto = aResult['opcoesGlobais']['_vendaPedirPermissaoDesconto'];
      vendaPedirPermissaoRemoverItem = aResult['opcoesGlobais']['_vendaPedirPermissaoRemoverItem'];
      vendaPedirPermissaoLimparCupom = aResult['opcoesGlobais']['_vendaPedirPermissaoLimparCupom'];
      vendaPedirPermissaoCancelamento = aResult['opcoesGlobais']['_vendaPedirPermissaoCancelamento'];
      vendaPedirPermissaoLeituraConferencia = aResult['opcoesGlobais']['_vendaPedirPermissaoLeituraConferencia'];
      vendaSolicitarAtendimento = aResult['opcoesGlobais']['_vendaSolicitarAtendimento'];
      vendaLimiteProdutoConsulta = aResult['opcoesGlobais']['_vendaLimiteProdutoConsulta'];
      pedidoPermitirGerarSemEstoque = aResult['opcoesGlobais']['_pedidoPermitirGerarSemEstoque'];
      compartilhamentoTextoPadrao = aResult['opcoesGlobais']['_compartilhamentoTextoPadrao'];
      aparenciaPadraoExibicaoNomeProduto = aResult['opcoesGlobais']['_aparenciaPadraoExibicaoNomeProduto'];
      aparenciaPadraoExibicaoNomeProdutoFonte = aResult['opcoesGlobais']['_aparenciaPadraoExibicaoNomeProdutoFonte'];
      aparenciaPadraoExibicaoNomeProdutoFonteNegrito = aResult['opcoesGlobais']['_aparenciaPadraoExibicaoNomeProdutoFonteNegrito'];
      aparenciaPreencherFundoImagem = aResult['opcoesGlobais']['_aparenciaPreencherFundoImagem'];
      aparenciaPreencherFundoImagemDiversificar = aResult['opcoesGlobais']['_aparenciaPreencherFundoImagemDiversificar'];
      aparenciaPadraoFotosPermitirQualquerTamanho = aResult['opcoesGlobais']['_aparenciaPadraoFotosPermitirQualquerTamanho'];
      aparenciaPadraoFotosLargura = aResult['opcoesGlobais']['_aparenciaPadraoFotosLargura'];
      aparenciaPadraoFotosAltura = aResult['opcoesGlobais']['_aparenciaPadraoFotosAltura'];
      print();
    } else {}
  }

  void print() {
    log('PARAMETROS::vendaPermitirDesconto::$vendaPermitirDesconto');
    log('PARAMETROS::vendaPercentualMaximoDesconto::$vendaPercentualMaximoDesconto');
    log('PARAMETROS::vendaPedirPermissaoDesconto::$vendaPedirPermissaoDesconto');
    log('PARAMETROS::vendaPedirPermissaoRemoverItem::$vendaPedirPermissaoRemoverItem');
    log('PARAMETROS::vendaPedirPermissaoLimparCupom::$vendaPedirPermissaoLimparCupom');
    log('PARAMETROS::vendaPedirPermissaoCancelamento::$vendaPedirPermissaoCancelamento');
    log('PARAMETROS::vendaPedirPermissaoLeituraConferencia::$vendaPedirPermissaoLeituraConferencia');
    log('PARAMETROS::vendaSolicitarAtendimento::$vendaSolicitarAtendimento');
    log('PARAMETROS::vendaLimiteProdutoConsulta::$vendaLimiteProdutoConsulta');
    log('PARAMETROS::pedidoPermitirGerarSemEstoque::$pedidoPermitirGerarSemEstoque');
    log('PARAMETROS::compartilhamentoTextoPadrao::$compartilhamentoTextoPadrao');
    log('PARAMETROS::aparenciaPadraoExibicaoNomeProduto::$aparenciaPadraoExibicaoNomeProduto');
    log('PARAMETROS::aparenciaPadraoExibicaoNomeProdutoFonte::$aparenciaPadraoExibicaoNomeProdutoFonte');
    log('PARAMETROS::aparenciaPadraoExibicaoNomeProdutoFonteNegrito::$aparenciaPadraoExibicaoNomeProdutoFonteNegrito');
    log('PARAMETROS::aparenciaPreencherFundoImagem::$aparenciaPreencherFundoImagem');
    log('PARAMETROS::aparenciaPreencherFundoImagemDiversificar::$aparenciaPreencherFundoImagemDiversificar');
    log('PARAMETROS::aparenciaPadraoFotosPermitirQualquerTamanho::$aparenciaPadraoFotosPermitirQualquerTamanho');
    log('PARAMETROS::aparenciaPadraoFotosLargura::$aparenciaPadraoFotosLargura');
    log('PARAMETROS::aparenciaPadraoFotosAltura::$aparenciaPadraoFotosAltura');
  }
}
