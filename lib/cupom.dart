import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

import 'dados/empresa.dart';
import 'dados/venda.dart';
import 'main.dart';

/// **************************
/// Cupom
///

enum CupomTipoMovimento {
  nenhum,
  venda,
  pedido,
  suprimento,
  sangria,
}

enum CupomStatus {
  nenhum,
  emAberto,
  concluido,
  cancelado,
}

class Cupom {
  String idVenda = '0';
  String idLojaFisica;
  String idEmpresa;
  String idFuncionario;
  String tipoMovimento;
  String status = CupomStatus.emAberto.toString();
  String atacado = 'N';

  String idPai = '0';
  String idFuncionarioComissionado = '0';
  String primeiroNomeComissionado = '';
  double qtdProdutos = 0;
  String cpfCnpj = '';
  String celular = '';
  String email = '';
  String idCliente = '0';
  String nomeCliente = '';
  String enderecoCliente = '';

  String host = '';

  double acrescimo = 0;
  String acrescimoF = '-';

  double desconto = 0;
  String descontoF = '-';

  double devolucao = 0;
  String devolucaoF = '-';

  double subTotal = 0;
  String subTotalF = '-';

  double total = 0;
  String totalF = '-';

  double pagoDinheiro = 0;
  double pagoOutros = 0;

  double pago = 0;
  String pagoF = '-';

  double troco = 0;
  String trocoF = '-';

  double aPagar = 0;
  String aPagarF = '-';

  String idSugestaoMeioPagamento = '0';
  String nomeSugestaoMeioPagamento = '';

  late List<CupomItem> itens = [];
  late List<CupomPagto> pagtos = [];

  Cupom({
    required this.idLojaFisica,
    required this.idEmpresa,
    required this.idFuncionario,
    required this.tipoMovimento,
    required this.host,
  }) {
    _limpa();
  }

  void limpa() {
    _limpa();
    recalcula();
  }

  void limpaCliente() {
    cpfCnpj = '';
    cpfCnpj = '';
    nomeCliente = '';
    cpfCnpj = '';
    celular = '';
    email = '';
    idCliente = '0';
  }

  void _limpa() {
    idVenda = '0';
    idPai = '0';
    idFuncionarioComissionado = '0';
    primeiroNomeComissionado = '';

    status = CupomStatus.emAberto.toString();
    atacado = 'N';

    qtdProdutos = 0;
    cpfCnpj = '';
    celular = '';
    email = '';
    idCliente = '0';
    nomeCliente = '';
    enderecoCliente = '';

    total = 0;
    totalF = '-';

    aPagar = 0;
    aPagarF = '-';

    pago = 0;
    pagoF = '-';

    pagoDinheiro = 0;
    pagoOutros = 0;

    troco = 0;
    trocoF = '-';

    subTotal = 0;
    subTotalF = '-';

    desconto = 0;
    descontoF = '-';

    acrescimo = 0;
    acrescimoF = '-';

    devolucao = 0;
    devolucaoF = '-';

    idSugestaoMeioPagamento = '0';
    nomeSugestaoMeioPagamento = '';

    itens.clear();
    pagtos.clear();
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    var hash = md5.convert(utf8.encode('${DateTime.now().millisecondsSinceEpoch}-${UniqueKey()}')).toString();

    return <String, dynamic>{
      'hash': hash,
      'idLojaFisica': idLojaFisica,
      'idEmpresa': idEmpresa,
      'idFuncionario': idFuncionario,
      'tipoMovimento': tipoMovimento,
      'idPai': idPai,
      'status': status,
      'qtdProdutos': qtdProdutos,
      'cpfCnpj': cpfCnpj,
      'celular': celular,
      'email': email,
      'idCliente': idCliente,
      'acrescimo': acrescimo,
      'desconto': desconto,
      'devolucao': devolucao,
      'subTotal': subTotal,
      'total': total,
      'pagoDinheiro': pagoDinheiro,
      'pagoOutros': pagoOutros,
      'pago': pago,
      'troco': troco,
      'aPagar': aPagar,
      'idFuncionarioComissionado': idFuncionarioComissionado,
      'host': host,
    };
  }

  void descontoPercentual(val) {
    final d = double.parse(val);

    if (d <= 100.00) {
      for (var i = 0; i < itens.length; i++) {
        itens[i].vDesc = (itens[i].vSubTotal * d) / 100;
        itens[i].vDesc = double.parse(itens[i].vDesc.toStringAsFixed(2));
      }

      recalcula();
    }
  }

  void descontoPercentualItem(val, index) {
    final d = double.parse(val);

    if (d <= 100.00) {
      itens[index].vDesc = (itens[index].vSubTotal * d) / 100;
      itens[index].vDesc = double.parse(itens[index].vDesc.toStringAsFixed(2));
      recalcula();
      itens[index].daVez = true;
    }
  }

  bool descontoFixoItem(val, index) {
    final d = double.parse(val);

    if (d <= itens[index].vSubTotal) {
      itens[index].vDesc = d;
      recalcula();
      itens[index].daVez = true;
    } else {
      return false;
    }

    return true;
  }

  bool descontoFixo(val) {
    final d = double.parse(val);

    if (d > subTotal) {
      return false;
    }

    for (var i = 0; i < itens.length; i++) {
      itens[i].vDesc = 0.00;
    }

    recalcula();

    double valorRestante = d;

    for (var i = 0; i < itens.length; i++) {
      if (valorRestante > itens[i].vTotal) {
        itens[i].vDesc = itens[i].vTotal - 0.01;
      } else if (valorRestante < itens[i].vTotal) {
        itens[i].vDesc = valorRestante;
      } else {
        itens[i].vDesc = valorRestante;
      }

      valorRestante = valorRestante - itens[i].vDesc;
    }

    recalcula();

    return true;
  }

  void limpaPagamentos() {
    pagtos.clear();
    recalcula();
  }

  bool remove(index) {
    itens.remove(itens[index]);
    recalcula();
    return itens.isEmpty;
  }

  void incrementa(index) {
    itens[index].qCom++;
    recalcula();
    itens[index].daVez = true;
  }

  void decrementa(index) {
    if (itens[index].qCom > 1) {
      itens[index].qCom--;
      recalcula();
      itens[index].daVez = true;
    }
  }

  void adicionaItem(item) {
    int index = itens.indexWhere((element) => element.digitado == item.digitado && element.unidadeSigla == item.unidadeSigla);

    if (index < 0) {
      itens.add(item);
      index = itens.length - 1;
    } else {
      itens[index].qCom = itens[index].qCom + item.qCom;
    }

    recalcula();
    itens[index].daVez = true;
  }

