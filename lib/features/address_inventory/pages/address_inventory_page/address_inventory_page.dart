import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/features/searches/products/data/model/product_model.dart';
import '../../../../core/features/searches/products/provider/remote_product_provider.dart';
import '../../../../core/mixins/validation_mixin.dart';

import '../../../address_balance/data/model/address_balance_model.dart';
import '../../../address_balance/data/repositories/address_balance_repository.dart';
import '../../../address_balance/pages/address_balance_page/cubit/address_balance_cubit.dart';
import '../../../address_balance/pages/address_balance_page/widgets/address_product_balance_card.dart';

class AddressInventoryPage extends ConsumerStatefulWidget {
  const AddressInventoryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddressInventoryPageState();
}

class _AddressInventoryPageState extends ConsumerState<AddressInventoryPage>
    with ValidationMixi {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController productController = TextEditingController();
  final FocusNode addressFocus = FocusNode();
  List<AddressBalanceModel> listBalances = [];
  late AddressBalanceCubit cubit;

  @override
  void dispose() {
    addressController.dispose();
    addressFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventário"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text("Documento"),
              TextFormField(
                focusNode: addressFocus,
                autofocus: true,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (e) {
                  cubit.fetchAddressBalances(e);
                  addressController.clear();
                  addressFocus.requestFocus();
                },
                validator: isNotEmpty,
                controller: addressController,
                decoration: const InputDecoration(
                  label: Text("Endereço"),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.qr_code),
                ),
              ),
              BlocProvider(
                create: (context) => AddressBalanceCubit(
                    repository: ref.read(addressBalanceRepositoryProvider)),
                child: Expanded(
                  child: BlocBuilder<AddressBalanceCubit, AddressBalanceState>(
                    builder: (context, state) {
                      cubit = context.read<AddressBalanceCubit>();

                      if (state is AddressBalanceLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is AddressBalanceError) {
                        return RefreshIndicator(
                          onRefresh: () async {
                            context
                                .read<AddressBalanceCubit>()
                                .fetchAddressBalances(addressController.text);
                          },
                          child: Center(
                            child: Text(state.error.error),
                          ),
                        );
                      }
                      if (state is AddressBalanceLoaded) {
                        final repositions = state.addressBalances;
                        listBalances = repositions;

                        if (listBalances.isEmpty) {
                          return const Center(
                            child: Text("Nenhum registro encontrado."),
                          );
                        }

                        if (listBalances.length > 1) {
                          return const Center(
                            child: Text(
                                "Endereço digitado possui saldo em mais de um armazém"),
                          );
                        }
                        return ListView.builder(
                          itemCount: listBalances.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(listBalances[index].armazemDesc),
                              subtitle: Text(listBalances[index].codEndereco),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(listBalances[index].armazem),
                                  Text(listBalances[index].armazemDesc),
                                ],
                              ),
                            );
                            /* return AddressProductBalanceCard(
                                productBalance: listBalances[index]); */
                          },
                        );
                      }
                      return const Center(
                        child: Text("Informe o cód. do endereço"),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (e) {
                    getProduct(e);
                    productController.clear();
                  },
                  validator: isNotEmpty,
                  controller: productController,
                  decoration: const InputDecoration(
                    label: Text("Produto"),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.qr_code),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addressSearch(context) async {}

  void getProduct(String product) {
    //45160894
    final List<ProductModel> listWatch =
        ref.watch(remoteProductProvider).maybeWhen(
              data: (data) => data,
              orElse: () => [],
            );
    if (listWatch.isNotEmpty) {
      final selectedProduct = listWatch
          .firstWhere((element) => element.codigo.trim() == product.trim());
      print('${selectedProduct.descricao}');
    }
  }
}
