import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_estoque/core/pages/searches/address/page/address_search_page.dart';
import 'package:nexus_estoque/core/pages/searches/products/pages/products_search_page.dart';
import 'package:nexus_estoque/core/pages/searches/warehouses/pages/warehouse_search_page.dart';
import 'package:nexus_estoque/features/address/data/model/product_address_model.dart';
import 'package:nexus_estoque/features/address/data/repositories/product_address_repository.dart';
import 'package:nexus_estoque/features/address/presentation/pages/address_list_page/address_page.dart';
import 'package:nexus_estoque/features/address/presentation/pages/address_list_page/cubit/product_address_cubit.dart';
import 'package:nexus_estoque/features/address/presentation/pages/product_address_form_page/address_form_page.dart';
import 'package:nexus_estoque/features/address/presentation/pages/product_address_form_page/cubit/cubit/product_address_form_cubit.dart';

import 'package:nexus_estoque/features/menu/presentantion/pages/menu_page.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/pages/product_selection/product_transfer_page.dart';
import 'package:nexus_estoque/features/transfer/presentation/pages/product_selection/pages/product_selection/product_selection_page.dart';

class AppRouter {
  late ProductAddressRepository productAddressRepository;
  late ProductAddressCubit productAddresCubit;
  late ProductAddressFormCubit productAddressFormCubit;

  AppRouter() {
    productAddressRepository = ProductAddressRepository();
    productAddresCubit = ProductAddressCubit(productAddressRepository);
    productAddressFormCubit = ProductAddressFormCubit(productAddressRepository);
  }

  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (context) => const MenuPage());
      case "/enderecas":
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: productAddresCubit,
            child: const AddressPage(),
          ),
        );
      case "/enderecar/form":
        if (settings.name == "/enderecar/form") {
          final args = settings.arguments as ProductAddressModel;
          return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: productAddressFormCubit,
              child: AddressForm(
                productAddress: args,
              ),
            ),
          );
        } else {
          return MaterialPageRoute(
              builder: (context) =>
                  const DefaultPage(title: 'Error Parametro'));
        }

      case "/transferencias":
        return MaterialPageRoute(
            builder: (context) => const ProductSelectionPage());
      case "/enderecos":
        final args = settings.arguments as String;
        return MaterialPageRoute(
            builder: (context) => AddressSearchPage(
                  warehouse: args,
                ));
      case "/produtos":
        return MaterialPageRoute(
            builder: (context) => const ProductSearchPage());
      case "/produtos/saldos":
        if (settings.name == "/produtos/saldos") {
          final args = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => ProductSelectionForm(
              barcode: args,
            ),
          );
        } else {
          return MaterialPageRoute(
              builder: (context) =>
                  const DefaultPage(title: 'Error Parametro'));
        }
      case "/armazem":
        return MaterialPageRoute(
            builder: (context) => const WarehouseSearchPage());
      case "/configuracoes":
        return MaterialPageRoute(
            builder: (context) => const DefaultPage(title: 'Configuracoes'));
      default:
        return MaterialPageRoute(
            builder: (context) => const DefaultPage(title: 'Default'));
    }
  }
}

class DefaultPage extends StatelessWidget {
  final String title;

  const DefaultPage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(title),
      ),
    );
  }
}