  String adicionaPagto(context, CupomPagto item) {
    String result = '';
    final index = pagtos.indexWhere((element) => element.idMeioPagamento == item.idMeioPagamento);

    NumberFormat format = NumberFormat('###,##0.00', 'pt_BR');
    double t = double.parse(item.valor.toStringAsFixed(2));

    if (index == -1 && t == 0.00) {
      result = 'PAGAMENTO ZERADO !';
      return result;
    }

    if (item.codigoSefaz != '01') {
      if (t > aPagar) {
        result = 'PAGAMENTO NÃO PODE SER MAIOR QUE O VALOR A PAGAR !';
        return result;
      }
    }

    item.valorF = format.format(t);

    if (index != -1 && t == 0.00) {
      pagtos.remove(pagtos[index]);
    } else if (index == -1) {
      pagtos.add(item);
    } else {
      pagtos[index].valor = t;
      pagtos[index].valorF = item.valorF;
    }

    recalcula();

    return result;
  }

  bool temPagto(id) {
    final index = pagtos.indexWhere((element) => element.idMeioPagamento == id);

    return index == -1 ? false : true;
  }

  bool temDigitado(String ean, double qtdAdicionaSeTiver) {
    final index = itens.indexWhere((element) => element.digitado == ean);

    if (index != -1) {
      itens[index].qCom += qtdAdicionaSeTiver;
      recalcula();
      itens[index].daVez = true;
    }

    return index == -1 ? false : true;
  }

  int indexDigitado(String ean) {
    final index = itens.indexWhere((element) => element.digitado == ean);

    return index;
  }

  CupomPagto? buscaPagto(id) {
    final index = pagtos.indexWhere((element) => element.idMeioPagamento == id);

    return index == -1 ? null : pagtos[index];
  }

  void recalcula() {
    NumberFormat format = NumberFormat('###,##0.00', 'pt_BR');

    qtdProdutos = 0;

    subTotal = 0.00;
    acrescimo = 0.00;
    desconto = 0.00;
    devolucao = 0.00;
    total = 0.00;

    ///
    /// Itens
    ///

    for (var i = 0; i < itens.length; i++) {
      itens[i].daVez = false;

      double tSubTotal = (itens[i].qCom * itens[i].vUnCom);
      double tTotal = (itens[i].qCom * itens[i].vUnCom) + itens[i].vAcre - itens[i].vDesc;

      itens[i].vSubTotal = double.parse(tSubTotal.toStringAsFixed(2));
      itens[i].vTotal = double.parse(tTotal.toStringAsFixed(2));

      itens[i].linhaTotal = '${itens[i].qCom.round()} X ${format.format(itens[i].vUnCom)} = ${format.format(itens[i].vSubTotal)}';
      itens[i].linhaTotalImp = '${itens[i].qCom.round()} X ${format.format(itens[i].vUnCom)} = ${format.format(itens[i].vSubTotal)}';

      itens[i].linhaTotalDescImp = '';

      if (itens[i].vDesc > 0.00) {
        itens[i].linhaTotal += ' - ${format.format(itens[i].vDesc)} = ${format.format(itens[i].vTotal)}';
        itens[i].linhaTotalDescImp = '${format.format(itens[i].vDesc)} = ${format.format(itens[i].vTotal)}';
        itens[i].temDesconto = true;
      } else {
        itens[i].temDesconto = false;
      }

      qtdProdutos += itens[i].qCom;

      subTotal += itens[i].vSubTotal;
      acrescimo += itens[i].vAcre;
      desconto += itens[i].vDesc;
      total += itens[i].vTotal;

      ///
      /// Pagamentos
      ///
      aPagar = 0.00;
      pago = 0.00;
      troco = 0.00;
      pagoDinheiro = 0;
      pagoOutros = 0;

      for (var i = 0; i < pagtos.length; i++) {
        pago += pagtos[i].valor;

        if (pagtos[i].codigoSefaz == '01') {
          pagoDinheiro += pagtos[i].valor;
        } else {
          pagoOutros += pagtos[i].valor;
        }
      }

      pago = double.parse(pago.toStringAsFixed(2));

      troco = pago - total;
      if (troco < 0.00) {
        troco = 0.00;
      }

      aPagar = total - pago;
      if (aPagar < 0.00) {
        aPagar = 0.00;
      }

      aPagar = double.parse(aPagar.toStringAsFixed(2));

      trocoF = troco == 0.00 ? '-' : format.format(troco);
      pagoF = pago == 0.00 ? '-' : format.format(pago);
      aPagarF = aPagar == 0.00 ? '-' : format.format(aPagar);
    }

    subTotal = double.parse(subTotal.toStringAsFixed(2));
    acrescimo = double.parse(acrescimo.toStringAsFixed(2));
    desconto = double.parse(desconto.toStringAsFixed(2));
    total = double.parse(total.toStringAsFixed(2));

    subTotalF = subTotal == 0.00 ? '-' : format.format(subTotal);
    acrescimoF = acrescimo == 0.00 ? '-' : format.format(acrescimo);
    descontoF = desconto == 0.00 ? '-' : format.format(desconto);
    totalF = total == 0.00 ? '-' : format.format(total);
  }

