import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/features/purchase_invoice_check/pages/purchase_invoice_products/widge/purchase_quantity_widget.dart';

import '../../../../core/widgets/form_input_no_keyboard_widget.dart';
import '../../../address/pages/product_address_form_page/address_form_page.dart';
import '../../data/model/purchase_invoice_model.dart';
import '../../data/repositories/purchase_invoice_repository.dart';
import 'cubit/purchase_invoice_products_cubit.dart';
import 'widge/invoice_product_widget.dart';
import 'widge/purchase_scanned_product_widget.dart';

class PurchaseInvoiceProdutcts extends ConsumerStatefulWidget {
  const PurchaseInvoiceProdutcts({required this.invoices, super.key});
  final List<PurchaseInvoice> invoices;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PurchaseInvoiceProdutctsState();
}

class _PurchaseInvoiceProdutctsState
    extends ConsumerState<PurchaseInvoiceProdutcts> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focus = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.read(purchaseInvoiceRepositoryProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Produtos NF's"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: true,
                child: BlocProvider(
                    create: (context) => PurchaseInvoiceProductsCubit(
                        widget.invoices, repository),
                    child: BlocListener<PurchaseInvoiceProductsCubit,
                        PurchaseInvoiceProductsState>(
                      listener: (context, state) {
                        if (state is PurchaseInvoiceProductsError) {
                          showError(context, state.error.error);
                        }

                        if (state is PurchaseInvoiceProductsSuccess) {
                          Navigator.pop(context);
                        }
                      },
                      child: BlocBuilder<PurchaseInvoiceProductsCubit,
                          PurchaseInvoiceProductsState>(
                        builder: (context, state) {
                          if (state is PurchaseInvoiceProductsLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (state is PurchaseInvoiceProductsLChecking) {
                            final invoices = state.invoices;
                            final products = invoices
                                .fold(<PurchaseInvoiceProduct>[],
                                    (previousValue, element) {
                              previousValue
                                  .addAll(element.purchaseInvoiceProducts);
                              return previousValue;
                            });

                            return Column(
                              children: [
                                /*  TextField(
                                  autofocus: true,
                                  focusNode: focus,
                                  controller: controller,
                                  decoration: const InputDecoration(
                                    label: Text("Cód. Barras ou SKU..."),
                                  ),
                                  onSubmitted: ((value) {
                                    context
                                        .read<PurchaseInvoiceProductsCubit>()
                                        .checkBarcode(value.trim());
                                    focus.requestFocus();
                                    controller.clear();
                                  }), 
                                ), */
                                NoKeyboardTextForm(
                                  autoFocus: true,
                                  focusNode: focus,
                                  controller: controller,
                                  label: "Cód. Barras ou SKU...",
                                  onSubmitted: (value) {
                                    context
                                        .read<PurchaseInvoiceProductsCubit>()
                                        .checkBarcode(value.trim());
                                    focus.requestFocus();
                                    controller.clear();
                                  },
                                ),
                                PurchaseScannedCard(
                                  barcode: state.barcode,
                                  notFound: state.show,
                                  product: state.product,
                                  onPressed: () async {
                                    final double? newQuantity =
                                        await PurchasePurchaseCheckQuantityModal
                                            .show(context, state.product!,
                                                state.product!.checked);
                                    if (newQuantity != null) {
                                      // ignore: use_build_context_synchronously
                                      context
                                          .read<PurchaseInvoiceProductsCubit>()
                                          .setProductQuantity(
                                              state.product!, newQuantity);
                                    }
                                  },
                                  onClose: () {
                                    context
                                        .read<PurchaseInvoiceProductsCubit>()
                                        .reset();
                                  },
                                ),
                                /*    Expanded(
                                  
                                  child: ListView(shrinkWrap: true, children: [
                                    ...products.map((e) {
                                      return InvoiceProductCheckCard(
                                        product: e,
                                        onTapCard: () {},
                                        onDelete: () {
                                          context
                                              .read<
                                                  PurchaseInvoiceProductsCubit>()
                                              .setProductQuantity(e, 0);
                                        },
                                      );
                                    }).toList(),
                                  ]),
                                ), */
                                Expanded(
                                  child: ListView.builder(
                                    keyboardDismissBehavior:
                                        ScrollViewKeyboardDismissBehavior
                                            .onDrag,
                                    itemCount: products.length,
                                    itemBuilder: (context, index) {
                                      final product = products[index];
                                      return InvoiceProductCheckCard(
                                        product: product,
                                        onTapCard: () {},
                                        onDelete: () {
                                          context
                                              .read<
                                                  PurchaseInvoiceProductsCubit>()
                                              .setProductQuantity(product, 0);
                                        },
                                      );
                                    },
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<PurchaseInvoiceProductsCubit>()
                                        .postPurchaseInvoiceCheck();
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Center(
                                      child: Text("Salvar"),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          return const Text("estado invalido");
                        },
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
