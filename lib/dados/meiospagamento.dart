// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MeiosPagamento {
  String id;
  String nome;
  String codigoSefaz;
  String mostrarPdv;
  String gerarXml;
  String pedeParcelamento;
  MeiosPagamento({
    required this.id,
    required this.nome,
    required this.codigoSefaz,
    required this.mostrarPdv,
    required this.gerarXml,
    required this.pedeParcelamento,
  });

  MeiosPagamento copyWith({
    String? id,
    String? nome,
    String? codigoSefaz,
    String? mostrarPdv,
    String? gerarXml,
    String? pedeParcelamento,
  }) {
    return MeiosPagamento(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      codigoSefaz: codigoSefaz ?? this.codigoSefaz,
      mostrarPdv: mostrarPdv ?? this.mostrarPdv,
      gerarXml: gerarXml ?? this.gerarXml,
      pedeParcelamento: pedeParcelamento ?? this.pedeParcelamento,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'codigoSefaz': codigoSefaz,
      'mostrarPdv': mostrarPdv,
      'gerarXml': gerarXml,
      'pedeParcelamento': pedeParcelamento,
    };
  }

  factory MeiosPagamento.fromMap(Map<String, dynamic> map) {
    return MeiosPagamento(
      id: map['id'] as String,
      nome: map['nome'] as String,
      codigoSefaz: map['codigoSefaz'] as String,
      mostrarPdv: map['mostrarPdv'] as String,
      gerarXml: map['gerarXml'] as String,
      pedeParcelamento: map['pedeParcelamento'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MeiosPagamento.fromJson(String source) => MeiosPagamento.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MeiosPagamento(id: $id, nome: $nome, codigoSefaz: $codigoSefaz, mostrarPdv: $mostrarPdv, gerarXml: $gerarXml, pedeParcelamento: $pedeParcelamento)';
  }

  @override
  bool operator ==(covariant MeiosPagamento other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.nome == nome &&
      other.codigoSefaz == codigoSefaz &&
      other.mostrarPdv == mostrarPdv &&
      other.gerarXml == gerarXml &&
      other.pedeParcelamento == pedeParcelamento;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      nome.hashCode ^
      codigoSefaz.hashCode ^
      mostrarPdv.hashCode ^
      gerarXml.hashCode ^
      pedeParcelamento.hashCode;
  }
}
