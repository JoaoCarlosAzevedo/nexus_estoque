import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/model/carga_group_model.dart';
import '../data/repositories/conferencia_pedidos_carga_repository.dart';

final cargasListProvider = FutureProvider.autoDispose
    .family<List<CargaGroup>, String>((ref, dateRange) async {
  final parts = dateRange.split('/');
  if (parts.length != 2) {
    throw Exception('Intervalo de datas inválido');
  }

  final result = await ref
      .read(conferenciaPedidosCargaRepositoryProvider)
      .fetchPedidos(parts[0], parts[1]);

  return result.fold(
    (failure) => throw Exception(failure.error),
    (pedidos) => CargaGroup.fromPedidos(pedidos),
  );
});
