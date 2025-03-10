// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:nexus_estoque/features/purchase_invoice_check/pages/purchase_invoice_products/widgets/purchase_quantity_widget.dart';

import '../../../../core/features/product_multiplier/pages/product_multiplier_modal.dart';
import '../../../../core/services/back_buttom_dialog.dart';
import '../../../../core/widgets/form_input_no_keyboard_widget.dart';
import '../../../address/pages/product_address_form_page/address_form_page.dart';
import '../../data/model/purchase_invoice_model.dart';
import '../../data/repositories/purchase_invoice_repository.dart';
import 'cubit/purchase_invoice_products_cubit.dart';
import 'widgets/grouped_product_purchase_scanned_widget.dart';
import 'widgets/grouped_product_status_widget.dart';
import 'widgets/invoice_product_widget.dart';

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
    return DefaultTabController(
      length: 2,
      child: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          if (didPop) {
            return;
          }
          final bool shouldPop = await showBackDialog(context) ?? false;
          if (context.mounted && shouldPop) {
            Navigator.pop(context);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text("Produtos NF's"),
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Conferencia"),
                      SizedBox(
                        width: 10,
                      ),
                      FaIcon(
                        FontAwesomeIcons.boxOpen,
                      ),
                    ],
                  ),
                ),
                Tab(
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Pendentes"),
                      SizedBox(
                        width: 10,
                      ),
                      FaIcon(
                        FontAwesomeIcons.clipboardCheck,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: TabBarView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 16.0, left: 8.0, right: 8.0, bottom: 8.0),
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
                                  ref.invalidate(purchaseInvoicesProvider);
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
                                  if (state
                                      is PurchaseInvoiceProductsLChecking) {
                                    final invoices = state.invoices;
                                    final products = invoices
                                        .fold(<PurchaseInvoiceProduct>[],
                                            (previousValue, element) {
                                      previousValue.addAll(
                                          element.purchaseInvoiceProducts);
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
                                        if (isCompleted(products))
                                          Text(
                                            "Documento já conferido!",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                        if (!isCompleted(products))
                                          NoKeyboardTextForm(
                                            autoFocus: true,
                                            focusNode: focus,
                                            controller: controller,
                                            label: "Cód. Barras ou SKU...",
                                            onSubmitted: (value) {
                                              context
                                                  .read<
                                                      PurchaseInvoiceProductsCubit>()
                                                  .checkBarcode(value.trim());

                                              focus.requestFocus();
                                              controller.clear();
                                            },
                                          ),
                                        GroupedProductScannedCard(
                                          barcode: state.barcode,
                                          listInvoices: state.invoices,
                                          notFound: state.show,
                                          product: state.product,
                                          onPressed: () async {
                                            final double? newQuantity =
                                                await PurchasePurchaseCheckQuantityModal
                                                    .show(context,
                                                        state.product!, 0.0);
                                            if (newQuantity != null) {
                                              /*    context
                                                .read<PurchaseInvoiceProductsCubit>()
                                                .setProductQuantity(
                                                    state.product!, newQuantity); */
                                              // ignore: use_build_context_synchronously
                                              context
                                                  .read<
                                                      PurchaseInvoiceProductsCubit>()
                                                  .setNewQuantity(newQuantity,
                                                      state.product!);
                                            }
                                            focus.requestFocus();
                                          },
                                          onClose: () {
                                            context
                                                .read<
                                                    PurchaseInvoiceProductsCubit>()
                                                .reset();
                                            focus.requestFocus();
                                          },
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            keyboardDismissBehavior:
                                                ScrollViewKeyboardDismissBehavior
                                                    .onDrag,
                                            itemCount: products.length,
                                            itemBuilder: (context, index) {
                                              final product = products[index];
                                              return InvoiceProductCheckCard(
                                                onChangeProduct: () async {
                                                  final isSuccess =
                                                      await showProductMultiplierModal(
                                                          context,
                                                          product.codigo);
                                                  if (isSuccess) {
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.pop(context);
                                                    ref.invalidate(
                                                        purchaseInvoicesProvider);
                                                  }
                                                },
                                                product: product,
                                                onChanged: (_) {
                                                  bool setBool =
                                                      !product.isMultiple;

                                                  context
                                                      .read<
                                                          PurchaseInvoiceProductsCubit>()
                                                      .setMultiplier(
                                                          product.codigo,
                                                          setBool);
                                                },
                                                onTapCard: () {},
                                                onDelete: () {
                                                  context
                                                      .read<
                                                          PurchaseInvoiceProductsCubit>()
                                                      .setProductQuantity(
                                                          product, 0);
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                        if (!isCompleted(products))
                                          ElevatedButton(
                                            onPressed: () {
                                              context
                                                  .read<
                                                      PurchaseInvoiceProductsCubit>()
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
                GroupedProductsStatusList(
                    invoices: widget.invoices, repository: repository),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isCompleted(List<PurchaseInvoiceProduct> products) {
    for (var product in products) {
      if (product.checkedBd < product.quantidade) {
        return false;
      }
    }
    return true;
  }
}
