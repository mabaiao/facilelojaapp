import 'dart:convert';

class LojaFisica {
  final int id;
  final String dataCadastro;
  final String dataAlteracao;
  final String nomeSistema;
  final String nome;
  final String opcaoAtiva;
  final String logo;
  final String opcaoImprimirLogo;
  final String celular;
  final String opcaoImprimirCelular;
  final String fixo;
  final String opcaoImprimirFixo;
  final int tamanhoFonteTitulo;
  final int tamanhoFonteSubTitulo;
  final int tamanhoFonteProduto;
  final int tamanhoFonteProdutoValores;
  final int tamanhoFonteTotaisTroco;
  final int tamanhoFonteDemaisTextos;
  final int tamanhoPapel;
  final int espacamentoLinhas;
  final String textoAdicionalContato;
  final String textoAdicionalRodape;
  final String opcaoImprimirTributos;
  final String observacoes;
  LojaFisica({
    required this.id,
    required this.dataCadastro,
    required this.dataAlteracao,
    required this.nomeSistema,
    required this.nome,
    required this.opcaoAtiva,
    required this.logo,
    required this.opcaoImprimirLogo,
    required this.celular,
    required this.opcaoImprimirCelular,
    required this.fixo,
    required this.opcaoImprimirFixo,
    required this.tamanhoFonteTitulo,
    required this.tamanhoFonteSubTitulo,
    required this.tamanhoFonteProduto,
    required this.tamanhoFonteProdutoValores,
    required this.tamanhoFonteTotaisTroco,
    required this.tamanhoFonteDemaisTextos,
    required this.tamanhoPapel,
    required this.espacamentoLinhas,
    required this.textoAdicionalContato,
    required this.textoAdicionalRodape,
    required this.opcaoImprimirTributos,
    required this.observacoes,
  });

