import 'dart:convert';

class Produto {
  int id;
  String dataCadastro;
  String dataAlteracao;
  String ativo;
  String insumo;
  String nome;
  double custo;
  double preco;
  String jsonRegrasPreco;
  String ncm;
  String cest;
  double estoqueMinimo;
  int idCategoria1;
  int idCategoria2;
  int idMenorUnidade;
  int idMaiorUnidade;
  int fatorConversaoUnidade;
  int altura;
  int largura;
  int profundidade;
  double peso;
  String descricao;
  String descricaoWhatsapp;
  String jsonMedia;
  int idTributacao;
  int idPisCofins;
  Produto({
    required this.id,
    required this.dataCadastro,
    required this.dataAlteracao,
    required this.ativo,
    required this.insumo,
    required this.nome,
    required this.custo,
    required this.preco,
    required this.jsonRegrasPreco,
    required this.ncm,
    required this.cest,
    required this.estoqueMinimo,
    required this.idCategoria1,
    required this.idCategoria2,
    required this.idMenorUnidade,
    required this.idMaiorUnidade,
    required this.fatorConversaoUnidade,
    required this.altura,
    required this.largura,
    required this.profundidade,
    required this.peso,
    required this.descricao,
    required this.descricaoWhatsapp,
    required this.jsonMedia,
    required this.idTributacao,
    required this.idPisCofins,
  });

  Produto copyWith({
    int? id,
    String? dataCadastro,
    String? dataAlteracao,
    String? ativo,
    String? insumo,
    String? nome,
    double? custo,
    double? preco,
    String? jsonRegrasPreco,
    String? ncm,
    String? cest,
    double? estoqueMinimo,
    int? idCategoria1,
    int? idCategoria2,
    int? idMenorUnidade,
    int? idMaiorUnidade,
    int? fatorConversaoUnidade,
    int? altura,
    int? largura,
    int? profundidade,
    double? peso,
    String? descricao,
    String? descricaoWhatsapp,
    String? jsonMedia,
    int? idTributacao,
    int? idPisCofins,
  }) {
    return Produto(
      id: id ?? this.id,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      dataAlteracao: dataAlteracao ?? this.dataAlteracao,
      ativo: ativo ?? this.ativo,
      insumo: insumo ?? this.insumo,
      nome: nome ?? this.nome,
      custo: custo ?? this.custo,
      preco: preco ?? this.preco,
      jsonRegrasPreco: jsonRegrasPreco ?? this.jsonRegrasPreco,
      ncm: ncm ?? this.ncm,
      cest: cest ?? this.cest,
      estoqueMinimo: estoqueMinimo ?? this.estoqueMinimo,
      idCategoria1: idCategoria1 ?? this.idCategoria1,
      idCategoria2: idCategoria2 ?? this.idCategoria2,
      idMenorUnidade: idMenorUnidade ?? this.idMenorUnidade,
      idMaiorUnidade: idMaiorUnidade ?? this.idMaiorUnidade,
      fatorConversaoUnidade: fatorConversaoUnidade ?? this.fatorConversaoUnidade,
      altura: altura ?? this.altura,
      largura: largura ?? this.largura,
      profundidade: profundidade ?? this.profundidade,
      peso: peso ?? this.peso,
      descricao: descricao ?? this.descricao,
      descricaoWhatsapp: descricaoWhatsapp ?? this.descricaoWhatsapp,
      jsonMedia: jsonMedia ?? this.jsonMedia,
      idTributacao: idTributacao ?? this.idTributacao,
      idPisCofins: idPisCofins ?? this.idPisCofins,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'dataCadastro': dataCadastro});
    result.addAll({'dataAlteracao': dataAlteracao});
    result.addAll({'ativo': ativo});
    result.addAll({'insumo': insumo});
    result.addAll({'nome': nome});
    result.addAll({'custo': custo});
    result.addAll({'preco': preco});
    result.addAll({'jsonRegrasPreco': jsonRegrasPreco});
    result.addAll({'ncm': ncm});
    result.addAll({'cest': cest});
    result.addAll({'estoqueMinimo': estoqueMinimo});
    result.addAll({'idCategoria1': idCategoria1});
    result.addAll({'idCategoria2': idCategoria2});
    result.addAll({'idMenorUnidade': idMenorUnidade});
    result.addAll({'idMaiorUnidade': idMaiorUnidade});
    result.addAll({'fatorConversaoUnidade': fatorConversaoUnidade});
    result.addAll({'altura': altura});
    result.addAll({'largura': largura});
    result.addAll({'profundidade': profundidade});
    result.addAll({'peso': peso});
    result.addAll({'descricao': descricao});
    result.addAll({'descricaoWhatsapp': descricaoWhatsapp});
    result.addAll({'jsonMedia': jsonMedia});
    result.addAll({'idTributacao': idTributacao});
    result.addAll({'idPisCofins': idPisCofins});

