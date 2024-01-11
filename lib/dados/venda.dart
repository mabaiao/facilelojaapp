// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Venda {
  String id;
  String hash;
  String host;
  String dataCadastro;
  String dataCadastroF;
  String horaCadastroF;
  String dataAlteracao;
  String dataAlteracaoF;
  String horaAlteracaoF;
  String idVenda;
  String idPai;
  String idLoja;
  String idEmpresa;
  String idFuncionario;
  String tipoMovimento;
  String origem;
  String status;
  String f_1;
  String descricao;
  String cpfCnpj;
  String celular;
  String email;
  String mesa;
  String idCliente;
  String f_2;
  String acrescimo;
  String desconto;
  String devolucao;
  String subTotal;
  String total;
  String pagoDinheiro;
  String pagoOutros;
  String pago;
  String troco;
  String aPagar;
  String f_3;
  String comissaoTotal;
  String idFuncionarioComissionado;
  String f_4;
  String idVendaFiscal;
  String nomeFuncionarioComissionado;
  String temPix;
  String temDinheiro;
  String temCartao;
  String serie;
  String numero;
  String nomeCliente;
  String enderecoCliente;
  String nomeFuncionarioOperador;
  String nomeCargoFuncionarioOperador;
  Venda({
    required this.id,
    required this.hash,
    required this.host,
    required this.dataCadastro,
    required this.dataCadastroF,
    required this.horaCadastroF,
    required this.dataAlteracao,
    required this.dataAlteracaoF,
    required this.horaAlteracaoF,
    required this.idVenda,
    required this.idPai,
    required this.idLoja,
    required this.idEmpresa,
    required this.idFuncionario,
    required this.tipoMovimento,
    required this.origem,
    required this.status,
    required this.f_1,
    required this.descricao,
    required this.cpfCnpj,
    required this.celular,
    required this.email,
    required this.mesa,
    required this.idCliente,
    required this.f_2,
    required this.acrescimo,
    required this.desconto,
    required this.devolucao,
    required this.subTotal,
    required this.total,
    required this.pagoDinheiro,
    required this.pagoOutros,
    required this.pago,
    required this.troco,
    required this.aPagar,
    required this.f_3,
    required this.comissaoTotal,
    required this.idFuncionarioComissionado,
    required this.f_4,
    required this.idVendaFiscal,
    required this.nomeFuncionarioComissionado,
    required this.temPix,
    required this.temDinheiro,
    required this.temCartao,
    required this.serie,
    required this.numero,
    required this.nomeCliente,
    required this.enderecoCliente,
    required this.nomeFuncionarioOperador,
    required this.nomeCargoFuncionarioOperador,
  });

  Venda copyWith({
    String? id,
    String? hash,
    String? host,
    String? dataCadastro,
    String? dataCadastroF,
    String? horaCadastroF,
    String? dataAlteracao,
    String? dataAlteracaoF,
    String? horaAlteracaoF,
    String? idVenda,
    String? idPai,
    String? idLoja,
    String? idEmpresa,
    String? idFuncionario,
    String? tipoMovimento,
    String? origem,
    String? status,
    String? f_1,
    String? descricao,
    String? cpfCnpj,
    String? celular,
    String? email,
    String? mesa,
    String? idCliente,
    String? f_2,
    String? acrescimo,
    String? desconto,
    String? devolucao,
    String? subTotal,
    String? total,
    String? pagoDinheiro,
    String? pagoOutros,
    String? pago,
    String? troco,
    String? aPagar,
    String? f_3,
    String? comissaoTotal,
    String? idFuncionarioComissionado,
    String? f_4,
    String? idVendaFiscal,
    String? nomeFuncionarioComissionado,
    String? temPix,
    String? temDinheiro,
    String? temCartao,
    String? serie,
    String? numero,
    String? nomeCliente,
    String? enderecoCliente,
    String? nomeFuncionarioOperador,
    String? nomeCargoFuncionarioOperador,
  }) {
    return Venda(
      id: id ?? this.id,
      hash: hash ?? this.hash,
      host: host ?? this.host,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      dataCadastroF: dataCadastroF ?? this.dataCadastroF,
      horaCadastroF: horaCadastroF ?? this.horaCadastroF,
      dataAlteracao: dataAlteracao ?? this.dataAlteracao,
      dataAlteracaoF: dataAlteracaoF ?? this.dataAlteracaoF,
      horaAlteracaoF: horaAlteracaoF ?? this.horaAlteracaoF,
      idVenda: idVenda ?? this.idVenda,
      idPai: idPai ?? this.idPai,
      idLoja: idLoja ?? this.idLoja,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      idFuncionario: idFuncionario ?? this.idFuncionario,
      tipoMovimento: tipoMovimento ?? this.tipoMovimento,
      origem: origem ?? this.origem,
      status: status ?? this.status,
      f_1: f_1 ?? this.f_1,
      descricao: descricao ?? this.descricao,
      cpfCnpj: cpfCnpj ?? this.cpfCnpj,
      celular: celular ?? this.celular,
      email: email ?? this.email,
      mesa: mesa ?? this.mesa,
      idCliente: idCliente ?? this.idCliente,
      f_2: f_2 ?? this.f_2,
      acrescimo: acrescimo ?? this.acrescimo,
      desconto: desconto ?? this.desconto,
      devolucao: devolucao ?? this.devolucao,
      subTotal: subTotal ?? this.subTotal,
      total: total ?? this.total,
      pagoDinheiro: pagoDinheiro ?? this.pagoDinheiro,
      pagoOutros: pagoOutros ?? this.pagoOutros,
      pago: pago ?? this.pago,
      troco: troco ?? this.troco,
      aPagar: aPagar ?? this.aPagar,
      f_3: f_3 ?? this.f_3,
      comissaoTotal: comissaoTotal ?? this.comissaoTotal,
      idFuncionarioComissionado: idFuncionarioComissionado ?? this.idFuncionarioComissionado,
      f_4: f_4 ?? this.f_4,
      idVendaFiscal: idVendaFiscal ?? this.idVendaFiscal,
      nomeFuncionarioComissionado: nomeFuncionarioComissionado ?? this.nomeFuncionarioComissionado,
      temPix: temPix ?? this.temPix,
      temDinheiro: temDinheiro ?? this.temDinheiro,
      temCartao: temCartao ?? this.temCartao,
      serie: serie ?? this.serie,
      numero: numero ?? this.numero,
      nomeCliente: nomeCliente ?? this.nomeCliente,
      enderecoCliente: enderecoCliente ?? this.enderecoCliente,
      nomeFuncionarioOperador: nomeFuncionarioOperador ?? this.nomeFuncionarioOperador,
      nomeCargoFuncionarioOperador: nomeCargoFuncionarioOperador ?? this.nomeCargoFuncionarioOperador,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'hash': hash,
      'host': host,
      'dataCadastro': dataCadastro,
      'dataCadastroF': dataCadastroF,
      'horaCadastroF': horaCadastroF,
      'dataAlteracao': dataAlteracao,
      'dataAlteracaoF': dataAlteracaoF,
      'horaAlteracaoF': horaAlteracaoF,
      'idVenda': idVenda,
      'idPai': idPai,
      'idLoja': idLoja,
      'idEmpresa': idEmpresa,
      'idFuncionario': idFuncionario,
      'tipoMovimento': tipoMovimento,
      'origem': origem,
      'status': status,
      'f_1': f_1,
      'descricao': descricao,
      'cpfCnpj': cpfCnpj,
      'celular': celular,
      'email': email,
      'mesa': mesa,
      'idCliente': idCliente,
      'f_2': f_2,
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
      'f_3': f_3,
      'comissaoTotal': comissaoTotal,
      'idFuncionarioComissionado': idFuncionarioComissionado,
      'f_4': f_4,
      'idVendaFiscal': idVendaFiscal,
      'nomeFuncionarioComissionado': nomeFuncionarioComissionado,
      'temPix': temPix,
      'temDinheiro': temDinheiro,
      'temCartao': temCartao,
      'serie': serie,
      'numero': numero,
      'nomeCliente': nomeCliente,
      'enderecoCliente': enderecoCliente,
      'nomeFuncionarioOperador': nomeFuncionarioOperador,
      'nomeCargoFuncionarioOperador': nomeCargoFuncionarioOperador,
    };
  }

  factory Venda.fromMap(Map<String, dynamic> map) {
    return Venda(
      id: map['id'] as String,
      hash: map['hash'] as String,
      host: map['host'] as String,
      dataCadastro: map['dataCadastro'] as String,
      dataCadastroF: map['dataCadastroF'] as String,
      horaCadastroF: map['horaCadastroF'] as String,
      dataAlteracao: map['dataAlteracao'] as String,
      dataAlteracaoF: map['dataAlteracaoF'] as String,
      horaAlteracaoF: map['horaAlteracaoF'] as String,
      idVenda: map['idVenda'] as String,
      idPai: map['idPai'] as String,
      idLoja: map['idLoja'] as String,
      idEmpresa: map['idEmpresa'] as String,
      idFuncionario: map['idFuncionario'] as String,
      tipoMovimento: map['tipoMovimento'] as String,
      origem: map['origem'] as String,
      status: map['status'] as String,
      f_1: map['f_1'] as String,
      descricao: map['descricao'] as String,
      cpfCnpj: map['cpfCnpj'] as String,
      celular: map['celular'] as String,
      email: map['email'] as String,
      mesa: map['mesa'] as String,
      idCliente: map['idCliente'] as String,
      f_2: map['f_2'] as String,
      acrescimo: map['acrescimo'] as String,
      desconto: map['desconto'] as String,
      devolucao: map['devolucao'] as String,
      subTotal: map['subTotal'] as String,
      total: map['total'] as String,
      pagoDinheiro: map['pagoDinheiro'] as String,
      pagoOutros: map['pagoOutros'] as String,
      pago: map['pago'] as String,
      troco: map['troco'] as String,
      aPagar: map['aPagar'] as String,
      f_3: map['f_3'] as String,
      comissaoTotal: map['comissaoTotal'] as String,
      idFuncionarioComissionado: map['idFuncionarioComissionado'] as String,
      f_4: map['f_4'] as String,
      idVendaFiscal: map['idVendaFiscal'] as String,
      nomeFuncionarioComissionado: map['nomeFuncionarioComissionado'] as String,
      temPix: map['temPix'] as String,
      temDinheiro: map['temDinheiro'] as String,
      temCartao: map['temCartao'] as String,
      serie: map['serie'] as String,
      numero: map['numero'] as String,
      nomeCliente: map['nomeCliente'] as String,
      enderecoCliente: map['enderecoCliente'] as String,
      nomeFuncionarioOperador: map['nomeFuncionarioOperador'] as String,
      nomeCargoFuncionarioOperador: map['nomeCargoFuncionarioOperador'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Venda.fromJson(String source) => Venda.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Venda(id: $id, hash: $hash, host: $host, dataCadastro: $dataCadastro, dataCadastroF: $dataCadastroF, horaCadastroF: $horaCadastroF, dataAlteracao: $dataAlteracao, dataAlteracaoF: $dataAlteracaoF, horaAlteracaoF: $horaAlteracaoF, idVenda: $idVenda, idPai: $idPai, idLoja: $idLoja, idEmpresa: $idEmpresa, idFuncionario: $idFuncionario, tipoMovimento: $tipoMovimento, origem: $origem, status: $status, f_1: $f_1, descricao: $descricao, cpfCnpj: $cpfCnpj, celular: $celular, email: $email, mesa: $mesa, idCliente: $idCliente, f_2: $f_2, acrescimo: $acrescimo, desconto: $desconto, devolucao: $devolucao, subTotal: $subTotal, total: $total, pagoDinheiro: $pagoDinheiro, pagoOutros: $pagoOutros, pago: $pago, troco: $troco, aPagar: $aPagar, f_3: $f_3, comissaoTotal: $comissaoTotal, idFuncionarioComissionado: $idFuncionarioComissionado, f_4: $f_4, idVendaFiscal: $idVendaFiscal, nomeFuncionarioComissionado: $nomeFuncionarioComissionado, temPix: $temPix, temDinheiro: $temDinheiro, temCartao: $temCartao, serie: $serie, numero: $numero, nomeCliente: $nomeCliente, enderecoCliente: $enderecoCliente, nomeFuncionarioOperador: $nomeFuncionarioOperador, nomeCargoFuncionarioOperador: $nomeCargoFuncionarioOperador)';
  }

  @override
  bool operator ==(covariant Venda other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.hash == hash &&
        other.host == host &&
        other.dataCadastro == dataCadastro &&
        other.dataCadastroF == dataCadastroF &&
        other.horaCadastroF == horaCadastroF &&
        other.dataAlteracao == dataAlteracao &&
        other.dataAlteracaoF == dataAlteracaoF &&
        other.horaAlteracaoF == horaAlteracaoF &&
        other.idVenda == idVenda &&
        other.idPai == idPai &&
        other.idLoja == idLoja &&
        other.idEmpresa == idEmpresa &&
        other.idFuncionario == idFuncionario &&
        other.tipoMovimento == tipoMovimento &&
        other.origem == origem &&
        other.status == status &&
        other.f_1 == f_1 &&
        other.descricao == descricao &&
        other.cpfCnpj == cpfCnpj &&
        other.celular == celular &&
        other.email == email &&
        other.mesa == mesa &&
        other.idCliente == idCliente &&
        other.f_2 == f_2 &&
        other.acrescimo == acrescimo &&
        other.desconto == desconto &&
        other.devolucao == devolucao &&
        other.subTotal == subTotal &&
        other.total == total &&
        other.pagoDinheiro == pagoDinheiro &&
        other.pagoOutros == pagoOutros &&
        other.pago == pago &&
        other.troco == troco &&
        other.aPagar == aPagar &&
        other.f_3 == f_3 &&
        other.comissaoTotal == comissaoTotal &&
        other.idFuncionarioComissionado == idFuncionarioComissionado &&
        other.f_4 == f_4 &&
        other.idVendaFiscal == idVendaFiscal &&
        other.nomeFuncionarioComissionado == nomeFuncionarioComissionado &&
        other.temPix == temPix &&
        other.temDinheiro == temDinheiro &&
        other.temCartao == temCartao &&
        other.serie == serie &&
        other.numero == numero &&
        other.nomeCliente == nomeCliente &&
        other.enderecoCliente == enderecoCliente &&
        other.nomeFuncionarioOperador == nomeFuncionarioOperador &&
        other.nomeCargoFuncionarioOperador == nomeCargoFuncionarioOperador;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        hash.hashCode ^
        host.hashCode ^
        dataCadastro.hashCode ^
        dataCadastroF.hashCode ^
        horaCadastroF.hashCode ^
        dataAlteracao.hashCode ^
        dataAlteracaoF.hashCode ^
        horaAlteracaoF.hashCode ^
        idVenda.hashCode ^
        idPai.hashCode ^
        idLoja.hashCode ^
        idEmpresa.hashCode ^
        idFuncionario.hashCode ^
        tipoMovimento.hashCode ^
        origem.hashCode ^
        status.hashCode ^
        f_1.hashCode ^
        descricao.hashCode ^
        cpfCnpj.hashCode ^
        celular.hashCode ^
        email.hashCode ^
        mesa.hashCode ^
        idCliente.hashCode ^
        f_2.hashCode ^
        acrescimo.hashCode ^
        desconto.hashCode ^
        devolucao.hashCode ^
        subTotal.hashCode ^
        total.hashCode ^
        pagoDinheiro.hashCode ^
        pagoOutros.hashCode ^
        pago.hashCode ^
        troco.hashCode ^
        aPagar.hashCode ^
        f_3.hashCode ^
        comissaoTotal.hashCode ^
        idFuncionarioComissionado.hashCode ^
        f_4.hashCode ^
        idVendaFiscal.hashCode ^
        nomeFuncionarioComissionado.hashCode ^
        temPix.hashCode ^
        temDinheiro.hashCode ^
        temCartao.hashCode ^
        serie.hashCode ^
        numero.hashCode ^
        nomeCliente.hashCode ^
        enderecoCliente.hashCode ^
        nomeFuncionarioOperador.hashCode ^
        nomeCargoFuncionarioOperador.hashCode;
  }
}
