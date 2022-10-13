import 'package:bloc/bloc.dart';
import 'package:nexus_estoque/core/pages/searches/products/cubit/products_search_state.dart';
import 'package:nexus_estoque/core/pages/searches/products/data/repositories/product_search_repository.dart';

class ProductsSearchCubit extends Cubit<ProductsSearchState> {
  final ProductSearchRepository repository;

  ProductsSearchCubit(this.repository) : super(ProductsSearchInitial()) {
    fetchProducts();
  }

  void cleanCache() {
    repository.cleanCache();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    emit(ProductsSearchLoading());

    final result = await repository.fetchAddress();

    if (result.isRight()) {
      result.fold((l) => null, (r) {
        emit(
          ProductsSearchLoaded(products: r),
        );
      });
    } else {
      result.fold((l) => emit(ProductsSearchError(error: l)), (r) => null);
    }
  }
}
