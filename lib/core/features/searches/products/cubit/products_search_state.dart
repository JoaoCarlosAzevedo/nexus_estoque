import 'package:equatable/equatable.dart';

import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/features/searches/products/data/model/product_search_model.dart';

abstract class ProductsSearchState extends Equatable {}

class ProductsSearchInitial extends ProductsSearchState {
  @override
  List<Object> get props => [];
}

class ProductsSearchLoading extends ProductsSearchState {
  @override
  List<Object> get props => [];
}

class ProductsSearchLoaded extends ProductsSearchState {
  final List<ProductSearchModel> products;

  ProductsSearchLoaded({
    required this.products,
  });
  @override
  List<Object> get props => [products];
}

class ProductsSearchError extends ProductsSearchState {
  final Failure error;

  ProductsSearchError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