  LojaFisica copyWith({
    int? id,
    String? dataCadastro,
    String? dataAlteracao,
    String? nomeSistema,
    String? nome,
    String? opcaoAtiva,
    String? logo,
    String? opcaoImprimirLogo,
    String? celular,
    String? opcaoImprimirCelular,
    String? fixo,
    String? opcaoImprimirFixo,
    int? tamanhoFonteTitulo,
    int? tamanhoFonteSubTitulo,
    int? tamanhoFonteProduto,
    int? tamanhoFonteProdutoValores,
    int? tamanhoFonteTotaisTroco,
    int? tamanhoFonteDemaisTextos,
    int? tamanhoPapel,
    int? espacamentoLinhas,
    String? textoAdicionalContato,
    String? textoAdicionalRodape,
    String? opcaoImprimirTributos,
    String? observacoes,
  }) {
    return LojaFisica(
      id: id ?? this.id,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      dataAlteracao: dataAlteracao ?? this.dataAlteracao,
      nomeSistema: nomeSistema ?? this.nomeSistema,
      nome: nome ?? this.nome,
      opcaoAtiva: opcaoAtiva ?? this.opcaoAtiva,
      logo: logo ?? this.logo,
      opcaoImprimirLogo: opcaoImprimirLogo ?? this.opcaoImprimirLogo,
      celular: celular ?? this.celular,
      opcaoImprimirCelular: opcaoImprimirCelular ?? this.opcaoImprimirCelular,
      fixo: fixo ?? this.fixo,
      opcaoImprimirFixo: opcaoImprimirFixo ?? this.opcaoImprimirFixo,
      tamanhoFonteTitulo: tamanhoFonteTitulo ?? this.tamanhoFonteTitulo,
      tamanhoFonteSubTitulo: tamanhoFonteSubTitulo ?? this.tamanhoFonteSubTitulo,
      tamanhoFonteProduto: tamanhoFonteProduto ?? this.tamanhoFonteProduto,
      tamanhoFonteProdutoValores: tamanhoFonteProdutoValores ?? this.tamanhoFonteProdutoValores,
      tamanhoFonteTotaisTroco: tamanhoFonteTotaisTroco ?? this.tamanhoFonteTotaisTroco,
      tamanhoFonteDemaisTextos: tamanhoFonteDemaisTextos ?? this.tamanhoFonteDemaisTextos,
      tamanhoPapel: tamanhoPapel ?? this.tamanhoPapel,
      espacamentoLinhas: espacamentoLinhas ?? this.espacamentoLinhas,
      textoAdicionalContato: textoAdicionalContato ?? this.textoAdicionalContato,
      textoAdicionalRodape: textoAdicionalRodape ?? this.textoAdicionalRodape,
      opcaoImprimirTributos: opcaoImprimirTributos ?? this.opcaoImprimirTributos,
      observacoes: observacoes ?? this.observacoes,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'dataCadastro': dataCadastro});
    result.addAll({'dataAlteracao': dataAlteracao});
    result.addAll({'nomeSistema': nomeSistema});
    result.addAll({'nome': nome});
    result.addAll({'opcaoAtiva': opcaoAtiva});
    result.addAll({'logo': logo});
    result.addAll({'opcaoImprimirLogo': opcaoImprimirLogo});
    result.addAll({'celular': celular});
    result.addAll({'opcaoImprimirCelular': opcaoImprimirCelular});
    result.addAll({'fixo': fixo});
    result.addAll({'opcaoImprimirFixo': opcaoImprimirFixo});
    result.addAll({'tamanhoFonteTitulo': tamanhoFonteTitulo});
    result.addAll({'tamanhoFonteSubTitulo': tamanhoFonteSubTitulo});
    result.addAll({'tamanhoFonteProduto': tamanhoFonteProduto});
    result.addAll({'tamanhoFonteProdutoValores': tamanhoFonteProdutoValores});
    result.addAll({'tamanhoFonteTotaisTroco': tamanhoFonteTotaisTroco});
    result.addAll({'tamanhoFonteDemaisTextos': tamanhoFonteDemaisTextos});
    result.addAll({'tamanhoPapel': tamanhoPapel});
    result.addAll({'espacamentoLinhas': espacamentoLinhas});
    result.addAll({'textoAdicionalContato': textoAdicionalContato});
    result.addAll({'textoAdicionalRodape': textoAdicionalRodape});
    result.addAll({'opcaoImprimirTributos': opcaoImprimirTributos});
    result.addAll({'observacoes': observacoes});