  void impressaoCupom(context, Empresa empresa, Venda venda, opcoesImpressao, String modo) async {
    var subdominio = gUsuario.subdominio;
    var cupom = this;

    final doc = pw.Document();
    final fontDetalhe = await PdfGoogleFonts.ubuntuMonoRegular();
    final fontTitulo = await PdfGoogleFonts.staatlichesRegular();
    final fontCancelado = await PdfGoogleFonts.rubikMonoOneRegular();
    final consumidor = cupom.cpfCnpj.isEmpty ? 'CONSUMIDOR NÃO IDENTIFICADO' : 'CONSUMIDOR FINAL ${cupom.cpfCnpj}';
    //final netImage = await networkImage(empresa.logo);
    const temFiscal = 'N';

    final impressaoTamanhoFonteTexto = double.parse(opcoesImpressao['_impressaoTamanhoFonteTexto']);
    final impressaoTamanhoFonteProduto = double.parse(opcoesImpressao['_impressaoTamanhoFonteProduto']);
    final impressaoTamanhoFonteProdutoValores = double.parse(opcoesImpressao['_impressaoTamanhoFonteProdutoValores']);
    final impressaoTamanhoFonteTitulo = double.parse(opcoesImpressao['_impressaoTamanhoFonteTitulo']);
    final impressaoTamanhoFonteSubTitulo = double.parse(opcoesImpressao['_impressaoTamanhoFonteSubTitulo']);
    final impressaoTamanhoFonteTotais = double.parse(opcoesImpressao['_impressaoTamanhoFonteTotais']);
    final impressaoTamanhoPapel = opcoesImpressao['_impressaoTamanhoPapel'];
    final impressaoEspacamento = double.parse(opcoesImpressao['_impressaoEspacamento']);
    final impressaoTextoAdicionalContato = opcoesImpressao['_impressaoTextoAdicionalContato'];
    final impressaoTextoAdicionalRodape = opcoesImpressao['_impressaoTextoAdicionalRodape'];
    //final impressaoImprimeTributos = opcoesImpressao['_impressaoImprimeTributos'];
    final impressaoTelefonePadrao = opcoesImpressao['_impressaoTelefonePadrao'];
    final String impressaoTelefoneCelular = opcoesImpressao['_impressaoTelefoneCelular'].toString();
    final String impressaoTelefoneFixo = opcoesImpressao['_impressaoTelefoneFixo'].toString();

//    showLoading(context);

    ///
    /// Parte fiscal
    ///

    pw.Widget wFiscal = pw.SizedBox();

    if (temFiscal == 'S') {
      // var aVenda = aResult['VendaFiscal'];
      // String ch1 = aVenda['chaveAcesso'];
      // String ch2 = aVenda['chaveAcesso'];
      // final qrCode = Barcode.qrCode(errorCorrectLevel: BarcodeQRCorrectionLevel.low).toSvg(aVenda['qrCode'], width: 100, height: 100);

      // ch1 = ch1.substring(0, 29);
      // ch2 = ch2.substring(30, 54);

      // wFiscal = pw.Column(
      //   mainAxisAlignment: pw.MainAxisAlignment.center,
      //   children: [
      //     pw.Text('Via consumidor', style: pw.TextStyle(font: fontDetalhe, fontSize: impressaoTamanhoFonteSubTitulo, fontWeight: pw.FontWeight.bold)),
      //     pw.Text('Consulte em www.nfe.fazenda.gov.br/portal', style: pw.TextStyle(font: fontDetalhe, fontSize: impressaoTamanhoFonteTexto - 4, fontWeight: pw.FontWeight.bold)),
      //     pw.Text('Chave de acesso', style: pw.TextStyle(font: fontDetalhe, fontSize: impressaoTamanhoFonteSubTitulo, fontWeight: pw.FontWeight.bold)),
      //     pw.Text(ch1, style: pw.TextStyle(font: fontDetalhe, fontSize: impressaoTamanhoFonteTexto, fontWeight: pw.FontWeight.bold)),
      //     pw.Text(ch2, style: pw.TextStyle(font: fontDetalhe, fontSize: impressaoTamanhoFonteTexto, fontWeight: pw.FontWeight.bold)),
      //     pw.Text('Protocolo de autorização', style: pw.TextStyle(font: fontDetalhe, fontSize: impressaoTamanhoFonteSubTitulo, fontWeight: pw.FontWeight.bold)),
      //     pw.Text(aVenda['protocolo'] + ' Série ' + aVenda['serie'] + ' Número ' + aVenda['numero'], style: pw.TextStyle(font: fontDetalhe, fontSize: impressaoTamanhoFonteTexto, fontWeight: pw.FontWeight.bold)),
      //     pw.Padding(
      //       padding: const pw.EdgeInsets.only(left: 20, right: 20),
      //       child: pw.SvgImage(svg: qrCode),
      //     ),
      //     impressaoImprimeTributos == 'S' ? pw.Divider(height: impressaoEspacamento) : pw.SizedBox(),
      //     impressaoImprimeTributos == 'S' ? pw.Text(aVenda['infCpl'], style: pw.TextStyle(font: fontDetalhe, fontSize: impressaoTamanhoFonteTexto)) : pw.SizedBox(),
      //     pw.Divider(height: impressaoEspacamento),
      //   ],
      // );
    }

    ///
    /// Telefone de contato
    ///

    pw.Widget wContato = pw.SizedBox();
    String sContato;

    sContato = '';

    if ((impressaoTelefonePadrao == 'Celular' || impressaoTelefonePadrao == 'Ambos') && impressaoTelefoneCelular.isNotEmpty) {
      sContato = impressaoTelefoneCelular;
    }

    if ((impressaoTelefonePadrao == 'Fixo' || impressaoTelefonePadrao == 'Ambos') && impressaoTelefoneFixo.isNotEmpty) {
      sContato += (' $impressaoTelefoneCelular');
    }

    if (sContato.isNotEmpty) {
      wContato = pw.Text(sContato, style: pw.TextStyle(font: fontTitulo, fontSize: impressaoTamanhoFonteTitulo, fontWeight: pw.FontWeight.normal));
    }

    ///
    /// Cancelado
    ///

    pw.Widget wCancelado = pw.SizedBox();

    if (cupom.status == '2') {
      wCancelado = pw.Column(
        children: [
          pw.Text(
            'CANCELADO',
            style: pw.TextStyle(
              font: fontCancelado,
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              //color: const PdfColor(1.0, 0, 0),
            ),
          ),
          pw.Text(
            'EM ${venda.dataAlteracaoF}',
            style: pw.TextStyle(
              font: fontCancelado,
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              //color: const PdfColor(1.0, 0, 0),
            ),
          ),
        ],
      );
    }

    ///
    /// Texto adicional do contato
    ///

    pw.Widget wTextoAdicionalContato = pw.SizedBox();

    if (impressaoTextoAdicionalContato != '') {
      wTextoAdicionalContato = pw.Text(impressaoTextoAdicionalContato, style: pw.TextStyle(font: fontTitulo, fontSize: impressaoTamanhoFonteTitulo, fontWeight: pw.FontWeight.normal));
    }

    ///
    /// Rodape
    ///

    pw.Widget wRodape = pw.SizedBox();

    if (impressaoTextoAdicionalRodape != '') {
      wRodape = pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Text(impressaoTextoAdicionalRodape, style: pw.TextStyle(font: fontTitulo, fontSize: impressaoTamanhoFonteSubTitulo, fontWeight: pw.FontWeight.normal)),
        ],
      );
    }

    ///
    /// Cliente
    ///

    pw.Widget wCliente = pw.SizedBox();

    if (cupom.nomeCliente != '') {
      String endereco = cupom.enderecoCliente;
      String celular = cupom.celular;
      String email = cupom.email;

      wCliente = pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.Text('CLIENTE', style: pw.TextStyle(font: fontTitulo, fontSize: impressaoTamanhoFonteSubTitulo, fontWeight: pw.FontWeight.normal)),
          pw.Text(cupom.nomeCliente, style: pw.TextStyle(font: fontTitulo, fontSize: impressaoTamanhoFonteTitulo, fontWeight: pw.FontWeight.normal), textAlign: TextAlign.center),
          celular.trim().isEmpty ? pw.SizedBox() : pw.Text(cupom.celular, style: pw.TextStyle(font: fontTitulo, fontSize: impressaoTamanhoFonteTexto, fontWeight: pw.FontWeight.normal)),
          email.trim().isEmpty ? pw.SizedBox() : pw.Text(cupom.email, style: pw.TextStyle(font: fontTitulo, fontSize: impressaoTamanhoFonteTexto, fontWeight: pw.FontWeight.normal)),
          endereco.trim().isEmpty
              ? pw.SizedBox()
              : pw.Text(cupom.enderecoCliente, style: pw.TextStyle(font: fontDetalhe, fontSize: impressaoTamanhoFonteTexto, fontWeight: pw.FontWeight.normal), textAlign: TextAlign.center),
          pw.Divider(height: impressaoEspacamento),
        ],
      );
    }

    ///
    /// Id pedido Pai
    ///

    pw.Widget wPedido = pw.SizedBox();

    if (cupom.idPai != '0') {
      wPedido = pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.Text('Pedido original no. ${cupom.idPai}', style: pw.TextStyle(font: fontTitulo, fontSize: impressaoTamanhoFonteSubTitulo, fontWeight: pw.FontWeight.normal)),
          pw.Divider(height: impressaoEspacamento),
        ],
      );
    }

    ///
    /// Atendimento
    ///

    pw.Widget wAtendimento = pw.SizedBox();

    if (primeiroNomeComissionado != '') {
      wAtendimento = pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.Text('ATENDIMENTO $primeiroNomeComissionado', style: pw.TextStyle(font: fontTitulo, fontSize: impressaoTamanhoFonteSubTitulo, fontWeight: pw.FontWeight.normal)),
          pw.Divider(height: impressaoEspacamento),
          pw.Text(consumidor, style: pw.TextStyle(font: fontTitulo, fontSize: impressaoTamanhoFonteSubTitulo, fontWeight: pw.FontWeight.normal)),
          pw.Divider(height: impressaoEspacamento),
        ],
      );
    } else {
      wAtendimento = pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.Text(consumidor, style: pw.TextStyle(font: fontTitulo, fontSize: impressaoTamanhoFonteSubTitulo, fontWeight: pw.FontWeight.normal)),
          pw.Divider(height: impressaoEspacamento),
        ],
      );
    }

    ///
    /// Itens do cupom
    ///

    List<pw.Widget> list = [];

    for (var i = 0; i < cupom.itens.length; i++) {
      if (cupom.itens[i].peso > 0) {
        list.add(
          pw.Text(
            '${(i + 1).toString().padLeft(3, '0')} ${cupom.itens[i].digitado} ${cupom.itens[i].nome}',
            style: pw.TextStyle(fontSize: impressaoTamanhoFonteProduto, font: fontDetalhe),
          ),
        );
      } else {
        list.add(
          pw.Text(
            '${(i + 1).toString().padLeft(3, '0')} ${cupom.itens[i].digitado} ${cupom.itens[i].nome} - ${cupom.itens[i].unidadeSigla}',
            style: pw.TextStyle(fontSize: impressaoTamanhoFonteProduto, font: fontDetalhe),
          ),
        );
      }

      list.add(
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Text(
              cupom.itens[i].linhaTotalImp,
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(fontSize: impressaoTamanhoFonteProdutoValores, font: fontDetalhe),
            ),
          ],
        ),
      );
      if (cupom.itens[i].linhaTotalDescImp != '') {
        list.add(
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text(
                '(desconto) ${cupom.itens[i].linhaTotalDescImp}',
                textAlign: pw.TextAlign.right,
                style: pw.TextStyle(fontSize: impressaoTamanhoFonteProdutoValores, font: fontDetalhe),
              ),
            ],
          ),
        );
      }

      list.add(
        pw.SizedBox(height: 4),
      );
    }

    ///
    /// Itens de pagamento
    ///

    List<pw.Widget> listPagtos = [];

    for (var i = 0; i < cupom.pagtos.length; i++) {
      int parcelas = cupom.pagtos[i].parcelas;
      String nome = parcelas == 0 ? cupom.pagtos[i].nome : '${cupom.pagtos[i].nome} ${parcelas}x';

      if (impressaoTamanhoFonteTotais <= 10) {
        listPagtos.add(pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Text(
              nome + cupom.pagtos[i].valorF.padLeft(11),
              style: pw.TextStyle(font: fontDetalhe, fontSize: impressaoTamanhoFonteTotais),
            ),
          ],
        ));
      } else {
        var v = impressaoTamanhoFonteTotais <= 14
            ? impressaoTamanhoFonteTotais <= 14
                ? 3
                : 6
            : 8;
        listPagtos.add(pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Text(
              nome,
              style: pw.TextStyle(font: fontDetalhe, fontSize: impressaoTamanhoFonteTotais - v),
            ),
            pw.Text(
              cupom.pagtos[i].valorF.padLeft(11),
              style: pw.TextStyle(font: fontDetalhe, fontSize: impressaoTamanhoFonteTotais),
            ),
          ],
        ));
      }
    }

    double inch = 72.0;
    double mm = inch / 25.4;

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(double.parse(impressaoTamanhoPapel) * mm, double.infinity, marginAll: 1 * mm),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              ///
              /// Cancelado
              ///

              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  wCancelado,
                ],
              ),

              ///
              /// Cabeçalho
              ///

              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  // pw.Padding(
                  //   padding: const pw.EdgeInsets.only(left: 20, right: 20),
                  //   child: pw.Image(netImage),
                  // ),
                  pw.Divider(height: impressaoEspacamento),
                  pw.Text(empresa.nome, style: pw.TextStyle(font: fontTitulo, fontSize: impressaoTamanhoFonteTitulo, fontWeight: pw.FontWeight.normal), textAlign: TextAlign.center),
                  pw.Text('CNPJ:${empresa.cpfCnpj}', style: pw.TextStyle(font: fontDetalhe, fontSize: impressaoTamanhoFonteTexto)),
                  pw.Text('${empresa.logradouro} ${empresa.numero} ${empresa.complemento}', style: pw.TextStyle(font: fontDetalhe, fontSize: impressaoTamanhoFonteTexto), textAlign: TextAlign.center),
                  pw.Text(empresa.bairro, style: pw.TextStyle(font: fontDetalhe, fontSize: impressaoTamanhoFonteTexto)),
                  pw.Text('${empresa.municipio} - ${empresa.uF}', style: pw.TextStyle(font: fontDetalhe, fontSize: impressaoTamanhoFonteTexto)),
                  wContato,
                  wTextoAdicionalContato,
                  pw.Divider(height: impressaoEspacamento),
                  pw.Text(tipoMovimento == '1' ? 'Venda X' : 'Pedido ${venda.idVenda}', style: pw.TextStyle(font: fontTitulo, fontSize: impressaoTamanhoFonteTitulo, fontWeight: pw.FontWeight.normal)),
                  pw.Text('Emissão:${empresa.dataCadastro}', style: pw.TextStyle(font: fontDetalhe, fontSize: impressaoTamanhoFonteTexto)),
                  pw.Text(venda.nomeFuncionarioOperador, style: pw.TextStyle(font: fontDetalhe, fontSize: impressaoTamanhoFonteTexto, fontWeight: pw.FontWeight.bold)),
                  pw.Text(venda.nomeCargoFuncionarioOperador, style: pw.TextStyle(font: fontDetalhe, fontSize: impressaoTamanhoFonteTexto, fontWeight: pw.FontWeight.bold)),
                  pw.Divider(height: impressaoEspacamento),
                  pw.Text('${cupom.qtdProdutos.toStringAsFixed(0)} Iten(s)', style: pw.TextStyle(font: fontTitulo, fontSize: impressaoTamanhoFonteSubTitulo, fontWeight: pw.FontWeight.normal)),
                  pw.Divider(height: impressaoEspacamento),
                ],
              ),

              ///
              /// Itens
              ///

              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: list,
              ),

              ///
              /// Totais
              ///

              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  //pw.Divider(height: _impressaoEspacamento),
                  //pw.Text('Quantidade de itens: ' + cupom.qtdProdutos.toStringAsFixed(0), style: pw.TextStyle(font: fontDetalhe, fontSize: _impressaoTamanhoFonteSubTitulo, fontWeight: pw.FontWeight.bold)),
                  pw.Divider(height: impressaoEspacamento),
                  pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                    pw.Text(('SUB-TOTAL ${cupom.subTotalF.padLeft(10)}'), style: pw.TextStyle(font: fontDetalhe, fontSize: impressaoTamanhoFonteTotais)),
                  ]),
                  pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                    pw.Text(('ACRÉSCIMO ${cupom.acrescimoF.padLeft(10)}'), style: pw.TextStyle(font: fontDetalhe, fontSize: impressaoTamanhoFonteTotais)),
                  ]),
                  pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                    pw.Text((' DESCONTO ${cupom.descontoF.padLeft(10)}'), style: pw.TextStyle(font: fontDetalhe, fontSize: impressaoTamanhoFonteTotais)),
                  ]),
                  pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                    pw.Text(('    TOTAL ${cupom.totalF.padLeft(10)}'), style: pw.TextStyle(font: fontDetalhe, fontSize: impressaoTamanhoFonteTotais)),
                  ]),
                  //pw.Divider(height: _impressaoEspacamento),
                  //pw.Text('Formas de pagamento', style: pw.TextStyle(font: fontDetalhe, fontSize: _impressaoTamanhoFonteSubTitulo, fontWeight: pw.FontWeight.bold)),
                  //pw.Divider(height: _impressaoEspacamento),
                ],
              ),

              ///
              /// Formas de pagamentos
              ///

              pw.SizedBox(height: 3),

              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: listPagtos,
              ),

              pw.SizedBox(height: 3),

              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      cupom.tipoMovimento == '2'
                          ? pw.SizedBox()
                          : pw.Text(
                              ('     TROCO ${cupom.trocoF.padLeft(10)}'),
                              style: pw.TextStyle(font: fontDetalhe, fontSize: impressaoTamanhoFonteTotais),
                            ),
                    ],
                  ),
                ],
              ),

              ///
              /// Troco / Consumidor
              ///

              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Divider(height: impressaoEspacamento),
                  wAtendimento,
                  wPedido,
                  wCliente,
                  wFiscal,
                  wRodape,
                ],
              ),

              ///
              /// Cancelado
              ///

              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  wCancelado,
                ],
              ),

              ///
              /// Fim
              ///
            ],
          ); // Center
        },
      ),
    ); // Page

    if (modo == 'imprimir') {
      try {
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => doc.save(),
          format: impressaoTamanhoPapel == '58' ? PdfPageFormat.roll57 : PdfPageFormat.roll80,
          name: 'FACILE',
        ).then((value) => () {
              Navigator.pop(context);
            });
      } catch (e) {
        //facilePrintErro(context);
      }
    } else if (modo == 'compartilhar') {
      await facileSharePdf(await doc.save(), subdominio, 'CUPOM', '');
    } else {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => PdfPreview(
            allowPrinting: false,
            allowSharing: false,
            dpi: 300,
            canDebug: false,
            canChangeOrientation: false,
            canChangePageFormat: false,
            build: (PdfPageFormat format) => doc.save(),
          ),
        ),
      );
    }
  }
}

