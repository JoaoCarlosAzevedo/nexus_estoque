import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:nexus_estoque/core/features/product_balance/data/model/product_balance_model.dart';
import 'package:nexus_estoque/core/features/searches/addresses/data/model/address_model.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form_page/widgets/produc_transfer_card.dart';

import '../../../../../core/features/product_balance/data/repositories/product_balance_repository.dart';

import '../../../../address/pages/product_address_form_page/address_form_page.dart';
import '../../../../reposition/data/model/reposition_transfer_moderl.dart';

import '../../../../transfer/pages/product_selection_transfer/data/repositories/product_transfer_repository.dart';
import '../../../../transfer/pages/product_selection_transfer/pages/product_transfer_form_page/cubit/product_transfer_cubit.dart';
import '../../../../transfer/pages/product_selection_transfer/pages/product_transfer_form_page/widgets/transfer_form_page.dart';

class RepositionProductAddressList extends ConsumerWidget {
  const RepositionProductAddressList({required this.productBalance, super.key});
  final ProductBalanceModel productBalance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = getAllAdresses();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ProductHeaderCard(
            productDetail: productBalance,
          ),
        ),
        Expanded(
          child: GroupedListView<AddressModel, String>(
            elements: list,
            useStickyGroupSeparators: true, // optional
            //floatingHeader: true, // optional
            order: GroupedListOrder.ASC,
            itemComparator: (item1, item2) =>
                item1.local.compareTo(item2.local), // optional
            groupBy: (element) => element.local,
            groupSeparatorBuilder: (String groupByValue) {
              final warehouse = productBalance.armazem.firstWhere(
                (element) => element.codigo.contains(groupByValue),
              );

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: FaIcon(FontAwesomeIcons.warehouse),
                          ),
                          Text('${warehouse.codigo} - ${warehouse.descricao}'),
                        ],
                      ),
                      Text('${warehouse.saldoLocal} ${productBalance.uM}'),
                    ],
                  ),
                ),
              );
            },
            itemBuilder: (context, AddressModel element) {
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Card(
                  child: ListTile(
                    onTap: () {
                      onTap(context, element.codigo, element.local);
                    },
                    title: Text(element.codigo),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Endereço:  ${element.descEnderecov2}"),
                        Text(element.ultimoMov),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Saldo: ${element.quantidade}',
                          style: const TextStyle(color: Colors.green),
                        ),
                        Text('Empen.: ${element.empenho}'),
                      ],
                    ),
                  ),
                ),
              );
            },
            // optional
          ),
        ),
      ],
    );
  }

  List<AddressModel> getAllAdresses() {
    List<AddressModel> addresses = [];

    for (var elements in productBalance.armazem) {
      addresses.addAll(elements.enderecos);
    }

    //remove os pickings
    addresses.removeWhere((endereco) => endereco.picking);

    addresses.sort((a, b) => a.quantidade.compareTo(b.quantidade));

    return addresses;
  }

  void onTap(BuildContext context, String origAddress, String warehouse) {
    final productReposition = RepositionTrasnferModel(
        product: productBalance.codigo,
        origAddress: origAddress,
        destAddress: '',
        quantity: 0,
        warehouse: warehouse);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Reposição'),
          ),
          body: Consumer(builder: (context, ref, child) {
            return BlocProvider(
              create: (context) =>
                  ProductTransferCubit(ref.read(productTransferRepository)),
              child: BlocListener<ProductTransferCubit, ProductTransferState>(
                listener: (context, state) {
                  if (state is ProductTransferError) {
                    showError(context, state.error.error);
                  }

                  if (state is ProductTransferLoaded) {
                    //context.read<ProductBalanceCubit>().reset();
                    // final repository = ref.watch(productBalancetProvider(widget.productCode));
                    ref.invalidate(
                        productBalancetProvider(productBalance.codigo));
                    Navigator.pop(context);
                  }
                },
                child: BlocBuilder<ProductTransferCubit, ProductTransferState>(
                  builder: (context, state) {
                    if (state is ProductTransferLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return TransferFormPage(
                      productDetail: productBalance,
                      reposition: productReposition,
                    );
                  },
                ),
              ),
            );
          }),
          /*  body: BlocProvider(
            create: (context) =>
                ProductTransferCubit(ref.read(productTransferRepository)),
            child: BlocListener<ProductTransferCubit, ProductTransferState>(
              listener: (context, state) {
                if (state is ProductTransferError) {
                  showError(context, state.error.error);
                }

                if (state is ProductTransferLoaded) {
                  context.read<ProductBalanceCubit>().reset();
                  Navigator.pop(context);
                }
              },
              child: BlocBuilder<ProductTransferCubit, ProductTransferState>(
                builder: (context, state) {
                  if (state is ProductTransferLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return TransferFormPage(
                    productDetail: productBalance,
                    reposition: productReposition,
                  );
                },
              ),
            ),
          ), */
          /* body: TransferFormPage(
            productDetail: productBalance,
            reposition: productReposition,
          ), */
        ),
      ),
    );
  }

  /* 
  

    
  */
}
/* 
TransferFormPage(
                  productDetail: productBalance,
                  reposition: widget.productReposition,
                );
 */