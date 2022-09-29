import 'package:equatable/equatable.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/pages/searches/products/data/model/product_search_model.dart';
import 'package:nexus_estoque/core/pages/searches/warehouses/data/model/warehouse_search_model.dart';

abstract class WarehouseSearchState extends Equatable {}

class WarehouseSearchInitial extends WarehouseSearchState {
  @override
  List<Object> get props => [];
}

class WarehouseSearchLoading extends WarehouseSearchState {
  @override
  List<Object> get props => [];
}

class WarehouseSearchLoaded extends WarehouseSearchState {
  final List<WarehouseModel> warehouses;

  WarehouseSearchLoaded({
    required this.warehouses,
  });
  @override
  List<Object> get props => [warehouses];
}

class WarehouseSearchError extends WarehouseSearchState {
  final Failure error;

  WarehouseSearchError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
