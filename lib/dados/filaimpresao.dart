// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FilaImpressao {
  String id;
  String dataCadastro;
  String idTerminal;
  String status;
  String tipoArquivo;
  String impressora;
  String file;
  FilaImpressao({
    required this.id,
    required this.dataCadastro,
    required this.idTerminal,
    required this.status,
    required this.tipoArquivo,
    required this.impressora,
    required this.file,
  });

  FilaImpressao copyWith({
    String? id,
    String? dataCadastro,
    String? idTerminal,
    String? status,
    String? tipoArquivo,
    String? impressora,
    String? file,
  }) {
    return FilaImpressao(
      id: id ?? this.id,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      idTerminal: idTerminal ?? this.idTerminal,
      status: status ?? this.status,
      tipoArquivo: tipoArquivo ?? this.tipoArquivo,
      impressora: impressora ?? this.impressora,
      file: file ?? this.file,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'dataCadastro': dataCadastro,
      'idTerminal': idTerminal,
      'status': status,
      'tipoArquivo': tipoArquivo,
      'impressora': impressora,
      'file': file,
    };
  }

  factory FilaImpressao.fromMap(Map<String, dynamic> map) {
    return FilaImpressao(
      id: map['id'] as String,
      dataCadastro: map['dataCadastro'] as String,
      idTerminal: map['idTerminal'] as String,
      status: map['status'] as String,
      tipoArquivo: map['tipoArquivo'] as String,
      impressora: map['impressora'] as String,
      file: map['file'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FilaImpressao.fromJson(String source) => FilaImpressao.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FilaImpressao(id: $id, dataCadastro: $dataCadastro, idTerminal: $idTerminal, status: $status, tipoArquivo: $tipoArquivo, impressora: $impressora, file: $file)';
  }

  @override
  bool operator ==(covariant FilaImpressao other) {
    if (identical(this, other)) return true;

    return other.id == id && other.dataCadastro == dataCadastro && other.idTerminal == idTerminal && other.status == status && other.tipoArquivo == tipoArquivo && other.impressora == impressora && other.file == file;
  }

  @override
  int get hashCode {
    return id.hashCode ^ dataCadastro.hashCode ^ idTerminal.hashCode ^ status.hashCode ^ tipoArquivo.hashCode ^ impressora.hashCode ^ file.hashCode;
  }
}
