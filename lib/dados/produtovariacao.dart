import 'dart:convert';

class ProdutoVariacao {
  int id; // ": 835,
  String dataCadastro; // ": "2024-07-04 11:20:44",
  String dataAlteracao; // ": "2024-07-04 11:20:44",
  int idProduto; // ": 61363,
  String sku; // ": "",
  int idVariacaoA; // ": 1,
  String nomeCampoVarA; // ": "VU",
  int idVariacaoB; // ": 0,
  String nomeCampoVarB; // ": "",
  double preco; // ": 119.99,
  String estoqueControlado; // ": "N"
  ProdutoVariacao({
    required this.id,
    required this.dataCadastro,
    required this.dataAlteracao,
    required this.idProduto,
    required this.sku,
    required this.idVariacaoA,
    required this.nomeCampoVarA,
    required this.idVariacaoB,
    required this.nomeCampoVarB,
    required this.preco,
    required this.estoqueControlado,
  });

  ProdutoVariacao copyWith({
    int? id,
    String? dataCadastro,
    String? dataAlteracao,
    int? idProduto,
    String? sku,
    int? idVariacaoA,
    String? nomeCampoVarA,
    int? idVariacaoB,
    String? nomeCampoVarB,
    double? preco,
    String? estoqueControlado,
  }) {
    return ProdutoVariacao(
      id: id ?? this.id,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      dataAlteracao: dataAlteracao ?? this.dataAlteracao,
      idProduto: idProduto ?? this.idProduto,
      sku: sku ?? this.sku,
      idVariacaoA: idVariacaoA ?? this.idVariacaoA,
      nomeCampoVarA: nomeCampoVarA ?? this.nomeCampoVarA,
      idVariacaoB: idVariacaoB ?? this.idVariacaoB,
      nomeCampoVarB: nomeCampoVarB ?? this.nomeCampoVarB,
      preco: preco ?? this.preco,
      estoqueControlado: estoqueControlado ?? this.estoqueControlado,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'dataCadastro': dataCadastro});
    result.addAll({'dataAlteracao': dataAlteracao});
    result.addAll({'idProduto': idProduto});
    result.addAll({'sku': sku});
    result.addAll({'idVariacaoA': idVariacaoA});
    result.addAll({'nomeCampoVarA': nomeCampoVarA});
    result.addAll({'idVariacaoB': idVariacaoB});
    result.addAll({'nomeCampoVarB': nomeCampoVarB});
    result.addAll({'preco': preco});
    result.addAll({'estoqueControlado': estoqueControlado});

    return result;
  }

  factory ProdutoVariacao.fromMap(Map<String, dynamic> map) {
    return ProdutoVariacao(
      id: map['id']?.toInt() ?? 0,
      dataCadastro: map['dataCadastro'] ?? '',
      dataAlteracao: map['dataAlteracao'] ?? '',
      idProduto: map['idProduto']?.toInt() ?? 0,
      sku: map['sku'] ?? '',
      idVariacaoA: map['idVariacaoA']?.toInt() ?? 0,
      nomeCampoVarA: map['nomeCampoVarA'] ?? '',
      idVariacaoB: map['idVariacaoB']?.toInt() ?? 0,
      nomeCampoVarB: map['nomeCampoVarB'] ?? '',
      preco: map['preco']?.toDouble() ?? 0.0,
      estoqueControlado: map['estoqueControlado'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProdutoVariacao.fromJson(String source) => ProdutoVariacao.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProdutoVariacao(id: $id, dataCadastro: $dataCadastro, dataAlteracao: $dataAlteracao, idProduto: $idProduto, sku: $sku, idVariacaoA: $idVariacaoA, nomeCampoVarA: $nomeCampoVarA, idVariacaoB: $idVariacaoB, nomeCampoVarB: $nomeCampoVarB, preco: $preco, estoqueControlado: $estoqueControlado)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProdutoVariacao &&
        other.id == id &&
        other.dataCadastro == dataCadastro &&
        other.dataAlteracao == dataAlteracao &&
        other.idProduto == idProduto &&
        other.sku == sku &&
        other.idVariacaoA == idVariacaoA &&
        other.nomeCampoVarA == nomeCampoVarA &&
        other.idVariacaoB == idVariacaoB &&
        other.nomeCampoVarB == nomeCampoVarB &&
        other.preco == preco &&
        other.estoqueControlado == estoqueControlado;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        dataCadastro.hashCode ^
        dataAlteracao.hashCode ^
        idProduto.hashCode ^
        sku.hashCode ^
        idVariacaoA.hashCode ^
        nomeCampoVarA.hashCode ^
        idVariacaoB.hashCode ^
        nomeCampoVarB.hashCode ^
        preco.hashCode ^
        estoqueControlado.hashCode;
  }
}
