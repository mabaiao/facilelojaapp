import 'dart:convert';

class Inventario {
  int id;
  String dataCadastro;
  String dataAlteracao;
  int idFuncionario;
  int idLojaFisica;
  String observacao;
  String statusInventario;
  Inventario({
    required this.id,
    required this.dataCadastro,
    required this.dataAlteracao,
    required this.idFuncionario,
    required this.idLojaFisica,
    required this.observacao,
    required this.statusInventario,
  });

  Inventario copyWith({
    int? id,
    String? dataCadastro,
    String? dataAlteracao,
    int? idFuncionario,
    int? idLojaFisica,
    String? observacao,
    String? statusInventario,
  }) {
    return Inventario(
      id: id ?? this.id,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      dataAlteracao: dataAlteracao ?? this.dataAlteracao,
      idFuncionario: idFuncionario ?? this.idFuncionario,
      idLojaFisica: idLojaFisica ?? this.idLojaFisica,
      observacao: observacao ?? this.observacao,
      statusInventario: statusInventario ?? this.statusInventario,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'dataCadastro': dataCadastro});
    result.addAll({'dataAlteracao': dataAlteracao});
    result.addAll({'idFuncionario': idFuncionario});
    result.addAll({'idLojaFisica': idLojaFisica});
    result.addAll({'observacao': observacao});
    result.addAll({'statusInventario': statusInventario});

    return result;
  }

  factory Inventario.fromMap(Map<String, dynamic> map) {
    return Inventario(
      id: map['id']?.toInt() ?? 0,
      dataCadastro: map['dataCadastro'] ?? '',
      dataAlteracao: map['dataAlteracao'] ?? '',
      idFuncionario: map['idFuncionario']?.toInt() ?? 0,
      idLojaFisica: map['idLojaFisica']?.toInt() ?? 0,
      observacao: map['observacao'] ?? '',
      statusInventario: map['statusInventario'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Inventario.fromJson(String source) => Inventario.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Inventario(id: $id, dataCadastro: $dataCadastro, dataAlteracao: $dataAlteracao, idFuncionario: $idFuncionario, idLojaFisica: $idLojaFisica, observacao: $observacao, statusInventario: $statusInventario)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Inventario &&
        other.id == id &&
        other.dataCadastro == dataCadastro &&
        other.dataAlteracao == dataAlteracao &&
        other.idFuncionario == idFuncionario &&
        other.idLojaFisica == idLojaFisica &&
        other.observacao == observacao &&
        other.statusInventario == statusInventario;
  }

  @override
  int get hashCode {
    return id.hashCode ^ dataCadastro.hashCode ^ dataAlteracao.hashCode ^ idFuncionario.hashCode ^ idLojaFisica.hashCode ^ observacao.hashCode ^ statusInventario.hashCode;
  }
}