    return result;
  }

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id']?.toInt() ?? 0,
      dataCadastro: map['dataCadastro'] ?? '',
      dataAlteracao: map['dataAlteracao'] ?? '',
      ativo: map['ativo'] ?? '',
      insumo: map['insumo'] ?? '',
      nome: map['nome'] ?? '',
      custo: map['custo']?.toDouble() ?? 0.0,
      preco: map['preco']?.toDouble() ?? 0.0,
      jsonRegrasPreco: map['jsonRegrasPreco'] ?? '',
      ncm: map['ncm'] ?? '',
      cest: map['cest'] ?? '',
      estoqueMinimo: map['estoqueMinimo']?.toDouble() ?? 0.0,
      idCategoria1: map['idCategoria1']?.toInt() ?? 0,
      idCategoria2: map['idCategoria2']?.toInt() ?? 0,
      idMenorUnidade: map['idMenorUnidade']?.toInt() ?? 0,
      idMaiorUnidade: map['idMaiorUnidade']?.toInt() ?? 0,
      fatorConversaoUnidade: map['fatorConversaoUnidade']?.toInt() ?? 0,
      altura: map['altura']?.toInt() ?? 0,
      largura: map['largura']?.toInt() ?? 0,
      profundidade: map['profundidade']?.toInt() ?? 0,
      peso: map['peso']?.toDouble() ?? 0.0,
      descricao: map['descricao'] ?? '',
      descricaoWhatsapp: map['descricaoWhatsapp'] ?? '',
      jsonMedia: map['jsonMedia'] ?? '',
      idTributacao: map['idTributacao']?.toInt() ?? 0,
      idPisCofins: map['idPisCofins']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Produto.fromJson(String source) => Produto.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Produto(id: $id, dataCadastro: $dataCadastro, dataAlteracao: $dataAlteracao, ativo: $ativo, insumo: $insumo, nome: $nome, custo: $custo, preco: $preco, jsonRegrasPreco: $jsonRegrasPreco, ncm: $ncm, cest: $cest, estoqueMinimo: $estoqueMinimo, idCategoria1: $idCategoria1, idCategoria2: $idCategoria2, idMenorUnidade: $idMenorUnidade, idMaiorUnidade: $idMaiorUnidade, fatorConversaoUnidade: $fatorConversaoUnidade, altura: $altura, largura: $largura, profundidade: $profundidade, peso: $peso, descricao: $descricao, descricaoWhatsapp: $descricaoWhatsapp, jsonMedia: $jsonMedia, idTributacao: $idTributacao, idPisCofins: $idPisCofins)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Produto &&
        other.id == id &&
        other.dataCadastro == dataCadastro &&
        other.dataAlteracao == dataAlteracao &&
        other.ativo == ativo &&
        other.insumo == insumo &&
        other.nome == nome &&
        other.custo == custo &&
        other.preco == preco &&
        other.jsonRegrasPreco == jsonRegrasPreco &&
        other.ncm == ncm &&
        other.cest == cest &&
        other.estoqueMinimo == estoqueMinimo &&
        other.idCategoria1 == idCategoria1 &&
        other.idCategoria2 == idCategoria2 &&
        other.idMenorUnidade == idMenorUnidade &&
        other.idMaiorUnidade == idMaiorUnidade &&
        other.fatorConversaoUnidade == fatorConversaoUnidade &&
        other.altura == altura &&
        other.largura == largura &&
        other.profundidade == profundidade &&
        other.peso == peso &&
        other.descricao == descricao &&
        other.descricaoWhatsapp == descricaoWhatsapp &&
        other.jsonMedia == jsonMedia &&
        other.idTributacao == idTributacao &&
        other.idPisCofins == idPisCofins;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        dataCadastro.hashCode ^
        dataAlteracao.hashCode ^
        ativo.hashCode ^
        insumo.hashCode ^
        nome.hashCode ^
        custo.hashCode ^
        preco.hashCode ^
        jsonRegrasPreco.hashCode ^
        ncm.hashCode ^
        cest.hashCode ^
        estoqueMinimo.hashCode ^
        idCategoria1.hashCode ^
        idCategoria2.hashCode ^
        idMenorUnidade.hashCode ^
        idMaiorUnidade.hashCode ^
        fatorConversaoUnidade.hashCode ^
        altura.hashCode ^
        largura.hashCode ^
        profundidade.hashCode ^
        peso.hashCode ^
        descricao.hashCode ^
        descricaoWhatsapp.hashCode ^
        jsonMedia.hashCode ^
        idTributacao.hashCode ^
        idPisCofins.hashCode;
  }
}
