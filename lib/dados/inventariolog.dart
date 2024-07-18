import 'dart:convert';

class InventarioLog {
  int id;
  int idProduto;
  String nome;
  String codigo;
  String dataCadastro;
  double quantidade;
  InventarioLog({
    required this.id,
    required this.idProduto,
    required this.nome,
    required this.codigo,
    required this.dataCadastro,
    required this.quantidade,
  });

  InventarioLog copyWith({
    int? id,
    int? idProduto,
    String? nome,
    String? codigo,
    String? dataCadastro,
    double? quantidade,
  }) {
    return InventarioLog(
      id: id ?? this.id,
      idProduto: idProduto ?? this.idProduto,
      nome: nome ?? this.nome,
      codigo: codigo ?? this.codigo,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      quantidade: quantidade ?? this.quantidade,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'idProduto': idProduto});
    result.addAll({'nome': nome});
    result.addAll({'codigo': codigo});
    result.addAll({'dataCadastro': dataCadastro});
    result.addAll({'quantidade': quantidade});

    return result;
  }

  factory InventarioLog.fromMap(Map<String, dynamic> map) {
    return InventarioLog(
      id: map['id']?.toInt() ?? 0,
      idProduto: map['idProduto']?.toInt() ?? 0,
      nome: map['nome'] ?? '',
      codigo: map['codigo'] ?? '',
      dataCadastro: map['dataCadastro'] ?? '',
      quantidade: map['quantidade']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory InventarioLog.fromJson(String source) => InventarioLog.fromMap(json.decode(source));

  @override
  String toString() {
    return 'InventarioLog(id: $id, idProduto: $idProduto, nome: $nome, codigo: $codigo, dataCadastro: $dataCadastro, quantidade: $quantidade)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InventarioLog && other.id == id && other.idProduto == idProduto && other.nome == nome && other.codigo == codigo && other.dataCadastro == dataCadastro && other.quantidade == quantidade;
  }

  @override
  int get hashCode {
    return id.hashCode ^ idProduto.hashCode ^ nome.hashCode ^ codigo.hashCode ^ dataCadastro.hashCode ^ quantidade.hashCode;
  }
}