class CupomItem {
  String idProduto;
  String nome;
  String digitado;
  String eanSistema;
  String eanFornecedor;
  String nomeCampoVarA;
  String nomeCampoVarB;
  String nomeCampoVarC;
  double qCom = 0.00;
  double vUnCom = 0.00;
  double vDesc = 0.00;
  double vAcre = 0.00;
  double vTotal = 0.00;
  double vSubTotal = 0.00;
  double custoAtual = 0.00;
  String imagemPrincipal;
  String unidadeSigla;
  bool temDesconto;
  bool atacado;
  String precoAplicadoIndice;
  double precoAplicado;
  double precoTabela;
  double precoDesconto;
  double precoPromocional;
  double peso;
  double estoque;

  bool daVez = false;

  String linhaTotal = '';
  String linhaTotalImp = '';
  String linhaTotalDescImp = '';

  CupomItem({
    required this.idProduto,
    required this.nome,
    required this.digitado,
    required this.eanSistema,
    required this.eanFornecedor,
    required this.nomeCampoVarA,
    required this.nomeCampoVarB,
    required this.nomeCampoVarC,
    required this.qCom,
    required this.vUnCom,
    required this.vDesc,
    required this.custoAtual,
    required this.imagemPrincipal,
    required this.unidadeSigla,
    required this.temDesconto,
    required this.atacado,
    required this.precoAplicadoIndice,
    required this.precoAplicado,
    required this.precoTabela,
    required this.precoDesconto,
    required this.precoPromocional,
    required this.peso,
    required this.estoque,
  });

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    var hash = md5.convert(utf8.encode('${DateTime.now().millisecondsSinceEpoch}-${UniqueKey()}')).toString();

