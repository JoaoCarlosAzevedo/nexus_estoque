// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProductBalanceModel {
  String descricao;
  String localPadrao;
  String codigoBarras;
  String lote;
  String localizacao;
  String tipo;
  String uM;
  List<Armazem> armazem;
  String codigo;

  int get stock {
    return armazem.fold(0, (sum, element) => sum + element.saldoLocal);
  }

  ProductBalanceModel({
    required this.descricao,
    required this.localPadrao,
    required this.codigoBarras,
    required this.lote,
    required this.localizacao,
    required this.tipo,
    required this.uM,
    required this.armazem,
    required this.codigo,
  });

  factory ProductBalanceModel.fromMap(Map<String, dynamic> map) {
    return ProductBalanceModel(
      descricao: map['Descricao'] ?? '',
      localPadrao: map['LocalPadrao'] ?? '',
      codigoBarras: map['CodigoBarras'] ?? '',
      lote: map['Lote'] ?? '',
      localizacao: map['Localizacao'] ?? '',
      tipo: map['Tipo'] ?? '',
      uM: map['UM'] ?? '',
      armazem:
          List<Armazem>.from(map['armazem']?.map((x) => Armazem.fromMap(x))),
      codigo: map['Codigo'] ?? '',
    );
  }

  factory ProductBalanceModel.fromJson(String source) =>
      ProductBalanceModel.fromMap(json.decode(source));
}

class Armazem {
  List<Enderecos> enderecos;
  List<Lotes> lotes;
  String armz;
  int saldoLocal;

  Armazem({
    required this.enderecos,
    required this.lotes,
    required this.armz,
    required this.saldoLocal,
  });

  factory Armazem.fromMap(Map<String, dynamic> map) {
    return Armazem(
      enderecos: List<Enderecos>.from(
          map['enderecos']?.map((x) => Enderecos.fromMap(x))),
      lotes: List<Lotes>.from(map['lotes']?.map((x) => Lotes.fromMap(x))),
      armz: map['Armz'] ?? '',
      saldoLocal: map['SaldoLocal']?.toInt() ?? 0,
    );
  }

  factory Armazem.fromJson(String source) =>
      Armazem.fromMap(json.decode(source));
}

class Lotes {
  String lote;
  String armz;
  int quantOriginal;
  int saldo;
  Lotes({
    required this.lote,
    required this.armz,
    required this.quantOriginal,
    required this.saldo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lote': lote,
      'armz': armz,
      'quantOriginal': quantOriginal,
      'saldo': saldo,
    };
  }

  factory Lotes.fromMap(Map<String, dynamic> map) {
    return Lotes(
      lote: map['Lote'] as String,
      armz: map['Armz'] as String,
      quantOriginal: map['QuantOriginal'] as int,
      saldo: map['Saldo'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Lotes.fromJson(String source) =>
      Lotes.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Enderecos {
  String descEndereco;
  int quantidade;
  String lote;
  String armz;
  String codLocalizacao;

  Enderecos({
    required this.descEndereco,
    required this.quantidade,
    required this.lote,
    required this.armz,
    required this.codLocalizacao,
  });

  factory Enderecos.fromMap(Map<String, dynamic> map) {
    return Enderecos(
      descEndereco: map['DescEndereco'] ?? '',
      quantidade: map['Quantidade']?.toInt() ?? 0,
      lote: map['Lote'] ?? '',
      armz: map['Armz'] ?? '',
      codLocalizacao: map['CodLocalizacao'] ?? '',
    );
  }

  factory Enderecos.fromJson(String source) =>
      Enderecos.fromMap(json.decode(source));
}