    return result;
  }

  factory LojaFisica.fromMap(Map<String, dynamic> map) {
    return LojaFisica(
      id: map['id']?.toInt() ?? 0,
      dataCadastro: map['dataCadastro'] ?? '',
      dataAlteracao: map['dataAlteracao'] ?? '',
      nomeSistema: map['nomeSistema'] ?? '',
      nome: map['nome'] ?? '',
      opcaoAtiva: map['opcaoAtiva'] ?? '',
      logo: map['logo'] ?? '',
      opcaoImprimirLogo: map['opcaoImprimirLogo'] ?? '',
      celular: map['celular'] ?? '',
      opcaoImprimirCelular: map['opcaoImprimirCelular'] ?? '',
      fixo: map['fixo'] ?? '',
      opcaoImprimirFixo: map['opcaoImprimirFixo'] ?? '',
      tamanhoFonteTitulo: map['tamanhoFonteTitulo']?.toInt() ?? 0,
      tamanhoFonteSubTitulo: map['tamanhoFonteSubTitulo']?.toInt() ?? 0,
      tamanhoFonteProduto: map['tamanhoFonteProduto']?.toInt() ?? 0,
      tamanhoFonteProdutoValores: map['tamanhoFonteProdutoValores']?.toInt() ?? 0,
      tamanhoFonteTotaisTroco: map['tamanhoFonteTotaisTroco']?.toInt() ?? 0,
      tamanhoFonteDemaisTextos: map['tamanhoFonteDemaisTextos']?.toInt() ?? 0,
      tamanhoPapel: map['tamanhoPapel']?.toInt() ?? 0,
      espacamentoLinhas: map['espacamentoLinhas']?.toInt() ?? 0,
      textoAdicionalContato: map['textoAdicionalContato'] ?? '',
      textoAdicionalRodape: map['textoAdicionalRodape'] ?? '',
      opcaoImprimirTributos: map['opcaoImprimirTributos'] ?? '',
      observacoes: map['observacoes'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LojaFisica.fromJson(String source) => LojaFisica.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LojaFisica(id: $id, dataCadastro: $dataCadastro, dataAlteracao: $dataAlteracao, nomeSistema: $nomeSistema, nome: $nome, opcaoAtiva: $opcaoAtiva, logo: $logo, opcaoImprimirLogo: $opcaoImprimirLogo, celular: $celular, opcaoImprimirCelular: $opcaoImprimirCelular, fixo: $fixo, opcaoImprimirFixo: $opcaoImprimirFixo, tamanhoFonteTitulo: $tamanhoFonteTitulo, tamanhoFonteSubTitulo: $tamanhoFonteSubTitulo, tamanhoFonteProduto: $tamanhoFonteProduto, tamanhoFonteProdutoValores: $tamanhoFonteProdutoValores, tamanhoFonteTotaisTroco: $tamanhoFonteTotaisTroco, tamanhoFonteDemaisTextos: $tamanhoFonteDemaisTextos, tamanhoPapel: $tamanhoPapel, espacamentoLinhas: $espacamentoLinhas, textoAdicionalContato: $textoAdicionalContato, textoAdicionalRodape: $textoAdicionalRodape, opcaoImprimirTributos: $opcaoImprimirTributos, observacoes: $observacoes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LojaFisica &&
        other.id == id &&
        other.dataCadastro == dataCadastro &&
        other.dataAlteracao == dataAlteracao &&
        other.nomeSistema == nomeSistema &&
        other.nome == nome &&
        other.opcaoAtiva == opcaoAtiva &&
        other.logo == logo &&
        other.opcaoImprimirLogo == opcaoImprimirLogo &&
        other.celular == celular &&
        other.opcaoImprimirCelular == opcaoImprimirCelular &&
        other.fixo == fixo &&
        other.opcaoImprimirFixo == opcaoImprimirFixo &&
        other.tamanhoFonteTitulo == tamanhoFonteTitulo &&
        other.tamanhoFonteSubTitulo == tamanhoFonteSubTitulo &&
        other.tamanhoFonteProduto == tamanhoFonteProduto &&
        other.tamanhoFonteProdutoValores == tamanhoFonteProdutoValores &&
        other.tamanhoFonteTotaisTroco == tamanhoFonteTotaisTroco &&
        other.tamanhoFonteDemaisTextos == tamanhoFonteDemaisTextos &&
        other.tamanhoPapel == tamanhoPapel &&
        other.espacamentoLinhas == espacamentoLinhas &&
        other.textoAdicionalContato == textoAdicionalContato &&
        other.textoAdicionalRodape == textoAdicionalRodape &&
        other.opcaoImprimirTributos == opcaoImprimirTributos &&
        other.observacoes == observacoes;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        dataCadastro.hashCode ^
        dataAlteracao.hashCode ^
        nomeSistema.hashCode ^
        nome.hashCode ^
        opcaoAtiva.hashCode ^
        logo.hashCode ^
        opcaoImprimirLogo.hashCode ^
        celular.hashCode ^
        opcaoImprimirCelular.hashCode ^
        fixo.hashCode ^
        opcaoImprimirFixo.hashCode ^
        tamanhoFonteTitulo.hashCode ^
        tamanhoFonteSubTitulo.hashCode ^
        tamanhoFonteProduto.hashCode ^
        tamanhoFonteProdutoValores.hashCode ^
        tamanhoFonteTotaisTroco.hashCode ^
        tamanhoFonteDemaisTextos.hashCode ^
        tamanhoPapel.hashCode ^
        espacamentoLinhas.hashCode ^
        textoAdicionalContato.hashCode ^
        textoAdicionalRodape.hashCode ^
        opcaoImprimirTributos.hashCode ^
        observacoes.hashCode;
  }
}