    return <String, dynamic>{
      'hash': hash,
      'idProduto': idProduto,
      'nome': nome,
      'digitado': digitado,
      'eanSistema': eanSistema,
      'eanFornecedor': eanFornecedor,
      'nomeCampoVarA': nomeCampoVarA,
      'nomeCampoVarB': nomeCampoVarB,
      'nomeCampoVarC': nomeCampoVarC,
      'qCom': qCom,
      'vUnCom': vUnCom,
      'vDesc': vDesc,
      'custoAtual': custoAtual,
      'vAcre': vAcre,
      'vTotal': vTotal,
      'vSubTotal': vSubTotal,
      'unidadeSigla': unidadeSigla,
      'precoAplicadoIndice': precoAplicadoIndice,
      'precoAplicado': precoAplicado,
      'precoTabela': precoTabela,
      'precoDesconto': precoDesconto,
      'precoPromocional': precoPromocional,
      'peso': peso,
      'estoque': estoque,
    };
  }
}

class CupomPagto {
  String idMeioPagamento;
  String nome;
  String codigoSefaz;
  String gerarXml;
  double valor = 0.00;
  int parcelas = 0;

  String valorF = '';

  CupomPagto({
    required this.idMeioPagamento,
    required this.nome,
    required this.codigoSefaz,
    required this.gerarXml,
    required this.valor,
    required this.parcelas,
  });

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    var hash = md5.convert(utf8.encode('${DateTime.now().millisecondsSinceEpoch}-${UniqueKey()}')).toString();

