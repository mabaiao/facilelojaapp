// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProdutoVariacao {
  String id;
  String dataCadastro;
  String dataAlteracao;
  String idProduto;
  String sku;
  String idVariacaoA;
  String nomeCampoVarA;
  String idVariacaoB;
  String nomeCampoVarB;
  String idVariacaoC;
  String nomeCampoVarC;
  String f_1;
  String eanSistema;
  String eanFornecedor;
  String codigoFornecedor;
  String precoVendaVarejo;
  String precoVendaAtacado;
  String precoVendaPromocional;
  String precoVendaIfood;
  String estoqueAtual;
  String estoqueControlado;
  String estoqueAtualF;
  String precoVendaVarejoF;
  String precoVendaAtacadoF;
  String precoVendaPromocionalF;
  String precoVendaIfoodF;
  String quantidadeSelecionada;
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
    required this.idVariacaoC,
    required this.nomeCampoVarC,
    required this.f_1,
    required this.eanSistema,
    required this.eanFornecedor,
    required this.codigoFornecedor,
    required this.precoVendaVarejo,
    required this.precoVendaAtacado,
    required this.precoVendaPromocional,
    required this.precoVendaIfood,
    required this.estoqueAtual,
    required this.estoqueControlado,
    required this.estoqueAtualF,
    required this.precoVendaVarejoF,
    required this.precoVendaAtacadoF,
    required this.precoVendaPromocionalF,
    required this.precoVendaIfoodF,
    required this.quantidadeSelecionada,
  });

  ProdutoVariacao copyWith({
    String? id,
    String? dataCadastro,
    String? dataAlteracao,
    String? idProduto,
    String? sku,
    String? idVariacaoA,
    String? nomeCampoVarA,
    String? idVariacaoB,
    String? nomeCampoVarB,
    String? idVariacaoC,
    String? nomeCampoVarC,
    String? f_1,
    String? eanSistema,
    String? eanFornecedor,
    String? codigoFornecedor,
    String? precoVendaVarejo,
    String? precoVendaAtacado,
    String? precoVendaPromocional,
    String? precoVendaIfood,
    String? estoqueAtual,
    String? estoqueControlado,
    String? estoqueAtualF,
    String? precoVendaVarejoF,
    String? precoVendaAtacadoF,
    String? precoVendaPromocionalF,
    String? precoVendaIfoodF,
    String? quantidadeSelecionada,
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
      idVariacaoC: idVariacaoC ?? this.idVariacaoC,
      nomeCampoVarC: nomeCampoVarC ?? this.nomeCampoVarC,
      f_1: f_1 ?? this.f_1,
      eanSistema: eanSistema ?? this.eanSistema,
      eanFornecedor: eanFornecedor ?? this.eanFornecedor,
      codigoFornecedor: codigoFornecedor ?? this.codigoFornecedor,
      precoVendaVarejo: precoVendaVarejo ?? this.precoVendaVarejo,
      precoVendaAtacado: precoVendaAtacado ?? this.precoVendaAtacado,
      precoVendaPromocional: precoVendaPromocional ?? this.precoVendaPromocional,
      precoVendaIfood: precoVendaIfood ?? this.precoVendaIfood,
      estoqueAtual: estoqueAtual ?? this.estoqueAtual,
      estoqueControlado: estoqueControlado ?? this.estoqueControlado,
      estoqueAtualF: estoqueAtualF ?? this.estoqueAtualF,
      precoVendaVarejoF: precoVendaVarejoF ?? this.precoVendaVarejoF,
      precoVendaAtacadoF: precoVendaAtacadoF ?? this.precoVendaAtacadoF,
      precoVendaPromocionalF: precoVendaPromocionalF ?? this.precoVendaPromocionalF,
      precoVendaIfoodF: precoVendaIfoodF ?? this.precoVendaIfoodF,
      quantidadeSelecionada: quantidadeSelecionada ?? this.quantidadeSelecionada,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'dataCadastro': dataCadastro,
      'dataAlteracao': dataAlteracao,
      'idProduto': idProduto,
      'sku': sku,
      'idVariacaoA': idVariacaoA,
      'nomeCampoVarA': nomeCampoVarA,
      'idVariacaoB': idVariacaoB,
      'nomeCampoVarB': nomeCampoVarB,
      'idVariacaoC': idVariacaoC,
      'nomeCampoVarC': nomeCampoVarC,
      'f_1': f_1,
      'eanSistema': eanSistema,
      'eanFornecedor': eanFornecedor,
      'codigoFornecedor': codigoFornecedor,
      'precoVendaVarejo': precoVendaVarejo,
      'precoVendaAtacado': precoVendaAtacado,
      'precoVendaPromocional': precoVendaPromocional,
      'precoVendaIfood': precoVendaIfood,
      'estoqueAtual': estoqueAtual,
      'estoqueControlado': estoqueControlado,
      'estoqueAtualF': estoqueAtualF,
      'precoVendaVarejoF': precoVendaVarejoF,
      'precoVendaAtacadoF': precoVendaAtacadoF,
      'precoVendaPromocionalF': precoVendaPromocionalF,
      'precoVendaIfoodF': precoVendaIfoodF,
      'quantidadeSelecionada': quantidadeSelecionada,
    };
  }

  factory ProdutoVariacao.fromMap(Map<String, dynamic> map) {
    return ProdutoVariacao(
      id: map['id'] as String,
      dataCadastro: map['dataCadastro'] as String,
      dataAlteracao: map['dataAlteracao'] as String,
      idProduto: map['idProduto'] as String,
      sku: map['sku'] as String,
      idVariacaoA: map['idVariacaoA'] as String,
      nomeCampoVarA: map['nomeCampoVarA'] as String,
      idVariacaoB: map['idVariacaoB'] as String,
      nomeCampoVarB: map['nomeCampoVarB'] as String,
      idVariacaoC: map['idVariacaoC'] as String,
      nomeCampoVarC: map['nomeCampoVarC'] as String,
      f_1: map['f_1'] as String,
      eanSistema: map['eanSistema'] as String,
      eanFornecedor: map['eanFornecedor'] as String,
      codigoFornecedor: map['codigoFornecedor'] as String,
      precoVendaVarejo: map['precoVendaVarejo'] as String,
      precoVendaAtacado: map['precoVendaAtacado'] as String,
      precoVendaPromocional: map['precoVendaPromocional'] as String,
      precoVendaIfood: map['precoVendaIfood'] as String,
      estoqueAtual: map['estoqueAtual'] as String,
      estoqueControlado: map['estoqueControlado'] as String,
      estoqueAtualF: map['estoqueAtualF'] as String,
      precoVendaVarejoF: map['precoVendaVarejoF'] as String,
      precoVendaAtacadoF: map['precoVendaAtacadoF'] as String,
      precoVendaPromocionalF: map['precoVendaPromocionalF'] as String,
      precoVendaIfoodF: map['precoVendaIfoodF'] as String,
      quantidadeSelecionada: map['quantidadeSelecionada'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProdutoVariacao.fromJson(String source) => ProdutoVariacao.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProdutoVariacao(id: $id, dataCadastro: $dataCadastro, dataAlteracao: $dataAlteracao, idProduto: $idProduto, sku: $sku, idVariacaoA: $idVariacaoA, nomeCampoVarA: $nomeCampoVarA, idVariacaoB: $idVariacaoB, nomeCampoVarB: $nomeCampoVarB, idVariacaoC: $idVariacaoC, nomeCampoVarC: $nomeCampoVarC, f_1: $f_1, eanSistema: $eanSistema, eanFornecedor: $eanFornecedor, codigoFornecedor: $codigoFornecedor, precoVendaVarejo: $precoVendaVarejo, precoVendaAtacado: $precoVendaAtacado, precoVendaPromocional: $precoVendaPromocional, precoVendaIfood: $precoVendaIfood, estoqueAtual: $estoqueAtual, estoqueControlado: $estoqueControlado, estoqueAtualF: $estoqueAtualF, precoVendaVarejoF: $precoVendaVarejoF, precoVendaAtacadoF: $precoVendaAtacadoF, precoVendaPromocionalF: $precoVendaPromocionalF, precoVendaIfoodF: $precoVendaIfoodF, quantidadeSelecionada: $quantidadeSelecionada)';
  }

  @override
  bool operator ==(covariant ProdutoVariacao other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.dataCadastro == dataCadastro &&
        other.dataAlteracao == dataAlteracao &&
        other.idProduto == idProduto &&
        other.sku == sku &&
        other.idVariacaoA == idVariacaoA &&
        other.nomeCampoVarA == nomeCampoVarA &&
        other.idVariacaoB == idVariacaoB &&
        other.nomeCampoVarB == nomeCampoVarB &&
        other.idVariacaoC == idVariacaoC &&
        other.nomeCampoVarC == nomeCampoVarC &&
        other.f_1 == f_1 &&
        other.eanSistema == eanSistema &&
        other.eanFornecedor == eanFornecedor &&
        other.codigoFornecedor == codigoFornecedor &&
        other.precoVendaVarejo == precoVendaVarejo &&
        other.precoVendaAtacado == precoVendaAtacado &&
        other.precoVendaPromocional == precoVendaPromocional &&
        other.precoVendaIfood == precoVendaIfood &&
        other.estoqueAtual == estoqueAtual &&
        other.estoqueControlado == estoqueControlado &&
        other.estoqueAtualF == estoqueAtualF &&
        other.precoVendaVarejoF == precoVendaVarejoF &&
        other.precoVendaAtacadoF == precoVendaAtacadoF &&
        other.precoVendaPromocionalF == precoVendaPromocionalF &&
        other.precoVendaIfoodF == precoVendaIfoodF &&
        other.quantidadeSelecionada == quantidadeSelecionada;
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
        idVariacaoC.hashCode ^
        nomeCampoVarC.hashCode ^
        f_1.hashCode ^
        eanSistema.hashCode ^
        eanFornecedor.hashCode ^
        codigoFornecedor.hashCode ^
        precoVendaVarejo.hashCode ^
        precoVendaAtacado.hashCode ^
        precoVendaPromocional.hashCode ^
        precoVendaIfood.hashCode ^
        estoqueAtual.hashCode ^
        estoqueControlado.hashCode ^
        estoqueAtualF.hashCode ^
        precoVendaVarejoF.hashCode ^
        precoVendaAtacadoF.hashCode ^
        precoVendaPromocionalF.hashCode ^
        precoVendaIfoodF.hashCode ^
        quantidadeSelecionada.hashCode;
  }
}
