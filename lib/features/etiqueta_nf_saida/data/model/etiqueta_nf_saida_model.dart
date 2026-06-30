import 'dart:convert';

class EtiquetaNfSaida {
  final String notaFiscal;
  final int volumes;
  final String cliente;
  final String endereco;
  final String bairro;
  final String municipio;
  final String est;
  final String data;
  final String hora;
  final String transportadora;
  final String pedido;
  final List<EtiquetaItem> etiquetas;

  const EtiquetaNfSaida({
    required this.notaFiscal,
    required this.volumes,
    required this.cliente,
    required this.endereco,
    required this.bairro,
    required this.municipio,
    required this.est,
    required this.data,
    required this.hora,
    required this.transportadora,
    required this.pedido,
    required this.etiquetas,
  });

  Map<String, dynamic> toMap() {
    return {
      'notaFiscal': notaFiscal,
      'volumes': volumes,
      'cliente': cliente,
      'endereco': endereco,
      'bairro': bairro,
      'municipio': municipio,
      'est': est,
      'data': data,
      'hora': hora,
      'transportadora': transportadora,
      'pedido': pedido,
      'etiquetas': etiquetas.map((e) => e.toMap()).toList(),
    };
  }

  factory EtiquetaNfSaida.fromMap(Map<String, dynamic> map) {
    return EtiquetaNfSaida(
      notaFiscal: map['notaFiscal']?.toString() ?? '',
      volumes: (map['volumes'] as num?)?.toInt() ?? 0,
      cliente: map['cliente']?.toString() ?? '',
      endereco: map['endereco']?.toString() ?? '',
      bairro: map['bairro']?.toString() ?? '',
      municipio: map['municipio']?.toString() ?? '',
      est: map['est']?.toString() ?? '',
      data: map['data']?.toString() ?? '',
      hora: map['hora']?.toString() ?? '',
      transportadora: map['transportadora']?.toString() ?? '',
      pedido: map['pedido']?.toString() ?? '',
      etiquetas: (map['etiquetas'] as List?)
              ?.map((e) => EtiquetaItem.fromMap(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  String toJson() => json.encode(toMap());

  factory EtiquetaNfSaida.fromJson(String source) =>
      EtiquetaNfSaida.fromMap(json.decode(source) as Map<String, dynamic>);
}

class EtiquetaItem {
  final int volume;
  final String etiqueta;

  const EtiquetaItem({
    required this.volume,
    required this.etiqueta,
  });

  Map<String, dynamic> toMap() {
    return {
      'volume': volume,
      'etiqueta': etiqueta,
    };
  }

  factory EtiquetaItem.fromMap(Map<String, dynamic> map) {
    return EtiquetaItem(
      volume: (map['volume'] as num?)?.toInt() ?? 0,
      etiqueta: map['etiqueta']?.toString() ?? '',
    );
  }
}
