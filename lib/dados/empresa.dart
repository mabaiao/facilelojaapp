import 'dart:convert';

class Empresa {
  String id;
  String dataCadastro;
  String dataAlteracao;
  String cpfCnpj;
  String nomeSistema;
  String nome;
  String iE;
  String cep;
  String uF;
  String codigoMunicipio;
  String municipio;
  String bairro;
  String logradouro;
  String numero;
  String complemento;
  String pontoReferencia;
  String telefone;
  String celular;
  Empresa({
    required this.id,
    required this.dataCadastro,
    required this.dataAlteracao,
    required this.cpfCnpj,
    required this.nomeSistema,
    required this.nome,
    required this.iE,
    required this.cep,
    required this.uF,
    required this.codigoMunicipio,
    required this.municipio,
    required this.bairro,
    required this.logradouro,
    required this.numero,
    required this.complemento,
    required this.pontoReferencia,
    required this.telefone,
    required this.celular,
  });

  Empresa copyWith({
    String? id,
    String? dataCadastro,
    String? dataAlteracao,
    String? cpfCnpj,
    String? nomeSistema,
    String? nome,
    String? iE,
    String? cep,
    String? uF,
    String? codigoMunicipio,
    String? municipio,
    String? bairro,
    String? logradouro,
    String? numero,
    String? complemento,
    String? pontoReferencia,
    String? telefone,
    String? celular,
  }) {
    return Empresa(
      id: id ?? this.id,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      dataAlteracao: dataAlteracao ?? this.dataAlteracao,
      cpfCnpj: cpfCnpj ?? this.cpfCnpj,
      nomeSistema: nomeSistema ?? this.nomeSistema,
      nome: nome ?? this.nome,
      iE: iE ?? this.iE,
      cep: cep ?? this.cep,
      uF: uF ?? this.uF,
      codigoMunicipio: codigoMunicipio ?? this.codigoMunicipio,
      municipio: municipio ?? this.municipio,
      bairro: bairro ?? this.bairro,
      logradouro: logradouro ?? this.logradouro,
      numero: numero ?? this.numero,
      complemento: complemento ?? this.complemento,
      pontoReferencia: pontoReferencia ?? this.pontoReferencia,
      telefone: telefone ?? this.telefone,
      celular: celular ?? this.celular,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'dataCadastro': dataCadastro,
      'dataAlteracao': dataAlteracao,
      'cpfCnpj': cpfCnpj,
      'nomeSistema': nomeSistema,
      'nome': nome,
      'iE': iE,
      'cep': cep,
      'uF': uF,
      'codigoMunicipio': codigoMunicipio,
      'municipio': municipio,
      'bairro': bairro,
      'logradouro': logradouro,
      'numero': numero,
      'complemento': complemento,
      'pontoReferencia': pontoReferencia,
      'telefone': telefone,
      'celular': celular,
    };
  }

  factory Empresa.fromMap(Map<String, dynamic> map) {
    return Empresa(
      id: map['id'] as String,
      dataCadastro: map['dataCadastro'] as String,
      dataAlteracao: map['dataAlteracao'] as String,
      cpfCnpj: map['cpfCnpj'] as String,
      nomeSistema: map['nomeSistema'] as String,
      nome: map['nome'] as String,
      iE: map['iE'] as String,
      cep: map['cep'] as String,
      uF: map['uF'] as String,
      codigoMunicipio: map['codigoMunicipio'] as String,
      municipio: map['municipio'] as String,
      bairro: map['bairro'] as String,
      logradouro: map['logradouro'] as String,
      numero: map['numero'] as String,
      complemento: map['complemento'] as String,
      pontoReferencia: map['pontoReferencia'] as String,
      telefone: map['telefone'] as String,
      celular: map['celular'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Empresa.fromJson(String source) => Empresa.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Empresa(id: $id, dataCadastro: $dataCadastro, dataAlteracao: $dataAlteracao, cpfCnpj: $cpfCnpj, nomeSistema: $nomeSistema, nome: $nome, iE: $iE, cep: $cep, uF: $uF, codigoMunicipio: $codigoMunicipio, municipio: $municipio, bairro: $bairro, logradouro: $logradouro, numero: $numero, complemento: $complemento, pontoReferencia: $pontoReferencia, telefone: $telefone, celular: $celular)';
  }

  @override
  bool operator ==(covariant Empresa other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.dataCadastro == dataCadastro &&
        other.dataAlteracao == dataAlteracao &&
        other.cpfCnpj == cpfCnpj &&
        other.nomeSistema == nomeSistema &&
        other.nome == nome &&
        other.iE == iE &&
        other.cep == cep &&
        other.uF == uF &&
        other.codigoMunicipio == codigoMunicipio &&
        other.municipio == municipio &&
        other.bairro == bairro &&
        other.logradouro == logradouro &&
        other.numero == numero &&
        other.complemento == complemento &&
        other.pontoReferencia == pontoReferencia &&
        other.telefone == telefone &&
        other.celular == celular;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        dataCadastro.hashCode ^
        dataAlteracao.hashCode ^
        cpfCnpj.hashCode ^
        nomeSistema.hashCode ^
        nome.hashCode ^
        iE.hashCode ^
        cep.hashCode ^
        uF.hashCode ^
        codigoMunicipio.hashCode ^
        municipio.hashCode ^
        bairro.hashCode ^
        logradouro.hashCode ^
        numero.hashCode ^
        complemento.hashCode ^
        pontoReferencia.hashCode ^
        telefone.hashCode ^
        celular.hashCode;
  }
}
