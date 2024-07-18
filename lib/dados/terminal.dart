import 'dart:convert';

class Terminal {
  final int id;
  final String dataCadastro;
  final String dataAlteracao;
  final int idLojaFisica;
  final String terminal;
  final String statusTerminal;
  final String pinTerminal;
  final String hostTerminal;
  final int idEmpresa;
  final String opcaoTerminalImpressao;
  final String observacoes;
  Terminal({
    required this.id,
    required this.dataCadastro,
    required this.dataAlteracao,
    required this.idLojaFisica,
    required this.terminal,
    required this.statusTerminal,
    required this.pinTerminal,
    required this.hostTerminal,
    required this.idEmpresa,
    required this.opcaoTerminalImpressao,
    required this.observacoes,
  });

  Terminal copyWith({
    int? id,
    String? dataCadastro,
    String? dataAlteracao,
    int? idLojaFisica,
    String? terminal,
    String? statusTerminal,
    String? pinTerminal,
    String? hostTerminal,
    int? idEmpresa,
    String? opcaoTerminalImpressao,
    String? observacoes,
  }) {
    return Terminal(
      id: id ?? this.id,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      dataAlteracao: dataAlteracao ?? this.dataAlteracao,
      idLojaFisica: idLojaFisica ?? this.idLojaFisica,
      terminal: terminal ?? this.terminal,
      statusTerminal: statusTerminal ?? this.statusTerminal,
      pinTerminal: pinTerminal ?? this.pinTerminal,
      hostTerminal: hostTerminal ?? this.hostTerminal,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      opcaoTerminalImpressao: opcaoTerminalImpressao ?? this.opcaoTerminalImpressao,
      observacoes: observacoes ?? this.observacoes,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'dataCadastro': dataCadastro});
    result.addAll({'dataAlteracao': dataAlteracao});
    result.addAll({'idLojaFisica': idLojaFisica});
    result.addAll({'terminal': terminal});
    result.addAll({'statusTerminal': statusTerminal});
    result.addAll({'pinTerminal': pinTerminal});
    result.addAll({'hostTerminal': hostTerminal});
    result.addAll({'idEmpresa': idEmpresa});
    result.addAll({'opcaoTerminalImpressao': opcaoTerminalImpressao});
    result.addAll({'observacoes': observacoes});

    return result;
  }

  factory Terminal.fromMap(Map<String, dynamic> map) {
    return Terminal(
      id: map['id']?.toInt() ?? 0,
      dataCadastro: map['dataCadastro'] ?? '',
      dataAlteracao: map['dataAlteracao'] ?? '',
      idLojaFisica: map['idLojaFisica']?.toInt() ?? 0,
      terminal: map['terminal'] ?? '',
      statusTerminal: map['statusTerminal'] ?? '',
      pinTerminal: map['pinTerminal'] ?? '',
      hostTerminal: map['hostTerminal'] ?? '',
      idEmpresa: map['idEmpresa']?.toInt() ?? 0,
      opcaoTerminalImpressao: map['opcaoTerminalImpressao'] ?? '',
      observacoes: map['observacoes'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Terminal.fromJson(String source) => Terminal.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Terminal(id: $id, dataCadastro: $dataCadastro, dataAlteracao: $dataAlteracao, idLojaFisica: $idLojaFisica, terminal: $terminal, statusTerminal: $statusTerminal, pinTerminal: $pinTerminal, hostTerminal: $hostTerminal, idEmpresa: $idEmpresa, opcaoTerminalImpressao: $opcaoTerminalImpressao, observacoes: $observacoes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Terminal &&
        other.id == id &&
        other.dataCadastro == dataCadastro &&
        other.dataAlteracao == dataAlteracao &&
        other.idLojaFisica == idLojaFisica &&
        other.terminal == terminal &&
        other.statusTerminal == statusTerminal &&
        other.pinTerminal == pinTerminal &&
        other.hostTerminal == hostTerminal &&
        other.idEmpresa == idEmpresa &&
        other.opcaoTerminalImpressao == opcaoTerminalImpressao &&
        other.observacoes == observacoes;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        dataCadastro.hashCode ^
        dataAlteracao.hashCode ^
        idLojaFisica.hashCode ^
        terminal.hashCode ^
        statusTerminal.hashCode ^
        pinTerminal.hashCode ^
        hostTerminal.hashCode ^
        idEmpresa.hashCode ^
        opcaoTerminalImpressao.hashCode ^
        observacoes.hashCode;
  }
}