    return <String, dynamic>{
      'hash': hash,
      'idMeioPagamento': idMeioPagamento,
      'nome': nome,
      'codigoSefaz': codigoSefaz,
      'gerarXml': gerarXml,
      'valor': valor,
      'parcelas': parcelas,
    };
  }
}

void impressaoEtiqueta(context, caption, codigoEan, {imprimeCodigo = true}) async {
  final doc = pw.Document();
  final barCodeSvg = Barcode.ean13(
    drawEndChar: false,
  ).toSvg(
    codigoEan,
    width: 150,
    height: 50,
    drawText: imprimeCodigo,
  );

  double inch = 72.0;
  double mm = inch / 25.4;

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat(40 * mm, double.infinity, marginAll: 1 * mm),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(caption, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SvgImage(svg: barCodeSvg),
          ],
        ); // Center
      },
    ),
  ); // Page

  try {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      format: PdfPageFormat.roll57,
      name: 'FACILE',
    ).then((value) => () {
          Navigator.pop(context);
        });
  } catch (e) {
    //facilePrintErro(context);
  }
}

void impressaoLeituraGerencial(
  context,
  subdominio,
  aResult,
  String caption,
  listCartoes,
  listOutros,
  modo,
) async {
  var aEmpresa = aResult['Empresa'];
  final doc = pw.Document();
  final fontDetalhe = await PdfGoogleFonts.ubuntuMonoRegular();

  NumberFormat format = NumberFormat('###,##0.00', 'pt_BR');

  final impressaoEspacamento = double.parse(aResult['_impressaoEspacamento']);
  final impressaoTelefonePadrao = aResult['_impressaoTelefonePadrao'];
  final impressaoTamanhoPapel = aResult['_impressaoTamanhoPapel'];

  ///
  /// Telefone de contato
  ///

  pw.Widget wContato = pw.SizedBox();
  String sContato;

  sContato = aEmpresa['Celular'];

  if (impressaoTelefonePadrao == 'Celular' && sContato.isNotEmpty) {
    wContato = pw.Text(sContato, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold));
  }

  sContato = aEmpresa['Telefone'];

  if (impressaoTelefonePadrao == 'Fixo' && sContato.isNotEmpty) {
    wContato = pw.Text(sContato, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold));
  }

  ///
  /// Cartoes
  ///

  List<pw.Widget> wlistCartoes = [];
  double totalCartoes = 0.00;

  wlistCartoes.add(
    pw.Text(
      'CARTÕES',
      style: pw.TextStyle(
        fontSize: 12,
        fontWeight: pw.FontWeight.bold,
      ),
    ),
  );

  wlistCartoes.add(pw.SizedBox(height: 5));

  for (var i = 0; i < listCartoes.length; i++) {
    wlistCartoes.add(
      pw.Text(
        (listCartoes[i].meioPagamento + '(' + listCartoes[i].qtd + ')').padRight(19) + listCartoes[i].totalF.padLeft(12),
        style: pw.TextStyle(
          font: fontDetalhe,
          fontSize: 10,
        ),
      ),
    );

    totalCartoes += double.parse(listCartoes[i].total);
  }

  wlistCartoes.add(
    pw.Divider(height: impressaoEspacamento),
  );

  wlistCartoes.add(
    pw.Text(
      format.format(totalCartoes).padLeft(26),
      style: pw.TextStyle(
        font: fontDetalhe,
        fontSize: 12,
        fontWeight: pw.FontWeight.bold,
      ),
    ),
  );

  wlistCartoes.add(pw.SizedBox(height: 5));

  ///
  /// Outros
  ///

  List<pw.Widget> wlistOutros = [];
  double totalOutros = 0.00;

  wlistOutros.add(
    pw.Text(
      'OUTROS',
      style: pw.TextStyle(
        fontSize: 12,
        fontWeight: pw.FontWeight.bold,
      ),
    ),
  );

  wlistOutros.add(pw.SizedBox(height: 5));

  for (var i = 0; i < listOutros.length; i++) {
    wlistOutros.add(
      pw.Text(
        (listOutros[i].meioPagamento + '(' + listOutros[i].qtd + ')').padRight(19) + listOutros[i].totalF.padLeft(12),
        style: pw.TextStyle(
          font: fontDetalhe,
          fontSize: 10,
        ),
      ),
    );

    totalOutros += double.parse(listOutros[i].total);
  }

  wlistOutros.add(
    pw.Divider(height: impressaoEspacamento),
  );

  wlistOutros.add(
    pw.Text(
      format.format(totalOutros).padLeft(26),
      style: pw.TextStyle(
        font: fontDetalhe,
        fontSize: 12,
        fontWeight: pw.FontWeight.bold,
      ),
    ),
  );

  wlistCartoes.add(pw.SizedBox(height: 5));

  ///
  /// Print
  ///

  double inch = 72.0;
  double mm = inch / 25.4;

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat(double.parse(impressaoTamanhoPapel) * mm, double.infinity, marginAll: 1 * mm),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            ///
            /// Cabeçalho
            ///

            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Divider(height: impressaoEspacamento),
                pw.Text(aEmpresa['Nome'], style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                pw.Text('CNPJ:${aEmpresa['CpfCnpjF']}', style: const pw.TextStyle(fontSize: 7)),
                pw.Text(aEmpresa['Logradouro'] + ' ' + aEmpresa['Numero'] + ' ' + aEmpresa['Complemento'], style: const pw.TextStyle(fontSize: 7)),
                pw.Text(aEmpresa['Bairro'] + ' - ' + aEmpresa['Municipio'] + ' - ' + aEmpresa['UF'], style: const pw.TextStyle(fontSize: 7)),
                wContato,
                pw.Text('Emissão:${DateFormat('dd/MM/yyyy hh:mm').format(DateTime.now())}', style: const pw.TextStyle(fontSize: 8)),
                pw.Divider(height: impressaoEspacamento),
                pw.Text('Leitura Gerencial', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                pw.Text(caption, style: pw.TextStyle(fontSize: caption.length > 10 ? 9 : 14, fontWeight: pw.FontWeight.bold)),
                pw.Divider(height: impressaoEspacamento),
                pw.SizedBox(height: 5),
              ],
            ),

            ///
            /// Cartoes
            ///

            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: wlistCartoes,
            ),

            ///
            /// Outros
            ///

            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: wlistOutros,
            ),

            ///
            /// Total
            ///

            pw.SizedBox(height: 20),
            pw.Text(
              '* * * TOTAL * * *',
              style: pw.TextStyle(
                fontSize: 8,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              format.format(totalCartoes + totalOutros),
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ); // Center
      },
    ),
  ); // Page

  if (modo == 'imprimir') {
    try {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save(),
        format: impressaoTamanhoPapel == '58' ? PdfPageFormat.roll57 : PdfPageFormat.roll80,
        name: 'FACILE',
      ).then((value) => () {
            Navigator.pop(context);
          });
    } catch (e) {
      // facilePrintErro(context);
    }
  } else {
    await facileSharePdf(await doc.save(), subdominio, 'LEITURA GERENCIAL', '');
  }
}

