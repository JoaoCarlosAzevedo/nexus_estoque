// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Pickingv2Model {
  String descricao;
  double separado;
  String codigobarras;
  String codigobarras2;
  double quantidade;
  String lote;
  String codEndereco;
  String descEndereco;
  String pedido;
  String itemPedido;
  String local;
  String origem;
  String um;
  String codigo;
  String chave;
  String codCli;
  String desCli;
  String rua;

  String descEndereco2;
  String rua2;
  String deposito;
  String predio;
  String nivel;
  String apartamento;
  String serial;

  int qtdPar;
  int qtdKit;
  int qtdSerial;
  int qtdMax;

  int recnoSDC;

  double fator;

  String status;

  Pickingv2Model(
      {required this.descricao,
      required this.separado,
      required this.codigobarras,
      required this.codigobarras2,
      required this.quantidade,
      required this.lote,
      required this.codEndereco,
      required this.descEndereco,
      required this.pedido,
      required this.itemPedido,
      required this.local,
      required this.origem,
      required this.um,
      required this.codigo,
      required this.chave,
      required this.codCli,
      required this.desCli,
      required this.descEndereco2,
      required this.rua2,
      required this.deposito,
      required this.predio,
      required this.nivel,
      required this.apartamento,
      required this.status,
      required this.recnoSDC,
      required this.fator,
      required this.serial,
      required this.qtdPar,
      required this.qtdKit,
      required this.qtdSerial,
      required this.qtdMax,
      required this.rua});

  Map<String, dynamic> toMap() {
    return {
      'descricao': descricao,
      'separado': separado,
      'codigobarras': codigobarras,
      'codigobarras2': codigobarras2,
      'quantidade': quantidade,
      'lote': lote,
      'codEndereco': codEndereco,
      'descEndereco': descEndereco,
      'pedido': pedido,
      'itemPedido': itemPedido,
      'local': local,
      'origem': origem,
      'um': um,
      'codigo': codigo,
      'chaveSDC': chave,
      'codCliente': codCli,
      'descCliente': desCli,
      'descEndereco2': descEndereco2,
      'rua2': rua2,
      'deposito': deposito,
      'predio': predio,
      'nivel': nivel,
      'apartamento': apartamento,
      'status': status,
      'fator': fator,
      'recnoSDC': recnoSDC,
      'serial': serial,
      'qtdMax': qtdMax,
    };
  }

  factory Pickingv2Model.fromMap(Map<String, dynamic> map) {
    return Pickingv2Model(
      descricao: map['descricao'] ?? '',
      separado: map['separado']?.toDouble() ?? 0.0,
      codigobarras: map['codigobarras'] ?? '',
      codigobarras2: map['codigobarras2'] ?? '',
      quantidade: map['quantidade']?.toDouble() ?? 0.0,
      fator: map['fator']?.toDouble() ?? 0.0,
      lote: map['lote'] ?? '',
      codEndereco: map['codEndereco'] ?? '',
      descEndereco: map['descEndereco'] ?? '',
      pedido: map['pedido'] ?? '',
      itemPedido: map['itemPedido'] ?? '',
      local: map['local'] ?? '',
      origem: map['origem'] ?? '',
      um: map['um'] ?? '',
      codigo: map['codigo'] ?? '',
      chave: map['chaveSDC'] ?? '',
      codCli: map['codCliente'] ?? '',
      desCli: map['descCliente'] ?? '',
      rua: map['rua'] ?? '',
      descEndereco2: map['descEnderecov2'] ?? '',
      rua2: map['rua_v2'] ?? '',
      deposito: map['deposito'] ?? '',
      predio: map['predio'] ?? '',
      nivel: map['nivel'] ?? '',
      apartamento: map['aparatamento'] ?? '',
      status: map['status'] ?? '',
      serial: map['serial'] ?? '',
      recnoSDC: map['recnoSDC']?.toInt() ?? 0,
      qtdPar: map['qtdPar']?.toInt() ?? 0,
      qtdKit: map['qtdKit']?.toInt() ?? 0,
      qtdSerial: map['qtdSerial']?.toInt() ?? 0,
      qtdMax: map['qtdMax']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  double calcSerialSkuQuantity(int seriais) {
    double calc = 0;

    if (qtdPar > 0) {
      calc = seriais / qtdPar;
    }

    if (qtdKit > 0) {
      calc = calc / qtdKit;
    }

    return calc;
  }

  factory Pickingv2Model.fromJson(String source) =>
      Pickingv2Model.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Pickingv2Model(descricao: $descricao, separado: $separado, codigobarras: $codigobarras, quantidade: $quantidade, lote: $lote, codEndereco: $codEndereco, descEndereco: $descEndereco, pedido: $pedido, itemPedido: $itemPedido, local: $local, origem: $origem, um: $um, codigo: $codigo)';
  }
}

class LoadGroupProdModel {
  String load;
  String local;
  double quantity;
  double quantityCheck;
  String product;
  String descrition;
  String address;
  String addressDescription;

  String barcode1;
  String barcode2;

  String rua2;
  String deposito;
  String predio;
  String nivel;
  String apartamento;

  List<Pickingv2Model> products;
  LoadGroupProdModel({
    required this.load,
    required this.local,
    required this.quantity,
    required this.quantityCheck,
    required this.product,
    required this.descrition,
    required this.address,
    required this.addressDescription,
    required this.barcode1,
    required this.barcode2,
    required this.rua2,
    required this.deposito,
    required this.predio,
    required this.nivel,
    required this.apartamento,
    required this.products,
  });

  double getTotalQuantity() {
    return products.fold(0.0, (a, b) => a + b.quantidade);
  }

  double getTotalSeparado() {
    return products.fold(0.0, (a, b) => a + b.separado);
  }

  void setQuantity(double quantity) {
    double saldo = quantity;

    //zera antes de distribuir
    for (var element in products) {
      element.separado = 0;
    }

    for (var produto in products) {
      if (produto.separado < produto.quantidade) {
        //se a quantidade exceder a quantidade do primeiro pedido, preenche como completo e controla o saldo
        if ((saldo + produto.separado) > produto.quantidade) {
          double necessario = produto.quantidade - produto.separado;
          produto.separado = produto.separado + necessario;
          saldo = saldo - necessario;
          //esse produto ja foi atendido
          continue;
        }

        if (saldo > 0) {
          produto.separado = produto.separado + saldo;
          saldo = 0;
        }
      }
    }
    //se ainda sobrou saldo extra, joga no ultimo
    if (saldo > 0) {
      if (product.isNotEmpty) {
        Pickingv2Model ultimPed = products.last;
        ultimPed.separado = ultimPed.separado + saldo;
      }
    }
  }
}
