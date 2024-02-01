// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class VendaPagto {
  String id;
  String hash;
  String dataCadastro;
  String dataAlteracao;
  String idVenda;
  String idLoja;
  String idEmpresa;
  String idFuncionario;
  String tipoMovimento;
  String origem;
  String status;
  String f_1;
  String idMeioPagamento;
  String nome;
  String codigoSefaz;
  String gerarXml;
  String valor;
  String parcelas;
  String dataPagamento;
  VendaPagto({
    required this.id,
    required this.hash,
    required this.dataCadastro,
    required this.dataAlteracao,
    required this.idVenda,
    required this.idLoja,
    required this.idEmpresa,
    required this.idFuncionario,
    required this.tipoMovimento,
    required this.origem,
    required this.status,
    required this.f_1,
    required this.idMeioPagamento,
    required this.nome,
    required this.codigoSefaz,
    required this.gerarXml,
    required this.valor,
    required this.parcelas,
    required this.dataPagamento,
  });

  VendaPagto copyWith({
    String? id,
    String? hash,
    String? dataCadastro,
    String? dataAlteracao,
    String? idVenda,
    String? idLoja,
    String? idEmpresa,
    String? idFuncionario,
    String? tipoMovimento,
    String? origem,
    String? status,
    String? f_1,
    String? idMeioPagamento,
    String? nome,
    String? codigoSefaz,
    String? gerarXml,
    String? valor,
    String? parcelas,
    String? dataPagamento,
  }) {
    return VendaPagto(
      id: id ?? this.id,
      hash: hash ?? this.hash,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      dataAlteracao: dataAlteracao ?? this.dataAlteracao,
      idVenda: idVenda ?? this.idVenda,
      idLoja: idLoja ?? this.idLoja,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      idFuncionario: idFuncionario ?? this.idFuncionario,
      tipoMovimento: tipoMovimento ?? this.tipoMovimento,
      origem: origem ?? this.origem,
      status: status ?? this.status,
      f_1: f_1 ?? this.f_1,
      idMeioPagamento: idMeioPagamento ?? this.idMeioPagamento,
      nome: nome ?? this.nome,
      codigoSefaz: codigoSefaz ?? this.codigoSefaz,
      gerarXml: gerarXml ?? this.gerarXml,
      valor: valor ?? this.valor,
      parcelas: parcelas ?? this.parcelas,
      dataPagamento: dataPagamento ?? this.dataPagamento,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'hash': hash,
      'dataCadastro': dataCadastro,
      'dataAlteracao': dataAlteracao,
      'idVenda': idVenda,
      'idLoja': idLoja,
      'idEmpresa': idEmpresa,
      'idFuncionario': idFuncionario,
      'tipoMovimento': tipoMovimento,
      'origem': origem,
      'status': status,
      'f_1': f_1,
      'idMeioPagamento': idMeioPagamento,
      'nome': nome,
      'codigoSefaz': codigoSefaz,
      'gerarXml': gerarXml,
      'valor': valor,
      'parcelas': parcelas,
      'dataPagamento': dataPagamento,
    };
  }

  factory VendaPagto.fromMap(Map<String, dynamic> map) {
    return VendaPagto(
      id: map['id'] as String,
      hash: map['hash'] as String,
      dataCadastro: map['dataCadastro'] as String,
      dataAlteracao: map['dataAlteracao'] as String,
      idVenda: map['idVenda'] as String,
      idLoja: map['idLoja'] as String,
      idEmpresa: map['idEmpresa'] as String,
      idFuncionario: map['idFuncionario'] as String,
      tipoMovimento: map['tipoMovimento'] as String,
      origem: map['origem'] as String,
      status: map['status'] as String,
      f_1: map['f_1'] as String,
      idMeioPagamento: map['idMeioPagamento'] as String,
      nome: map['nome'] as String,
      codigoSefaz: map['codigoSefaz'] as String,
      gerarXml: map['gerarXml'] as String,
      valor: map['valor'] as String,
      parcelas: map['parcelas'] as String,
      dataPagamento: map['dataPagamento'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory VendaPagto.fromJson(String source) => VendaPagto.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VendaPagto(id: $id, hash: $hash, dataCadastro: $dataCadastro, dataAlteracao: $dataAlteracao, idVenda: $idVenda, idLoja: $idLoja, idEmpresa: $idEmpresa, idFuncionario: $idFuncionario, tipoMovimento: $tipoMovimento, origem: $origem, status: $status, f_1: $f_1, idMeioPagamento: $idMeioPagamento, nome: $nome, codigoSefaz: $codigoSefaz, gerarXml: $gerarXml, valor: $valor, parcelas: $parcelas, dataPagamento: $dataPagamento)';
  }

  @override
  bool operator ==(covariant VendaPagto other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.hash == hash &&
        other.dataCadastro == dataCadastro &&
        other.dataAlteracao == dataAlteracao &&
        other.idVenda == idVenda &&
        other.idLoja == idLoja &&
        other.idEmpresa == idEmpresa &&
        other.idFuncionario == idFuncionario &&
        other.tipoMovimento == tipoMovimento &&
        other.origem == origem &&
        other.status == status &&
        other.f_1 == f_1 &&
        other.idMeioPagamento == idMeioPagamento &&
        other.nome == nome &&
        other.codigoSefaz == codigoSefaz &&
        other.gerarXml == gerarXml &&
        other.valor == valor &&
        other.parcelas == parcelas &&
        other.dataPagamento == dataPagamento;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        hash.hashCode ^
        dataCadastro.hashCode ^
        dataAlteracao.hashCode ^
        idVenda.hashCode ^
        idLoja.hashCode ^
        idEmpresa.hashCode ^
        idFuncionario.hashCode ^
        tipoMovimento.hashCode ^
        origem.hashCode ^
        status.hashCode ^
        f_1.hashCode ^
        idMeioPagamento.hashCode ^
        nome.hashCode ^
        codigoSefaz.hashCode ^
        gerarXml.hashCode ^
        valor.hashCode ^
        parcelas.hashCode ^
        dataPagamento.hashCode;
  }
}