void impressaoAtendimentos(context, subdominio, aResult, caption, listAtendimento, modo) async {
  var aEmpresa = aResult['Empresa'];
  final doc = pw.Document();
  final fontDetalhe = await PdfGoogleFonts.ubuntuMonoRegular();

  NumberFormat format = NumberFormat('###,##0.00', 'pt_BR');

  //final fontDetalhe = await PdfGoogleFonts.ubuntuMonoRegular();

  //final _impressaoTamanhoFonteProduto = double.parse(aResult['_impressaoTamanhoFonteProduto']);
  final impressaoEspacamento = double.parse(aResult['_impressaoEspacamento']);
  final impressaoTelefonePadrao = aResult['_impressaoTelefonePadrao'];
  final impressaoTamanhoPapel = aResult['_impressaoTamanhoPapel'];
  //final _impressaoTextoAdicionalContato = aResult['_impressaoTextoAdicionalContato'];

  ///
  /// Telefone de contato
  ///

  pw.Widget wContato = pw.SizedBox();
  String sContato;

  sContato = aEmpresa['Celular'];

  if (impressaoTelefonePadrao == 'Celular' && sContato.isNotEmpty) {
    wContato = pw.Text(sContato, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold));
  }

  sContato = aEmpresa['Telefone'];

  if (impressaoTelefonePadrao == 'Fixo' && sContato.isNotEmpty) {
    wContato = pw.Text(sContato, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold));
  }

  ///
  /// Atendimentos
  ///

  List<pw.Widget> wlistAtendimento = [];
  double totalAtendimento = 0.00;

  wlistAtendimento.add(pw.SizedBox(height: 5));

  for (var i = 0; i < listAtendimento.length; i++) {
    wlistAtendimento.add(
      pw.Text(
        listAtendimento[i].meioPagamento.padRight(19) + listAtendimento[i].totalF.padLeft(12),
        style: pw.TextStyle(
          font: fontDetalhe,
          fontSize: 10,
        ),
      ),
    );

    totalAtendimento += double.parse(listAtendimento[i].total);
  }

  wlistAtendimento.add(
    pw.Divider(height: impressaoEspacamento),
  );

  wlistAtendimento.add(
    pw.Text(
      format.format(totalAtendimento).padLeft(26),
      style: pw.TextStyle(
        font: fontDetalhe,
        fontSize: 12,
        fontWeight: pw.FontWeight.bold,
      ),
    ),
  );

  wlistAtendimento.add(pw.SizedBox(height: 5));

  ///
  /// Print
  ///

  double inch = 72.0;
  double mm = inch / 25.4;

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat(double.parse(impressaoTamanhoPapel) * mm, double.infinity, marginAll: 1 * mm),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            ///
            /// Cabeçalho
            ///

            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Divider(height: impressaoEspacamento),
                pw.Text(aEmpresa['Nome'], style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                pw.Text('CNPJ:${aEmpresa['CpfCnpjF']}', style: const pw.TextStyle(fontSize: 7)),
                pw.Text(aEmpresa['Logradouro'] + ' ' + aEmpresa['Numero'] + ' ' + aEmpresa['Complemento'], style: const pw.TextStyle(fontSize: 7)),
                pw.Text(aEmpresa['Bairro'] + ' - ' + aEmpresa['Municipio'] + ' - ' + aEmpresa['UF'], style: const pw.TextStyle(fontSize: 7)),
                wContato,
                pw.Text('Emissão:${DateFormat('dd/MM/yyyy hh:mm').format(DateTime.now())}', style: const pw.TextStyle(fontSize: 8)),
                pw.Divider(height: impressaoEspacamento),
                pw.Text('Atendimentos', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                pw.Text(caption, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.Divider(height: impressaoEspacamento),
                pw.SizedBox(height: 5),
              ],
            ),

            ///
            /// Atendimento
            ///

            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: wlistAtendimento,
            ),

            ///
            /// Total
            ///

            pw.SizedBox(height: 20),
            pw.Text(
              '* * * TOTAL * * *',
              style: pw.TextStyle(
                fontSize: 8,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              format.format(totalAtendimento),
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ); // Center
      },
    ),
  ); // Page

  debugPrint(aResult.toString());

  if (modo == 'imprimir') {
    try {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save(),
        format: impressaoTamanhoPapel == '58' ? PdfPageFormat.roll57 : PdfPageFormat.roll80,
        name: 'FACILE',
      ).then((value) => () {
            Navigator.pop(context);
          });
    } catch (e) {
      //facilePrintErro(context);
    }
  } else {
    await facileSharePdf(await doc.save(), subdominio, 'ATENDIMENTOS', '');
  }
}

