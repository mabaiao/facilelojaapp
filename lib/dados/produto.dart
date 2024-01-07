/// **************************
/// Produto
///

import 'dart:convert';

class Produto {
  String id;
  String dataCadastro;
  String dataAlteracao;
  String nome;
  String ativo;
  String idCategoria;
  String idFornecedor;
  String idMenorUnidade;
  String idMaiorUnidade;
  String fatorConversaoUnidade;
  String estoqueMinimo;
  String ncm;
  String cest;
  String idTributacao;
  String precoCusto;
  String pCustoIpi;
  String pCustoST;
  String pCustoFrete;
  String observacoes;
  String altura;
  String largura;
  String profundidade;
  String peso;
  String descricaoDetalhada;
  String precoVendaVarejo;
  String precoVendaAtacado;
  String precoVendaPromocional;
  String categoriaId;
  String categoriaNome;
  String fornecedorId;
  String fornecedorNomeSistema;
  String fornecedorNome;
  String precoVendaVarejoF;
  String precoVendaAtacadoF;
  String precoVendaPromocionalF;
  String jsonImagens;
  String imagemPrincipal;
  String hoje;
  String tributacaoNome;
  String precoCustoFinal;
  String temVariacaoUnica;
  String idVariacaoUnica;
  String unidadeSigla;
  String primeiroEanSistema;
  String variacoes;
  Produto({
    required this.id,
    required this.dataCadastro,
    required this.dataAlteracao,
    required this.nome,
    required this.ativo,
    required this.idCategoria,
    required this.idFornecedor,
    required this.idMenorUnidade,
    required this.idMaiorUnidade,
    required this.fatorConversaoUnidade,
    required this.estoqueMinimo,
    required this.ncm,
    required this.cest,
    required this.idTributacao,
    required this.precoCusto,
    required this.pCustoIpi,
    required this.pCustoST,
    required this.pCustoFrete,
    required this.observacoes,
    required this.altura,
    required this.largura,
    required this.profundidade,
    required this.peso,
    required this.descricaoDetalhada,
    required this.precoVendaVarejo,
    required this.precoVendaAtacado,
    required this.precoVendaPromocional,
    required this.categoriaId,
    required this.categoriaNome,
    required this.fornecedorId,
    required this.fornecedorNomeSistema,
    required this.fornecedorNome,
    required this.precoVendaVarejoF,
    required this.precoVendaAtacadoF,
    required this.precoVendaPromocionalF,
    required this.jsonImagens,
    required this.imagemPrincipal,
    required this.hoje,
    required this.tributacaoNome,
    required this.precoCustoFinal,
    required this.temVariacaoUnica,
    required this.idVariacaoUnica,
    required this.unidadeSigla,
    required this.primeiroEanSistema,
    required this.variacoes,
  });

