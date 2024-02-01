// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AtendimentoLoja {
  String id;
  String idVenda;
  String data;
  String hora;
  String host;
  String idFuncionarioComissionado;
  String nomeFuncionarioComissionado;
  String origem;
  String tipo;
  String cliente;
  String cpfCnpj;
  String celular;
  String email;
  String status;
  String nomeStatus;
  String idSugestaoMeioPagamento;
  String nomeSugestaoMeioPagamento;
  String subTotal;
  String desconto;
  String total;
  String imagem;
  String idFuncionarioAtendimento;
  String subTotalF;
  String descontoF;
  String totalF;
  AtendimentoLoja({
    required this.id,
    required this.idVenda,
    required this.data,
    required this.hora,
    required this.host,
    required this.idFuncionarioComissionado,
    required this.nomeFuncionarioComissionado,
    required this.origem,
    required this.tipo,
    required this.cliente,
    required this.cpfCnpj,
    required this.celular,
    required this.email,
    required this.status,
    required this.nomeStatus,
    required this.idSugestaoMeioPagamento,
    required this.nomeSugestaoMeioPagamento,
    required this.subTotal,
    required this.desconto,
    required this.total,
    required this.imagem,
    required this.idFuncionarioAtendimento,
    required this.subTotalF,
    required this.descontoF,
    required this.totalF,
  });

  AtendimentoLoja copyWith({
    String? id,
    String? idVenda,
    String? data,
    String? hora,
    String? host,
    String? idFuncionarioComissionado,
    String? nomeFuncionarioComissionado,
    String? origem,
    String? tipo,
    String? cliente,
    String? cpfCnpj,
    String? celular,
    String? email,
    String? status,
    String? nomeStatus,
    String? idSugestaoMeioPagamento,
    String? nomeSugestaoMeioPagamento,
    String? subTotal,
    String? desconto,
    String? total,
    String? imagem,
    String? idFuncionarioAtendimento,
    String? subTotalF,
    String? descontoF,
    String? totalF,
  }) {
    return AtendimentoLoja(
      id: id ?? this.id,
      idVenda: idVenda ?? this.idVenda,
      data: data ?? this.data,
      hora: hora ?? this.hora,
      host: host ?? this.host,
      idFuncionarioComissionado: idFuncionarioComissionado ?? this.idFuncionarioComissionado,
      nomeFuncionarioComissionado: nomeFuncionarioComissionado ?? this.nomeFuncionarioComissionado,
      origem: origem ?? this.origem,
      tipo: tipo ?? this.tipo,
      cliente: cliente ?? this.cliente,
      cpfCnpj: cpfCnpj ?? this.cpfCnpj,
      celular: celular ?? this.celular,
      email: email ?? this.email,
      status: status ?? this.status,
      nomeStatus: nomeStatus ?? this.nomeStatus,
      idSugestaoMeioPagamento: idSugestaoMeioPagamento ?? this.idSugestaoMeioPagamento,
      nomeSugestaoMeioPagamento: nomeSugestaoMeioPagamento ?? this.nomeSugestaoMeioPagamento,
      subTotal: subTotal ?? this.subTotal,
      desconto: desconto ?? this.desconto,
      total: total ?? this.total,
      imagem: imagem ?? this.imagem,
      idFuncionarioAtendimento: idFuncionarioAtendimento ?? this.idFuncionarioAtendimento,
      subTotalF: subTotalF ?? this.subTotalF,
      descontoF: descontoF ?? this.descontoF,
      totalF: totalF ?? this.totalF,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'idVenda': idVenda,
      'data': data,
      'hora': hora,
      'host': host,
      'idFuncionarioComissionado': idFuncionarioComissionado,
      'nomeFuncionarioComissionado': nomeFuncionarioComissionado,
      'origem': origem,
      'tipo': tipo,
      'cliente': cliente,
      'cpfCnpj': cpfCnpj,
      'celular': celular,
      'email': email,
      'status': status,
      'nomeStatus': nomeStatus,
      'idSugestaoMeioPagamento': idSugestaoMeioPagamento,
      'nomeSugestaoMeioPagamento': nomeSugestaoMeioPagamento,
      'subTotal': subTotal,
      'desconto': desconto,
      'total': total,
      'imagem': imagem,
      'idFuncionarioAtendimento': idFuncionarioAtendimento,
      'subTotalF': subTotalF,
      'descontoF': descontoF,
      'totalF': totalF,
    };
  }

  factory AtendimentoLoja.fromMap(Map<String, dynamic> map) {
    return AtendimentoLoja(
      id: map['id'] as String,
      idVenda: map['idVenda'] as String,
      data: map['data'] as String,
      hora: map['hora'] as String,
      host: map['host'] as String,
      idFuncionarioComissionado: map['idFuncionarioComissionado'] as String,
      nomeFuncionarioComissionado: map['nomeFuncionarioComissionado'] as String,
      origem: map['origem'] as String,
      tipo: map['tipo'] as String,
      cliente: map['cliente'] as String,
      cpfCnpj: map['cpfCnpj'] as String,
      celular: map['celular'] as String,
      email: map['email'] as String,
      status: map['status'] as String,
      nomeStatus: map['nomeStatus'] as String,
      idSugestaoMeioPagamento: map['idSugestaoMeioPagamento'] as String,
      nomeSugestaoMeioPagamento: map['nomeSugestaoMeioPagamento'] as String,
      subTotal: map['subTotal'] as String,
      desconto: map['desconto'] as String,
      total: map['total'] as String,
      imagem: map['imagem'] as String,
      idFuncionarioAtendimento: map['idFuncionarioAtendimento'] as String,
      subTotalF: map['subTotalF'] as String,
      descontoF: map['descontoF'] as String,
      totalF: map['totalF'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AtendimentoLoja.fromJson(String source) => AtendimentoLoja.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AtendimentoLoja(id: $id, idVenda: $idVenda, data: $data, hora: $hora, host: $host, idFuncionarioComissionado: $idFuncionarioComissionado, nomeFuncionarioComissionado: $nomeFuncionarioComissionado, origem: $origem, tipo: $tipo, cliente: $cliente, cpfCnpj: $cpfCnpj, celular: $celular, email: $email, status: $status, nomeStatus: $nomeStatus, idSugestaoMeioPagamento: $idSugestaoMeioPagamento, nomeSugestaoMeioPagamento: $nomeSugestaoMeioPagamento, subTotal: $subTotal, desconto: $desconto, total: $total, imagem: $imagem, idFuncionarioAtendimento: $idFuncionarioAtendimento, subTotalF: $subTotalF, descontoF: $descontoF, totalF: $totalF)';
  }

  @override
  bool operator ==(covariant AtendimentoLoja other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.idVenda == idVenda &&
        other.data == data &&
        other.hora == hora &&
        other.host == host &&
        other.idFuncionarioComissionado == idFuncionarioComissionado &&
        other.nomeFuncionarioComissionado == nomeFuncionarioComissionado &&
        other.origem == origem &&
        other.tipo == tipo &&
        other.cliente == cliente &&
        other.cpfCnpj == cpfCnpj &&
        other.celular == celular &&
        other.email == email &&
        other.status == status &&
        other.nomeStatus == nomeStatus &&
        other.idSugestaoMeioPagamento == idSugestaoMeioPagamento &&
        other.nomeSugestaoMeioPagamento == nomeSugestaoMeioPagamento &&
        other.subTotal == subTotal &&
        other.desconto == desconto &&
        other.total == total &&
        other.imagem == imagem &&
        other.idFuncionarioAtendimento == idFuncionarioAtendimento &&
        other.subTotalF == subTotalF &&
        other.descontoF == descontoF &&
        other.totalF == totalF;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        idVenda.hashCode ^
        data.hashCode ^
        hora.hashCode ^
        host.hashCode ^
        idFuncionarioComissionado.hashCode ^
        nomeFuncionarioComissionado.hashCode ^
        origem.hashCode ^
        tipo.hashCode ^
        cliente.hashCode ^
        cpfCnpj.hashCode ^
        celular.hashCode ^
        email.hashCode ^
        status.hashCode ^
        nomeStatus.hashCode ^
        idSugestaoMeioPagamento.hashCode ^
        nomeSugestaoMeioPagamento.hashCode ^
        subTotal.hashCode ^
        desconto.hashCode ^
        total.hashCode ^
        imagem.hashCode ^
        idFuncionarioAtendimento.hashCode ^
        subTotalF.hashCode ^
        descontoF.hashCode ^
        totalF.hashCode;
  }
}