void impressaoRelPadrao(context,
    {required String subdominio,
    required String titulo,
    required String intervalo,
    required List<String> aHeaders,
    required List<int> aHeadersFlex,
    required List<int> aHeadersAlign,
    required aData,
    required aOptions,
    required String printOrShare}) async {
  final doc = pw.Document();
  final fontDetalhe = await PdfGoogleFonts.ubuntuMonoRegular();
  final fontTitulo = await PdfGoogleFonts.staatlichesRegular();

  //final _impressaoTamanhoFonteProduto = double.parse(aOptions['_impressaoTamanhoFonteProduto']);
  const impressaoTamanhoFonteProduto = 8.0;

  pw.TextStyle tituloStyle = pw.TextStyle(font: fontTitulo, fontSize: 20, color: PdfColors.grey, fontWeight: pw.FontWeight.bold);
  pw.TextStyle intervaloStyle = pw.TextStyle(font: fontDetalhe, fontSize: 16, color: PdfColors.grey, fontWeight: pw.FontWeight.bold);
  pw.TextStyle dataStyle = pw.TextStyle(font: fontDetalhe, fontSize: impressaoTamanhoFonteProduto, color: PdfColors.black, fontWeight: pw.FontWeight.bold);
  pw.TextStyle dataStyleNumber = pw.TextStyle(font: fontDetalhe, fontSize: impressaoTamanhoFonteProduto + 3, color: PdfColors.black, fontWeight: pw.FontWeight.bold);

  PdfColor colorGrey = PdfColors.grey;

  ///
  /// Header
  ///

  List<pw.Widget> listCaptions = [];

  for (var i = 0; i < aHeaders.length; i++) {
    listCaptions.add(
      pw.Expanded(
        child: pw.Row(
          mainAxisAlignment: aHeadersAlign[i] == 0 ? pw.MainAxisAlignment.start : pw.MainAxisAlignment.end,
          children: [
            pw.Text(aHeaders[i], style: dataStyle),
          ],
        ),
        flex: aHeadersFlex[i],
      ),
    );
  }

  ///
  /// Data
  ///

  List<pw.Widget> listData = [];

  for (var row in aData) {
    List<pw.Widget> wCols = [];
    bool bTotal = false;

    for (var i = 0; i < row.length; i++) {
      wCols.add(
        pw.Expanded(
          child: pw.Row(
            mainAxisAlignment: aHeadersAlign[i] == 0 ? pw.MainAxisAlignment.start : pw.MainAxisAlignment.end,
            children: [
              pw.Flexible(
                child: pw.Text(row[i], style: aHeadersAlign[i] == 0 ? dataStyle : dataStyleNumber),
              ),
            ],
          ),
          flex: aHeadersFlex[i],
        ),
      );

      if (row[i] == 'TOTAL') {
        bTotal = true;
      }
    }
    if (bTotal) {
      listData.add(
        pw.Divider(color: colorGrey),
      );
    }

    listData.add(
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: wCols,
      ),
    );
  }

  ///
  /// Page
  ///

  intervalo = 'Período $intervalo';
  subdominio = subdominio.toUpperCase();

  doc.addPage(
    pw.MultiPage(
      margin: const pw.EdgeInsets.all(20.0),
      pageFormat: PdfPageFormat.a4,

      //orientation: PageOrientation.landscape,

      ///
      /// Header
      ///
      header: (pw.Context context) {
        return pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Stack(
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text(subdominio, style: tituloStyle),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(titulo, style: tituloStyle),
                  ],
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text(intervalo, style: intervaloStyle),
              ],
            ),
            pw.Divider(color: colorGrey),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: listCaptions,
            ),
            pw.Divider(color: colorGrey),
          ],
        );
      },

      ///
      /// Footer
      ///
      footer: (pw.Context context) {
        return pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
          child: pw.Text(
            'Emitido por Facile APP / Emissão ${DateFormat('dd/MM/yyyy hh:mm').format(DateTime.now())} Pagina ${context.pageNumber} / ${context.pagesCount}',
            style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.grey),
          ),
        );
      },

      ///
      /// Body
      ///
      build: (pw.Context context) => <pw.Widget>[
        ///
        /// Cabeçalho
        ///

        pw.Column(children: listData),
      ],
    ),
  ); // Page

  if (printOrShare == 'print') {
    try {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save(),
        format: PdfPageFormat.a4,
        name: 'FACILE',
      ).then((value) => () {
            Navigator.pop(context);
          });
    } catch (e) {
      //facilePrintErro(context);
    }
  } else {
    await facileSharePdf(await doc.save(), subdominio, titulo, intervalo);
  }
}

Future<void> facileSharePdf(Uint8List bytes, subdominio, titulo, intervalo) async {
  String s = subdominio.toLowerCase() + '-' + titulo.toLowerCase() + '.pdf';

  subdominio = subdominio.toUpperCase();

  await Printing.sharePdf(
    bytes: bytes,
    filename: s.replaceAll(' ', ''),
    subject: 'Facile Loja App - $subdominio: $titulo',
    body: 'Enviado por $subdominio\r\n\r\nConforme solicitado, segue relatório em anexo.\r\n $intervalo\r\n\r\nAtenciosamente,\r\nEquipe Facile Vendas',
  );
}
