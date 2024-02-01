// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TerminalImpressao {
  String id;
  String nome;
  String nomeSistema;
  String hostTerminal;
  TerminalImpressao({
    required this.id,
    required this.nome,
    required this.nomeSistema,
    required this.hostTerminal,
  });

  TerminalImpressao copyWith({
    String? id,
    String? nome,
    String? nomeSistema,
    String? hostTerminal,
  }) {
    return TerminalImpressao(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      nomeSistema: nomeSistema ?? this.nomeSistema,
      hostTerminal: hostTerminal ?? this.hostTerminal,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'nomeSistema': nomeSistema,
      'hostTerminal': hostTerminal,
    };
  }

  factory TerminalImpressao.fromMap(Map<String, dynamic> map) {
    return TerminalImpressao(
      id: map['id'] as String,
      nome: map['nome'] as String,
      nomeSistema: map['nomeSistema'] as String,
      hostTerminal: map['hostTerminal'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TerminalImpressao.fromJson(String source) => TerminalImpressao.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TerminalImpressao(id: $id, nome: $nome, nomeSistema: $nomeSistema, hostTerminal: $hostTerminal)';
  }

  @override
  bool operator ==(covariant TerminalImpressao other) {
    if (identical(this, other)) return true;

    return other.id == id && other.nome == nome && other.nomeSistema == nomeSistema && other.hostTerminal == hostTerminal;
  }

  @override
  int get hashCode {
    return id.hashCode ^ nome.hashCode ^ nomeSistema.hashCode ^ hostTerminal.hashCode;
  }
}
