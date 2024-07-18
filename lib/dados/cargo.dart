import 'dart:convert';

class Cargo {
  final int id;
  final String dataCadastro;
  final String dataAlteracao;
  final String sigla;
  final String nome;
  final String jsonPermissoes;
  Cargo({
    required this.id,
    required this.dataCadastro,
    required this.dataAlteracao,
    required this.sigla,
    required this.nome,
    required this.jsonPermissoes,
  });

  Cargo copyWith({
    int? id,
    String? dataCadastro,
    String? dataAlteracao,
    String? sigla,
    String? nome,
    String? jsonPermissoes,
  }) {
    return Cargo(
      id: id ?? this.id,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      dataAlteracao: dataAlteracao ?? this.dataAlteracao,
      sigla: sigla ?? this.sigla,
      nome: nome ?? this.nome,
      jsonPermissoes: jsonPermissoes ?? this.jsonPermissoes,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'dataCadastro': dataCadastro});
    result.addAll({'dataAlteracao': dataAlteracao});
    result.addAll({'sigla': sigla});
    result.addAll({'nome': nome});
    result.addAll({'jsonPermissoes': jsonPermissoes});

    return result;
  }

  factory Cargo.fromMap(Map<String, dynamic> map) {
    return Cargo(
      id: map['id']?.toInt() ?? 0,
      dataCadastro: map['dataCadastro'] ?? '',
      dataAlteracao: map['dataAlteracao'] ?? '',
      sigla: map['sigla'] ?? '',
      nome: map['nome'] ?? '',
      jsonPermissoes: map['jsonPermissoes'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Cargo.fromJson(String source) => Cargo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Cargo(id: $id, dataCadastro: $dataCadastro, dataAlteracao: $dataAlteracao, sigla: $sigla, nome: $nome, jsonPermissoes: $jsonPermissoes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Cargo && other.id == id && other.dataCadastro == dataCadastro && other.dataAlteracao == dataAlteracao && other.sigla == sigla && other.nome == nome && other.jsonPermissoes == jsonPermissoes;
  }

  @override
  int get hashCode {
    return id.hashCode ^ dataCadastro.hashCode ^ dataAlteracao.hashCode ^ sigla.hashCode ^ nome.hashCode ^ jsonPermissoes.hashCode;
  }
}
