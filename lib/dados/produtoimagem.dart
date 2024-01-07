// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProdutoImagem {
  String id;
  String arquivo;
  String fotoPrincipal;
  int tamanho;
  int largura;
  int altura;
  String url;
  ProdutoImagem({
    required this.id,
    required this.arquivo,
    required this.fotoPrincipal,
    required this.tamanho,
    required this.largura,
    required this.altura,
    required this.url,
  });

  ProdutoImagem copyWith({
    String? id,
    String? arquivo,
    String? fotoPrincipal,
    int? tamanho,
    int? largura,
    int? altura,
    String? url,
  }) {
    return ProdutoImagem(
      id: id ?? this.id,
      arquivo: arquivo ?? this.arquivo,
      fotoPrincipal: fotoPrincipal ?? this.fotoPrincipal,
      tamanho: tamanho ?? this.tamanho,
      largura: largura ?? this.largura,
      altura: altura ?? this.altura,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'arquivo': arquivo,
      'fotoPrincipal': fotoPrincipal,
      'tamanho': tamanho,
      'largura': largura,
      'altura': altura,
      'url': url,
    };
  }

  factory ProdutoImagem.fromMap(Map<String, dynamic> map) {
    return ProdutoImagem(
      id: map['id'] as String,
      arquivo: map['arquivo'] as String,
      fotoPrincipal: map['fotoPrincipal'] as String,
      tamanho: map['tamanho'] as int,
      largura: map['largura'] as int,
      altura: map['altura'] as int,
      url: map['url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProdutoImagem.fromJson(String source) => ProdutoImagem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProdutoImagem(id: $id, arquivo: $arquivo, fotoPrincipal: $fotoPrincipal, tamanho: $tamanho, largura: $largura, altura: $altura, url: $url)';
  }

  @override
  bool operator ==(covariant ProdutoImagem other) {
    if (identical(this, other)) return true;

    return other.id == id && other.arquivo == arquivo && other.fotoPrincipal == fotoPrincipal && other.tamanho == tamanho && other.largura == largura && other.altura == altura && other.url == url;
  }

  @override
  int get hashCode {
    return id.hashCode ^ arquivo.hashCode ^ fotoPrincipal.hashCode ^ tamanho.hashCode ^ largura.hashCode ^ altura.hashCode ^ url.hashCode;
  }
}
