// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class VendaItem {
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
  String idProduto;
  String digitado;
  String eanSistema;
  String eanFornecedor;
  String nomeCampoVarA;
  String nomeCampoVarB;
  String nomeCampoVarC;
  String f_2;
  String qCom;
  String vUnCom;
  String vDesc;
  String vAcre;
  String vSubTotal;
  String vTotal;
  String nome;
  String unidadeSigla;
  String custoAtual;
  String peso;
  String precoAplicadoIndice;
  String precoAplicadoDescricao;
  String precoAplicado;
  String idFuncionarioComissionado;
  VendaItem({
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
    required this.idProduto,
    required this.digitado,
    required this.eanSistema,
    required this.eanFornecedor,
    required this.nomeCampoVarA,
    required this.nomeCampoVarB,
    required this.nomeCampoVarC,
    required this.f_2,
    required this.qCom,
    required this.vUnCom,
    required this.vDesc,
    required this.vAcre,
    required this.vSubTotal,
    required this.vTotal,
    required this.nome,
    required this.unidadeSigla,
    required this.custoAtual,
    required this.peso,
    required this.precoAplicadoIndice,
    required this.precoAplicadoDescricao,
    required this.precoAplicado,
    required this.idFuncionarioComissionado,
  });

  VendaItem copyWith({
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
    String? idProduto,
    String? digitado,
    String? eanSistema,
    String? eanFornecedor,
    String? nomeCampoVarA,
    String? nomeCampoVarB,
    String? nomeCampoVarC,
    String? f_2,
    String? qCom,
    String? vUnCom,
    String? vDesc,
    String? vAcre,
    String? vSubTotal,
    String? vTotal,
    String? nome,
    String? unidadeSigla,
    String? custoAtual,
    String? peso,
    String? precoAplicadoIndice,
    String? precoAplicadoDescricao,
    String? precoAplicado,
    String? idFuncionarioComissionado,
  }) {
    return VendaItem(
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
      idProduto: idProduto ?? this.idProduto,
      digitado: digitado ?? this.digitado,
      eanSistema: eanSistema ?? this.eanSistema,
      eanFornecedor: eanFornecedor ?? this.eanFornecedor,
      nomeCampoVarA: nomeCampoVarA ?? this.nomeCampoVarA,
      nomeCampoVarB: nomeCampoVarB ?? this.nomeCampoVarB,
      nomeCampoVarC: nomeCampoVarC ?? this.nomeCampoVarC,
      f_2: f_2 ?? this.f_2,
      qCom: qCom ?? this.qCom,
      vUnCom: vUnCom ?? this.vUnCom,
      vDesc: vDesc ?? this.vDesc,
      vAcre: vAcre ?? this.vAcre,
      vSubTotal: vSubTotal ?? this.vSubTotal,
      vTotal: vTotal ?? this.vTotal,
      nome: nome ?? this.nome,
      unidadeSigla: unidadeSigla ?? this.unidadeSigla,
      custoAtual: custoAtual ?? this.custoAtual,
      peso: peso ?? this.peso,
      precoAplicadoIndice: precoAplicadoIndice ?? this.precoAplicadoIndice,
      precoAplicadoDescricao: precoAplicadoDescricao ?? this.precoAplicadoDescricao,
      precoAplicado: precoAplicado ?? this.precoAplicado,
      idFuncionarioComissionado: idFuncionarioComissionado ?? this.idFuncionarioComissionado,
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
      'idProduto': idProduto,
      'digitado': digitado,
      'eanSistema': eanSistema,
      'eanFornecedor': eanFornecedor,
      'nomeCampoVarA': nomeCampoVarA,
      'nomeCampoVarB': nomeCampoVarB,
      'nomeCampoVarC': nomeCampoVarC,
      'f_2': f_2,
      'qCom': qCom,
      'vUnCom': vUnCom,
      'vDesc': vDesc,
      'vAcre': vAcre,
      'vSubTotal': vSubTotal,
      'vTotal': vTotal,
      'nome': nome,
      'unidadeSigla': unidadeSigla,
      'custoAtual': custoAtual,
      'peso': peso,
      'precoAplicadoIndice': precoAplicadoIndice,
      'precoAplicadoDescricao': precoAplicadoDescricao,
      'precoAplicado': precoAplicado,
      'idFuncionarioComissionado': idFuncionarioComissionado,
    };
  }

  factory VendaItem.fromMap(Map<String, dynamic> map) {
    return VendaItem(
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
      idProduto: map['idProduto'] as String,
      digitado: map['digitado'] as String,
      eanSistema: map['eanSistema'] as String,
      eanFornecedor: map['eanFornecedor'] as String,
      nomeCampoVarA: map['nomeCampoVarA'] as String,
      nomeCampoVarB: map['nomeCampoVarB'] as String,
      nomeCampoVarC: map['nomeCampoVarC'] as String,
      f_2: map['f_2'] as String,
      qCom: map['qCom'] as String,
      vUnCom: map['vUnCom'] as String,
      vDesc: map['vDesc'] as String,
      vAcre: map['vAcre'] as String,
      vSubTotal: map['vSubTotal'] as String,
      vTotal: map['vTotal'] as String,
      nome: map['nome'] as String,
      unidadeSigla: map['unidadeSigla'] as String,
      custoAtual: map['custoAtual'] as String,
      peso: map['peso'] as String,
      precoAplicadoIndice: map['precoAplicadoIndice'] as String,
      precoAplicadoDescricao: map['precoAplicadoDescricao'] as String,
      precoAplicado: map['precoAplicado'] as String,
      idFuncionarioComissionado: map['idFuncionarioComissionado'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory VendaItem.fromJson(String source) => VendaItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VendaItem(id: $id, hash: $hash, dataCadastro: $dataCadastro, dataAlteracao: $dataAlteracao, idVenda: $idVenda, idLoja: $idLoja, idEmpresa: $idEmpresa, idFuncionario: $idFuncionario, tipoMovimento: $tipoMovimento, origem: $origem, status: $status, f_1: $f_1, idProduto: $idProduto, digitado: $digitado, eanSistema: $eanSistema, eanFornecedor: $eanFornecedor, nomeCampoVarA: $nomeCampoVarA, nomeCampoVarB: $nomeCampoVarB, nomeCampoVarC: $nomeCampoVarC, f_2: $f_2, qCom: $qCom, vUnCom: $vUnCom, vDesc: $vDesc, vAcre: $vAcre, vSubTotal: $vSubTotal, vTotal: $vTotal, nome: $nome, unidadeSigla: $unidadeSigla, custoAtual: $custoAtual, peso: $peso, precoAplicadoIndice: $precoAplicadoIndice, precoAplicadoDescricao: $precoAplicadoDescricao, precoAplicado: $precoAplicado, idFuncionarioComissionado: $idFuncionarioComissionado)';
  }

  @override
  bool operator ==(covariant VendaItem other) {
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
        other.idProduto == idProduto &&
        other.digitado == digitado &&
        other.eanSistema == eanSistema &&
        other.eanFornecedor == eanFornecedor &&
        other.nomeCampoVarA == nomeCampoVarA &&
        other.nomeCampoVarB == nomeCampoVarB &&
        other.nomeCampoVarC == nomeCampoVarC &&
        other.f_2 == f_2 &&
        other.qCom == qCom &&
        other.vUnCom == vUnCom &&
        other.vDesc == vDesc &&
        other.vAcre == vAcre &&
        other.vSubTotal == vSubTotal &&
        other.vTotal == vTotal &&
        other.nome == nome &&
        other.unidadeSigla == unidadeSigla &&
        other.custoAtual == custoAtual &&
        other.peso == peso &&
        other.precoAplicadoIndice == precoAplicadoIndice &&
        other.precoAplicadoDescricao == precoAplicadoDescricao &&
        other.precoAplicado == precoAplicado &&
        other.idFuncionarioComissionado == idFuncionarioComissionado;
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
        idProduto.hashCode ^
        digitado.hashCode ^
        eanSistema.hashCode ^
        eanFornecedor.hashCode ^
        nomeCampoVarA.hashCode ^
        nomeCampoVarB.hashCode ^
        nomeCampoVarC.hashCode ^
        f_2.hashCode ^
        qCom.hashCode ^
        vUnCom.hashCode ^
        vDesc.hashCode ^
        vAcre.hashCode ^
        vSubTotal.hashCode ^
        vTotal.hashCode ^
        nome.hashCode ^
        unidadeSigla.hashCode ^
        custoAtual.hashCode ^
        peso.hashCode ^
        precoAplicadoIndice.hashCode ^
        precoAplicadoDescricao.hashCode ^
        precoAplicado.hashCode ^
        idFuncionarioComissionado.hashCode;
  }
}
