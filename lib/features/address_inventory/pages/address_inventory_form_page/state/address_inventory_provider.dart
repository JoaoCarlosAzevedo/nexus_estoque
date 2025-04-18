// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/features/searches/products/data/model/product_model.dart';
import '../../../data/model/inventory_product_model.dart';
import '../../../data/repositories/inventory_repository.dart';

final addressInventoryProvider = StateNotifierProvider.autoDispose<
    AddressInventoryNotifier, AddressInventoryState>((ref) {
  final repository = ref.read(inventoryRepository);
  return AddressInventoryNotifier(repository);
});

class AddressInventoryNotifier extends StateNotifier<AddressInventoryState> {
  final InventoryRepository repository;
  AddressInventoryNotifier(this.repository)
      : super(const AddressInventoryState(
            address: '',
            doc: '',
            warehouse: '',
            products: [],
            status: StateEnum.initial));

  void addProduct(ProductModel product, double quantity) {
    final list = state.products;

    if (state.address.isEmpty) {
      final index = list.indexWhere(
          (element) => element.codigo.trim() == product.codigo.trim());
      if (index >= 0) {
        if (list[index].codigo.isNotEmpty) {
          list[index] =
              list[index].copyWith(qtdInvet: list[index].qtdInvet + quantity);
        }
        state = state.copyWith(products: list);
      } else {
        if (product.codigo.isNotEmpty) {
          product = product.copyWith(qtdInvet: quantity);
        }
        state = state.copyWith(products: [...state.products, product]);
      }
    } else {
      final index = list.indexWhere(
          (element) => element.codigo.trim() == product.codigo.trim());
      if (index >= 0) {
        if (list[index].codigo.isNotEmpty) {
          list[index] =
              list[index].copyWith(qtdInvet: list[index].qtdInvet + quantity);
        }
        state = state.copyWith(products: list);
      } else {
        if (product.codigo.isNotEmpty) {
          product = product.copyWith(qtdInvet: quantity);
        }

        state = state.copyWith(products: [product]);
      }
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

  void setWarehouse(String warehouse) {
    state = state.copyWith(warehouse: warehouse);
  }

  void setAddress(String address) {
    state = state.copyWith(address: address);
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

  void changeQuantity(ProductModel product, double quantity) {
    final products = state.products;
    final index = products.indexWhere(
        (element) => element.codigo.trim() == product.codigo.trim());
    if (index >= 0) {
      products[index] = products[index].copyWith(qtdInvet: quantity);
      state = state.copyWith(products: products);
    }
  }

  void postInventory() async {
    final products = state.products;

    if (products.isEmpty) {
      return;
    }

    final json = products
        .map((e) => {
              'codigo': e.codigo,
              'doc': state.doc,
              'quant': e.qtdInvet,
              'local':
                  state.warehouse.isEmpty ? e.localPadrao : state.warehouse,
              'localizacao': state.address.isEmpty ? '' : state.address,
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
      state = state.copyWith(status: StateEnum.error);
    }
  }
}

enum StateEnum {
  initial,
  loading,
  loaded,
  error,
  success,
}

@immutable
class AddressInventoryState {
  final String doc;
  final String address;
  final String warehouse;
  final List<ProductModel> products;
  final StateEnum status;

  const AddressInventoryState({
    required this.doc,
    required this.address,
    required this.warehouse,
    required this.products,
    required this.status,
  });

  AddressInventoryState copyWith({
    String? doc,
    String? address,
    String? warehouse,
    List<ProductModel>? products,
    StateEnum? status,
  }) {
    return AddressInventoryState(
      doc: doc ?? this.doc,
      address: address ?? this.address,
      warehouse: warehouse ?? this.warehouse,
      products: products ?? this.products,
      status: status ?? this.status,
    );
  }
}
