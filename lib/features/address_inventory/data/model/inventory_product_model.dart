import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class InventoryProductModel {
  final String codigo;
  final String doc;
  final double quant;
  final String local;
  final String localizacao;
  final String error;

  InventoryProductModel({
    required this.codigo,
    required this.doc,
    required this.quant,
    required this.local,
    required this.localizacao,
    required this.error,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'codigo': codigo,
      'doc': doc,
      'quant': quant,
      'local': local,
      'localizacao': localizacao,
      'error': error,
    };
  }

  factory InventoryProductModel.fromMap(Map<String, dynamic> map) {
    return InventoryProductModel(
      codigo: map['codigo'] ?? '',
      doc: map['doc'] ?? '',
      quant: map['saldo']?.toDouble() ?? 0.0,
      local: map['local'] ?? '',
      localizacao: map['localizacao'] ?? '',
      error: map['error'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory InventoryProductModel.fromJson(String source) =>
      InventoryProductModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

/* 
"codigo": "45297809",
"doc": "20230920-1",
"quant": 6,
"local": "01",
"localizacao": "8263448",
"error": "AJUDA:MA270NSB2 \r\nEste código não está cadastrado no ar-  quivo de saldos em estoque.\r\nTabela SB7 20/09/23 22:35:36"
 */