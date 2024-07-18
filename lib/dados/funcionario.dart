import 'dart:convert';

class Funcionario {
  final int id;
  final String dataCadastro;
  final String dataAlteracao;
  final String imagem;
  final String nome;
  final int statusFuncionario;
  final int idCargo;
  final int idLojaFisicaVendedor;
  final String senha;
  final String email;
  final String celular;
  final String codigoEtiqueta;
  final String jsonPermissoes;
  Funcionario({
    required this.id,
    required this.dataCadastro,
    required this.dataAlteracao,
    required this.imagem,
    required this.nome,
    required this.statusFuncionario,
    required this.idCargo,
    required this.idLojaFisicaVendedor,
    required this.senha,
    required this.email,
    required this.celular,
    required this.codigoEtiqueta,
    required this.jsonPermissoes,
  });

  Funcionario copyWith({
    int? id,
    String? dataCadastro,
    String? dataAlteracao,
    String? imagem,
    String? nome,
    int? statusFuncionario,
    int? idCargo,
    int? idLojaFisicaVendedor,
    String? senha,
    String? email,
    String? celular,
    String? codigoEtiqueta,
    String? jsonPermissoes,
  }) {
    return Funcionario(
      id: id ?? this.id,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      dataAlteracao: dataAlteracao ?? this.dataAlteracao,
      imagem: imagem ?? this.imagem,
      nome: nome ?? this.nome,
      statusFuncionario: statusFuncionario ?? this.statusFuncionario,
      idCargo: idCargo ?? this.idCargo,
      idLojaFisicaVendedor: idLojaFisicaVendedor ?? this.idLojaFisicaVendedor,
      senha: senha ?? this.senha,
      email: email ?? this.email,
      celular: celular ?? this.celular,
      codigoEtiqueta: codigoEtiqueta ?? this.codigoEtiqueta,
      jsonPermissoes: jsonPermissoes ?? this.jsonPermissoes,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'dataCadastro': dataCadastro});
    result.addAll({'dataAlteracao': dataAlteracao});
    result.addAll({'imagem': imagem});
    result.addAll({'nome': nome});
    result.addAll({'statusFuncionario': statusFuncionario});
    result.addAll({'idCargo': idCargo});
    result.addAll({'idLojaFisicaVendedor': idLojaFisicaVendedor});
    result.addAll({'senha': senha});
    result.addAll({'email': email});
    result.addAll({'celular': celular});
    result.addAll({'codigoEtiqueta': codigoEtiqueta});
    result.addAll({'jsonPermissoes': jsonPermissoes});

    return result;
  }

  factory Funcionario.fromMap(Map<String, dynamic> map) {
    return Funcionario(
      id: map['id']?.toInt() ?? 0,
      dataCadastro: map['dataCadastro'] ?? '',
      dataAlteracao: map['dataAlteracao'] ?? '',
      imagem: map['imagem'] ?? '',
      nome: map['nome'] ?? '',
      statusFuncionario: map['statusFuncionario']?.toInt() ?? 0,
      idCargo: map['idCargo']?.toInt() ?? 0,
      idLojaFisicaVendedor: map['idLojaFisicaVendedor']?.toInt() ?? 0,
      senha: map['senha'] ?? '',
      email: map['email'] ?? '',
      celular: map['celular'] ?? '',
      codigoEtiqueta: map['codigoEtiqueta'] ?? '',
      jsonPermissoes: map['jsonPermissoes'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Funcionario.fromJson(String source) => Funcionario.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Funcionario(id: $id, dataCadastro: $dataCadastro, dataAlteracao: $dataAlteracao, imagem: $imagem, nome: $nome, statusFuncionario: $statusFuncionario, idCargo: $idCargo, idLojaFisicaVendedor: $idLojaFisicaVendedor, senha: $senha, email: $email, celular: $celular, codigoEtiqueta: $codigoEtiqueta, jsonPermissoes: $jsonPermissoes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Funcionario &&
        other.id == id &&
        other.dataCadastro == dataCadastro &&
        other.dataAlteracao == dataAlteracao &&
        other.imagem == imagem &&
        other.nome == nome &&
        other.statusFuncionario == statusFuncionario &&
        other.idCargo == idCargo &&
        other.idLojaFisicaVendedor == idLojaFisicaVendedor &&
        other.senha == senha &&
        other.email == email &&
        other.celular == celular &&
        other.codigoEtiqueta == codigoEtiqueta &&
        other.jsonPermissoes == jsonPermissoes;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        dataCadastro.hashCode ^
        dataAlteracao.hashCode ^
        imagem.hashCode ^
        nome.hashCode ^
        statusFuncionario.hashCode ^
        idCargo.hashCode ^
        idLojaFisicaVendedor.hashCode ^
        senha.hashCode ^
        email.hashCode ^
        celular.hashCode ^
        codigoEtiqueta.hashCode ^
        jsonPermissoes.hashCode;
  }
}
