import 'package:nexus_estoque/features/etiqueta_nf_saida/data/model/etiqueta_nf_saida_status_model.dart';

enum ConferenciaSaidaStatus { pendente, parcial, conferida }

extension ConferenciaSaidaStatusX on EtiquetaNfSaidaStatus {
  bool _itemConferido(EtiquetaNfSaidaStatusProduto produto) =>
      produto.checked >= produto.quantidade;

  ConferenciaSaidaStatus get statusConferencia {
    if (produtos.isEmpty) return ConferenciaSaidaStatus.pendente;
    if (produtos.every(_itemConferido)) return ConferenciaSaidaStatus.conferida;
    if (produtos.every((produto) => produto.checked <= 0)) {
      return ConferenciaSaidaStatus.pendente;
    }
    return ConferenciaSaidaStatus.parcial;
  }

  int get itensConferidos => produtos.where(_itemConferido).length;

  String get statusLabel {
    switch (statusConferencia) {
      case ConferenciaSaidaStatus.pendente:
        return 'Pendente';
      case ConferenciaSaidaStatus.parcial:
        return 'Parcial';
      case ConferenciaSaidaStatus.conferida:
        return 'Conferida';
    }
  }
}
