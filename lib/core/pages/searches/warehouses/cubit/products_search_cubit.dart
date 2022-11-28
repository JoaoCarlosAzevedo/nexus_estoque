import 'package:bloc/bloc.dart';
import 'package:nexus_estoque/core/pages/searches/warehouses/cubit/products_search_state.dart';
import 'package:nexus_estoque/core/pages/searches/warehouses/data/repositories/warehouse_search_repository.dart';

class WarehouseSearchCubit extends Cubit<WarehouseSearchState> {
  final WarehouseSearchRepository repository;

  WarehouseSearchCubit(this.repository) : super(WarehouseSearchInitial()) {
    fetchWarehouses();
  }

  Future<void> fetchWarehouses() async {
    emit(WarehouseSearchLoading());

    final result = await repository.fetchWarehouses();

    if (result.isRight()) {
      result.fold((l) => null, (r) {
        emit(
          WarehouseSearchLoaded(warehouses: r),
        );
      });
    } else {
      result.fold((l) => emit(WarehouseSearchError(error: l)), (r) => null);
    }
  }
}
