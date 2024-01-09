// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CadastroUnico {
  String id;
  String dataCadastro;
  String dataAlteracao;
  String cpfCnpj;
  String celular;
  String email;
  String f_1;
  String nome;
  String nomeSistema;
  String f_2;
  String cep;
  String logradouro;
  String numero;
  String complemento;
  String bairro;
  String municipio;
  String codigoMunicipio;
  String uf;
  String ie;
  String pontoReferencia;
  String fixo;
  String observacoes;
  String cpfCnpjF;
  String diaNascimento;
  String mesNascimento;
  String anoNascimento;
  CadastroUnico({
    required this.id,
    required this.dataCadastro,
    required this.dataAlteracao,
    required this.cpfCnpj,
    required this.celular,
    required this.email,
    required this.f_1,
    required this.nome,
    required this.nomeSistema,
    required this.f_2,
    required this.cep,
    required this.logradouro,
    required this.numero,
    required this.complemento,
    required this.bairro,
    required this.municipio,
    required this.codigoMunicipio,
    required this.uf,
    required this.ie,
    required this.pontoReferencia,
    required this.fixo,
    required this.observacoes,
    required this.cpfCnpjF,
    required this.diaNascimento,
    required this.mesNascimento,
    required this.anoNascimento,
  });

  CadastroUnico copyWith({
    String? id,
    String? dataCadastro,
    String? dataAlteracao,
    String? cpfCnpj,
    String? celular,
    String? email,
    String? f_1,
    String? nome,
    String? nomeSistema,
    String? f_2,
    String? cep,
    String? logradouro,
    String? numero,
    String? complemento,
    String? bairro,
    String? municipio,
    String? codigoMunicipio,
    String? uf,
    String? ie,
    String? pontoReferencia,
    String? fixo,
    String? observacoes,
    String? cpfCnpjF,
    String? diaNascimento,
    String? mesNascimento,
    String? anoNascimento,
  }) {
    return CadastroUnico(
      id: id ?? this.id,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      dataAlteracao: dataAlteracao ?? this.dataAlteracao,
      cpfCnpj: cpfCnpj ?? this.cpfCnpj,
      celular: celular ?? this.celular,
      email: email ?? this.email,
      f_1: f_1 ?? this.f_1,
      nome: nome ?? this.nome,
      nomeSistema: nomeSistema ?? this.nomeSistema,
      f_2: f_2 ?? this.f_2,
      cep: cep ?? this.cep,
      logradouro: logradouro ?? this.logradouro,
      numero: numero ?? this.numero,
      complemento: complemento ?? this.complemento,
      bairro: bairro ?? this.bairro,
      municipio: municipio ?? this.municipio,
      codigoMunicipio: codigoMunicipio ?? this.codigoMunicipio,
      uf: uf ?? this.uf,
      ie: ie ?? this.ie,
      pontoReferencia: pontoReferencia ?? this.pontoReferencia,
      fixo: fixo ?? this.fixo,
      observacoes: observacoes ?? this.observacoes,
      cpfCnpjF: cpfCnpjF ?? this.cpfCnpjF,
      diaNascimento: diaNascimento ?? this.diaNascimento,
      mesNascimento: mesNascimento ?? this.mesNascimento,
      anoNascimento: anoNascimento ?? this.anoNascimento,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'dataCadastro': dataCadastro,
      'dataAlteracao': dataAlteracao,
      'cpfCnpj': cpfCnpj,
      'celular': celular,
      'email': email,
      'f_1': f_1,
      'nome': nome,
      'nomeSistema': nomeSistema,
      'f_2': f_2,
      'cep': cep,
      'logradouro': logradouro,
      'numero': numero,
      'complemento': complemento,
      'bairro': bairro,
      'municipio': municipio,
      'codigoMunicipio': codigoMunicipio,
      'uf': uf,
      'ie': ie,
      'pontoReferencia': pontoReferencia,
      'fixo': fixo,
      'observacoes': observacoes,
      'cpfCnpjF': cpfCnpjF,
      'diaNascimento': diaNascimento,
      'mesNascimento': mesNascimento,
      'anoNascimento': anoNascimento,
    };
  }

  factory CadastroUnico.fromMap(Map<String, dynamic> map) {
    return CadastroUnico(
      id: map['id'] as String,
      dataCadastro: map['dataCadastro'] as String,
      dataAlteracao: map['dataAlteracao'] as String,
      cpfCnpj: map['cpfCnpj'] as String,
      celular: map['celular'] as String,
      email: map['email'] as String,
      f_1: map['f_1'] as String,
      nome: map['nome'] as String,
      nomeSistema: map['nomeSistema'] as String,
      f_2: map['f_2'] as String,
      cep: map['cep'] as String,
      logradouro: map['logradouro'] as String,
      numero: map['numero'] as String,
      complemento: map['complemento'] as String,
      bairro: map['bairro'] as String,
      municipio: map['municipio'] as String,
      codigoMunicipio: map['codigoMunicipio'] as String,
      uf: map['uf'] as String,
      ie: map['ie'] as String,
      pontoReferencia: map['pontoReferencia'] as String,
      fixo: map['fixo'] as String,
      observacoes: map['observacoes'] as String,
      cpfCnpjF: map['cpfCnpjF'] as String,
      diaNascimento: map['diaNascimento'] as String,
      mesNascimento: map['mesNascimento'] as String,
      anoNascimento: map['anoNascimento'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CadastroUnico.fromJson(String source) => CadastroUnico.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CadastroUnico(id: $id, dataCadastro: $dataCadastro, dataAlteracao: $dataAlteracao, cpfCnpj: $cpfCnpj, celular: $celular, email: $email, f_1: $f_1, nome: $nome, nomeSistema: $nomeSistema, f_2: $f_2, cep: $cep, logradouro: $logradouro, numero: $numero, complemento: $complemento, bairro: $bairro, municipio: $municipio, codigoMunicipio: $codigoMunicipio, uf: $uf, ie: $ie, pontoReferencia: $pontoReferencia, fixo: $fixo, observacoes: $observacoes, cpfCnpjF: $cpfCnpjF, diaNascimento: $diaNascimento, mesNascimento: $mesNascimento, anoNascimento: $anoNascimento)';
  }

  @override
  bool operator ==(covariant CadastroUnico other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.dataCadastro == dataCadastro &&
        other.dataAlteracao == dataAlteracao &&
        other.cpfCnpj == cpfCnpj &&
        other.celular == celular &&
        other.email == email &&
        other.f_1 == f_1 &&
        other.nome == nome &&
        other.nomeSistema == nomeSistema &&
        other.f_2 == f_2 &&
        other.cep == cep &&
        other.logradouro == logradouro &&
        other.numero == numero &&
        other.complemento == complemento &&
        other.bairro == bairro &&
        other.municipio == municipio &&
        other.codigoMunicipio == codigoMunicipio &&
        other.uf == uf &&
        other.ie == ie &&
        other.pontoReferencia == pontoReferencia &&
        other.fixo == fixo &&
        other.observacoes == observacoes &&
        other.cpfCnpjF == cpfCnpjF &&
        other.diaNascimento == diaNascimento &&
        other.mesNascimento == mesNascimento &&
        other.anoNascimento == anoNascimento;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        dataCadastro.hashCode ^
        dataAlteracao.hashCode ^
        cpfCnpj.hashCode ^
        celular.hashCode ^
        email.hashCode ^
        f_1.hashCode ^
        nome.hashCode ^
        nomeSistema.hashCode ^
        f_2.hashCode ^
        cep.hashCode ^
        logradouro.hashCode ^
        numero.hashCode ^
        complemento.hashCode ^
        bairro.hashCode ^
        municipio.hashCode ^
        codigoMunicipio.hashCode ^
        uf.hashCode ^
        ie.hashCode ^
        pontoReferencia.hashCode ^
        fixo.hashCode ^
        observacoes.hashCode ^
        cpfCnpjF.hashCode ^
        diaNascimento.hashCode ^
        mesNascimento.hashCode ^
        anoNascimento.hashCode;
  }
}
