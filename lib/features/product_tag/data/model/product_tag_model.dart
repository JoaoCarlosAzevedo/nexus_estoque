import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProductTagModel {
  String zpl;
  String urlPreview;
  ProductTagModel({
    required this.zpl,
    required this.urlPreview,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'etiqueta': zpl,
      'preview': urlPreview,
    };
  }

  factory ProductTagModel.fromMap(Map<String, dynamic> map) {
    return ProductTagModel(
      zpl: map['etiqueta'] as String,
      urlPreview: map['preview'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductTagModel.fromJson(String source) =>
      ProductTagModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
