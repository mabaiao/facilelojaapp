import 'dart:convert';

class Funcionario {
  String id;
  String dataCadastro;
  String dataAlteracao;
  String status;
  String idCargo;
  String nomeCargo;
  String nome;
  String senha;
  String email;
  String celular;
  String jsonPermissoes;
  String imagem;
  String eanAutorizacao;
  Funcionario({
    required this.id,
    required this.dataCadastro,
    required this.dataAlteracao,
    required this.status,
    required this.idCargo,
    required this.nomeCargo,
    required this.nome,
    required this.senha,
    required this.email,
    required this.celular,
    required this.jsonPermissoes,
    required this.imagem,
    required this.eanAutorizacao,
  });

  Funcionario copyWith({
    String? id,
    String? dataCadastro,
    String? dataAlteracao,
    String? status,
    String? idCargo,
    String? nomeCargo,
    String? nome,
    String? senha,
    String? email,
    String? celular,
    String? jsonPermissoes,
    String? imagem,
    String? eanAutorizacao,
  }) {
    return Funcionario(
      id: id ?? this.id,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      dataAlteracao: dataAlteracao ?? this.dataAlteracao,
      status: status ?? this.status,
      idCargo: idCargo ?? this.idCargo,
      nomeCargo: nomeCargo ?? this.nomeCargo,
      nome: nome ?? this.nome,
      senha: senha ?? this.senha,
      email: email ?? this.email,
      celular: celular ?? this.celular,
      jsonPermissoes: jsonPermissoes ?? this.jsonPermissoes,
      imagem: imagem ?? this.imagem,
      eanAutorizacao: eanAutorizacao ?? this.eanAutorizacao,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'dataCadastro': dataCadastro,
      'dataAlteracao': dataAlteracao,
      'status': status,
      'idCargo': idCargo,
      'nomeCargo': nomeCargo,
      'nome': nome,
      'senha': senha,
      'email': email,
      'celular': celular,
      'jsonPermissoes': jsonPermissoes,
      'imagem': imagem,
      'eanAutorizacao': eanAutorizacao,
    };
  }

  factory Funcionario.fromMap(Map<String, dynamic> map) {
    return Funcionario(
      id: map['id'] as String,
      dataCadastro: map['dataCadastro'] as String,
      dataAlteracao: map['dataAlteracao'] as String,
      status: map['status'] as String,
      idCargo: map['idCargo'] as String,
      nomeCargo: map['nomeCargo'] as String,
      nome: map['nome'] as String,
      senha: map['senha'] as String,
      email: map['email'] as String,
      celular: map['celular'] as String,
      jsonPermissoes: map['jsonPermissoes'] as String,
      imagem: map['imagem'] as String,
      eanAutorizacao: map['eanAutorizacao'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Funcionario.fromJson(String source) => Funcionario.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Funcionario(id: $id, dataCadastro: $dataCadastro, dataAlteracao: $dataAlteracao, status: $status, idCargo: $idCargo, nomeCargo: $nomeCargo, nome: $nome, senha: $senha, email: $email, celular: $celular, jsonPermissoes: $jsonPermissoes, imagem: $imagem, eanAutorizacao: $eanAutorizacao)';
  }

  @override
  bool operator ==(covariant Funcionario other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.dataCadastro == dataCadastro &&
        other.dataAlteracao == dataAlteracao &&
        other.status == status &&
        other.idCargo == idCargo &&
        other.nomeCargo == nomeCargo &&
        other.nome == nome &&
        other.senha == senha &&
        other.email == email &&
        other.celular == celular &&
        other.jsonPermissoes == jsonPermissoes &&
        other.imagem == imagem &&
        other.eanAutorizacao == eanAutorizacao;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        dataCadastro.hashCode ^
        dataAlteracao.hashCode ^
        status.hashCode ^
        idCargo.hashCode ^
        nomeCargo.hashCode ^
        nome.hashCode ^
        senha.hashCode ^
        email.hashCode ^
        celular.hashCode ^
        jsonPermissoes.hashCode ^
        imagem.hashCode ^
        eanAutorizacao.hashCode;
  }
}
