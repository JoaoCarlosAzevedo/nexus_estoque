import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/features/searches/products/data/model/product_model.dart';
import '../../address_inventory/data/model/inventory_product_model.dart';
import '../../address_inventory/data/repositories/inventory_repository.dart';
import '../../address_inventory/pages/address_inventory_form_page/state/address_inventory_provider.dart';

final inventoryProvider =
    StateNotifierProvider.autoDispose<InventoryNotifier, InventoryState>((ref) {
  final repository = ref.read(inventoryRepository);
  return InventoryNotifier(repository);
});

class InventoryNotifier extends StateNotifier<InventoryState> {
  final InventoryRepository repository;
  InventoryNotifier(this.repository)
      : super(const InventoryState(
            doc: '', products: [], status: StateEnum.initial));

  void resetState() {
    state = state.copyWith(
        address: '',
        doc: '',
        warehouse: '',
        products: [],
        status: StateEnum.initial);
  }

  void addProduct(ProductModel product) {
    final list = state.products;

    final index = list.indexWhere(
        (element) => element.codigo.trim() == product.codigo.trim());
    if (index >= 0) {
      if (list[index].codigo.isNotEmpty) {
        list[index] = list[index].copyWith(qtdInvet: list[index].qtdInvet + 1);
      }
      state = state.copyWith(products: list);
    } else {
      if (product.codigo.isNotEmpty) {
        product = product.copyWith(qtdInvet: 1);
      }
      //state = state.copyWith(products: [product]);
      state = state.copyWith(products: [...state.products, product]);
    }
  }

  void removeProduct(ProductModel product) {
    state = state.copyWith(products: [
      for (final products in state.products)
        if (products.codigo.trim() != product.codigo.trim()) products,
    ]);
  }

  void setDoc(String document) {
    state = state.copyWith(doc: document);
  }

  void changeQuantity(ProductModel product, double quantity) {
    final products = state.products;
    final index = products.indexWhere(
        (element) => element.codigo.trim() == product.codigo.trim());
    if (index >= 0) {
      products[index] = products[index].copyWith(qtdInvet: quantity);
      state = state.copyWith(products: products);
    }
  }

  void errorProducts(List<InventoryProductModel> products) {
    final formProducts = [...state.products];

    for (var i = 0; i < products.length; i++) {
      if (products[i].error.isNotEmpty) {
        var index = formProducts.indexWhere(
            (element) => element.codigo.trim() == products[i].codigo.trim());
        if (index >= 0) {
          var aux = formProducts[index];

          var newObj = aux.copyWith(error: products[i].error);

          formProducts[index] = newObj;
        }
      } else {
        var index = formProducts.indexWhere(
            (element) => element.codigo.trim() == products[i].codigo.trim());
        if (index >= 0) {
          formProducts.removeAt(index);
        }
      }
    }
    state = state.copyWith(products: formProducts);
  }

  void resetError() {
    state = state.copyWith(status: StateEnum.initial);
  }

  void postInventory(String warehouse, String doc) async {
    final products = state.products;

    if (products.isEmpty) {
      return;
    }

    final json = products
        .map((e) => {
              'codigo': e.codigo,
              'doc': doc,
              'quant': e.qtdInvet,
              'local': warehouse,
            })
        .toList();

    final String jsonString = jsonEncode(json);

    state = state.copyWith(status: StateEnum.loading);

    try {
      final retProducts = await repository.postInventory(jsonString);

      errorProducts(retProducts);

      state = state.copyWith(status: StateEnum.loaded);

      if (state.products.isEmpty) {
        state = state.copyWith(status: StateEnum.success);
      }
    } catch (e) {
      log(e.toString());
      state = state.copyWith(status: StateEnum.error);
    }
  }
}

class InventoryState {
  final String doc;

  final List<ProductModel> products;
  final StateEnum status;

  const InventoryState({
    required this.doc,
    required this.products,
    required this.status,
  });

  InventoryState copyWith({
    String? doc,
    String? address,
    String? warehouse,
    List<ProductModel>? products,
    StateEnum? status,
  }) {
    return InventoryState(
      doc: doc ?? this.doc,
      products: products ?? this.products,
      status: status ?? this.status,
    );
  }
}