  Produto copyWith({
    String? id,
    String? dataCadastro,
    String? dataAlteracao,
    String? nome,
    String? ativo,
    String? idCategoria,
    String? idFornecedor,
    String? idMenorUnidade,
    String? idMaiorUnidade,
    String? fatorConversaoUnidade,
    String? estoqueMinimo,
    String? ncm,
    String? cest,
    String? idTributacao,
    String? precoCusto,
    String? pCustoIpi,
    String? pCustoST,
    String? pCustoFrete,
    String? observacoes,
    String? altura,
    String? largura,
    String? profundidade,
    String? peso,
    String? descricaoDetalhada,
    String? precoVendaVarejo,
    String? precoVendaAtacado,
    String? precoVendaPromocional,
    String? categoriaId,
    String? categoriaNome,
    String? fornecedorId,
    String? fornecedorNomeSistema,
    String? fornecedorNome,
    String? precoVendaVarejoF,
    String? precoVendaAtacadoF,
    String? precoVendaPromocionalF,
    String? jsonImagens,
    String? imagemPrincipal,
    String? hoje,
    String? tributacaoNome,
    String? precoCustoFinal,
    String? temVariacaoUnica,
    String? idVariacaoUnica,
    String? unidadeSigla,
    String? primeiroEanSistema,
    String? variacoes,
  }) {
    return Produto(
      id: id ?? this.id,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      dataAlteracao: dataAlteracao ?? this.dataAlteracao,
      nome: nome ?? this.nome,
      ativo: ativo ?? this.ativo,
      idCategoria: idCategoria ?? this.idCategoria,
      idFornecedor: idFornecedor ?? this.idFornecedor,
      idMenorUnidade: idMenorUnidade ?? this.idMenorUnidade,
      idMaiorUnidade: idMaiorUnidade ?? this.idMaiorUnidade,
      fatorConversaoUnidade: fatorConversaoUnidade ?? this.fatorConversaoUnidade,
      estoqueMinimo: estoqueMinimo ?? this.estoqueMinimo,
      ncm: ncm ?? this.ncm,
      cest: cest ?? this.cest,
      idTributacao: idTributacao ?? this.idTributacao,
      precoCusto: precoCusto ?? this.precoCusto,
      pCustoIpi: pCustoIpi ?? this.pCustoIpi,
      pCustoST: pCustoST ?? this.pCustoST,
      pCustoFrete: pCustoFrete ?? this.pCustoFrete,
      observacoes: observacoes ?? this.observacoes,
      altura: altura ?? this.altura,
      largura: largura ?? this.largura,
      profundidade: profundidade ?? this.profundidade,
      peso: peso ?? this.peso,
      descricaoDetalhada: descricaoDetalhada ?? this.descricaoDetalhada,
      precoVendaVarejo: precoVendaVarejo ?? this.precoVendaVarejo,
      precoVendaAtacado: precoVendaAtacado ?? this.precoVendaAtacado,
      precoVendaPromocional: precoVendaPromocional ?? this.precoVendaPromocional,
      categoriaId: categoriaId ?? this.categoriaId,
      categoriaNome: categoriaNome ?? this.categoriaNome,
      fornecedorId: fornecedorId ?? this.fornecedorId,
      fornecedorNomeSistema: fornecedorNomeSistema ?? this.fornecedorNomeSistema,
      fornecedorNome: fornecedorNome ?? this.fornecedorNome,
      precoVendaVarejoF: precoVendaVarejoF ?? this.precoVendaVarejoF,
      precoVendaAtacadoF: precoVendaAtacadoF ?? this.precoVendaAtacadoF,
      precoVendaPromocionalF: precoVendaPromocionalF ?? this.precoVendaPromocionalF,
      jsonImagens: jsonImagens ?? this.jsonImagens,
      imagemPrincipal: imagemPrincipal ?? this.imagemPrincipal,
      hoje: hoje ?? this.hoje,
      tributacaoNome: tributacaoNome ?? this.tributacaoNome,
      precoCustoFinal: precoCustoFinal ?? this.precoCustoFinal,
      temVariacaoUnica: temVariacaoUnica ?? this.temVariacaoUnica,
      idVariacaoUnica: idVariacaoUnica ?? this.idVariacaoUnica,
      unidadeSigla: unidadeSigla ?? this.unidadeSigla,
      primeiroEanSistema: primeiroEanSistema ?? this.primeiroEanSistema,
      variacoes: variacoes ?? this.variacoes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'dataCadastro': dataCadastro,
      'dataAlteracao': dataAlteracao,
      'nome': nome,
      'ativo': ativo,
      'idCategoria': idCategoria,
      'idFornecedor': idFornecedor,
      'idMenorUnidade': idMenorUnidade,
      'idMaiorUnidade': idMaiorUnidade,
      'fatorConversaoUnidade': fatorConversaoUnidade,
      'estoqueMinimo': estoqueMinimo,
      'ncm': ncm,
      'cest': cest,
      'idTributacao': idTributacao,
      'precoCusto': precoCusto,
      'pCustoIpi': pCustoIpi,
      'pCustoST': pCustoST,
      'pCustoFrete': pCustoFrete,
      'observacoes': observacoes,
      'altura': altura,
      'largura': largura,
      'profundidade': profundidade,
      'peso': peso,
      'descricaoDetalhada': descricaoDetalhada,
      'precoVendaVarejo': precoVendaVarejo,
      'precoVendaAtacado': precoVendaAtacado,
      'precoVendaPromocional': precoVendaPromocional,
      'categoriaId': categoriaId,
      'categoriaNome': categoriaNome,
      'fornecedorId': fornecedorId,
      'fornecedorNomeSistema': fornecedorNomeSistema,
      'fornecedorNome': fornecedorNome,
      'precoVendaVarejoF': precoVendaVarejoF,
      'precoVendaAtacadoF': precoVendaAtacadoF,
      'precoVendaPromocionalF': precoVendaPromocionalF,
      'jsonImagens': jsonImagens,
      'imagemPrincipal': imagemPrincipal,
      'hoje': hoje,
      'tributacaoNome': tributacaoNome,
      'precoCustoFinal': precoCustoFinal,
      'temVariacaoUnica': temVariacaoUnica,
      'idVariacaoUnica': idVariacaoUnica,
      'unidadeSigla': unidadeSigla,
      'primeiroEanSistema': primeiroEanSistema,
      'variacoes': variacoes,
    };
  }

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'] as String,
      dataCadastro: map['dataCadastro'] as String,
      dataAlteracao: map['dataAlteracao'] as String,
      nome: map['nome'] as String,
      ativo: map['ativo'] as String,
      idCategoria: map['idCategoria'] as String,
      idFornecedor: map['idFornecedor'] as String,
      idMenorUnidade: map['idMenorUnidade'] as String,
      idMaiorUnidade: map['idMaiorUnidade'] as String,
      fatorConversaoUnidade: map['fatorConversaoUnidade'] as String,
      estoqueMinimo: map['estoqueMinimo'] as String,
      ncm: map['ncm'] as String,
      cest: map['cest'] as String,
      idTributacao: map['idTributacao'] as String,
      precoCusto: map['precoCusto'] as String,
      pCustoIpi: map['pCustoIpi'] as String,
      pCustoST: map['pCustoST'] as String,
      pCustoFrete: map['pCustoFrete'] as String,
      observacoes: map['observacoes'] as String,
      altura: map['altura'] as String,
      largura: map['largura'] as String,
      profundidade: map['profundidade'] as String,
      peso: map['peso'] as String,
      descricaoDetalhada: map['descricaoDetalhada'] as String,
      precoVendaVarejo: map['precoVendaVarejo'] as String,
      precoVendaAtacado: map['precoVendaAtacado'] as String,
      precoVendaPromocional: map['precoVendaPromocional'] as String,
      categoriaId: map['categoriaId'] as String,
      categoriaNome: map['categoriaNome'] as String,
      fornecedorId: map['fornecedorId'] as String,
      fornecedorNomeSistema: map['fornecedorNomeSistema'] as String,
      fornecedorNome: map['fornecedorNome'] as String,
      precoVendaVarejoF: map['precoVendaVarejoF'] as String,
      precoVendaAtacadoF: map['precoVendaAtacadoF'] as String,
      precoVendaPromocionalF: map['precoVendaPromocionalF'] as String,
      jsonImagens: map['jsonImagens'] as String,
      imagemPrincipal: map['imagemPrincipal'] as String,
      hoje: map['hoje'] as String,
      tributacaoNome: map['tributacaoNome'] as String,
      precoCustoFinal: map['precoCustoFinal'] as String,
      temVariacaoUnica: map['temVariacaoUnica'] as String,
      idVariacaoUnica: map['idVariacaoUnica'] as String,
      unidadeSigla: map['unidadeSigla'] as String,
      primeiroEanSistema: map['primeiroEanSistema'] as String,
      variacoes: map['variacoes'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Produto.fromJson(String source) => Produto.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Produto(id: $id, dataCadastro: $dataCadastro, dataAlteracao: $dataAlteracao, nome: $nome, ativo: $ativo, idCategoria: $idCategoria, idFornecedor: $idFornecedor, idMenorUnidade: $idMenorUnidade, idMaiorUnidade: $idMaiorUnidade, fatorConversaoUnidade: $fatorConversaoUnidade, estoqueMinimo: $estoqueMinimo, ncm: $ncm, cest: $cest, idTributacao: $idTributacao, precoCusto: $precoCusto, pCustoIpi: $pCustoIpi, pCustoST: $pCustoST, pCustoFrete: $pCustoFrete, observacoes: $observacoes, altura: $altura, largura: $largura, profundidade: $profundidade, peso: $peso, descricaoDetalhada: $descricaoDetalhada, precoVendaVarejo: $precoVendaVarejo, precoVendaAtacado: $precoVendaAtacado, precoVendaPromocional: $precoVendaPromocional, categoriaId: $categoriaId, categoriaNome: $categoriaNome, fornecedorId: $fornecedorId, fornecedorNomeSistema: $fornecedorNomeSistema, fornecedorNome: $fornecedorNome, precoVendaVarejoF: $precoVendaVarejoF, precoVendaAtacadoF: $precoVendaAtacadoF, precoVendaPromocionalF: $precoVendaPromocionalF, jsonImagens: $jsonImagens, imagemPrincipal: $imagemPrincipal, hoje: $hoje, tributacaoNome: $tributacaoNome, precoCustoFinal: $precoCustoFinal, temVariacaoUnica: $temVariacaoUnica, idVariacaoUnica: $idVariacaoUnica, unidadeSigla: $unidadeSigla, primeiroEanSistema: $primeiroEanSistema, variacoes: $variacoes)';
  }

  @override
  bool operator ==(covariant Produto other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.dataCadastro == dataCadastro &&
        other.dataAlteracao == dataAlteracao &&
        other.nome == nome &&
        other.ativo == ativo &&
        other.idCategoria == idCategoria &&
        other.idFornecedor == idFornecedor &&
        other.idMenorUnidade == idMenorUnidade &&
        other.idMaiorUnidade == idMaiorUnidade &&
        other.fatorConversaoUnidade == fatorConversaoUnidade &&
        other.estoqueMinimo == estoqueMinimo &&
        other.ncm == ncm &&
        other.cest == cest &&
        other.idTributacao == idTributacao &&
        other.precoCusto == precoCusto &&
        other.pCustoIpi == pCustoIpi &&
        other.pCustoST == pCustoST &&
        other.pCustoFrete == pCustoFrete &&
        other.observacoes == observacoes &&
        other.altura == altura &&
        other.largura == largura &&
        other.profundidade == profundidade &&
        other.peso == peso &&
        other.descricaoDetalhada == descricaoDetalhada &&
        other.precoVendaVarejo == precoVendaVarejo &&
        other.precoVendaAtacado == precoVendaAtacado &&
        other.precoVendaPromocional == precoVendaPromocional &&
        other.categoriaId == categoriaId &&
        other.categoriaNome == categoriaNome &&
        other.fornecedorId == fornecedorId &&
        other.fornecedorNomeSistema == fornecedorNomeSistema &&
        other.fornecedorNome == fornecedorNome &&
        other.precoVendaVarejoF == precoVendaVarejoF &&
        other.precoVendaAtacadoF == precoVendaAtacadoF &&
        other.precoVendaPromocionalF == precoVendaPromocionalF &&
        other.jsonImagens == jsonImagens &&
        other.imagemPrincipal == imagemPrincipal &&
        other.hoje == hoje &&
        other.tributacaoNome == tributacaoNome &&
        other.precoCustoFinal == precoCustoFinal &&
        other.temVariacaoUnica == temVariacaoUnica &&
        other.idVariacaoUnica == idVariacaoUnica &&
        other.unidadeSigla == unidadeSigla &&
        other.primeiroEanSistema == primeiroEanSistema &&
        other.variacoes == variacoes;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        dataCadastro.hashCode ^
        dataAlteracao.hashCode ^
        nome.hashCode ^
        ativo.hashCode ^
        idCategoria.hashCode ^
        idFornecedor.hashCode ^
        idMenorUnidade.hashCode ^
        idMaiorUnidade.hashCode ^
        fatorConversaoUnidade.hashCode ^
        estoqueMinimo.hashCode ^
        ncm.hashCode ^
        cest.hashCode ^
        idTributacao.hashCode ^
        precoCusto.hashCode ^
        pCustoIpi.hashCode ^
        pCustoST.hashCode ^
        pCustoFrete.hashCode ^
        observacoes.hashCode ^
        altura.hashCode ^
        largura.hashCode ^
        profundidade.hashCode ^
        peso.hashCode ^
        descricaoDetalhada.hashCode ^
        precoVendaVarejo.hashCode ^
        precoVendaAtacado.hashCode ^
        precoVendaPromocional.hashCode ^
        categoriaId.hashCode ^
        categoriaNome.hashCode ^
        fornecedorId.hashCode ^
        fornecedorNomeSistema.hashCode ^
        fornecedorNome.hashCode ^
        precoVendaVarejoF.hashCode ^
        precoVendaAtacadoF.hashCode ^
        precoVendaPromocionalF.hashCode ^
        jsonImagens.hashCode ^
        imagemPrincipal.hashCode ^
        hoje.hashCode ^
        tributacaoNome.hashCode ^
        precoCustoFinal.hashCode ^
        temVariacaoUnica.hashCode ^
        idVariacaoUnica.hashCode ^
        unidadeSigla.hashCode ^
        primeiroEanSistema.hashCode ^
        variacoes.hashCode;
  }
}
