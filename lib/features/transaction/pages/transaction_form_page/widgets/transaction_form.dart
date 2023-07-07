import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus_estoque/core/features/product_balance/data/model/product_balance_model.dart';
import 'package:nexus_estoque/core/features/searches/addresses/data/model/address_model.dart';
import 'package:nexus_estoque/core/features/searches/addresses/page/address_search_page.dart';
import 'package:nexus_estoque/core/features/searches/batches/pages/batches_search_page.dart';
import 'package:nexus_estoque/core/features/searches/clients/data/model/client_model.dart';
import 'package:nexus_estoque/core/features/searches/clients/pages/client_search_page.dart';
import 'package:nexus_estoque/core/features/searches/warehouses/pages/warehouse_search_page.dart';
import 'package:nexus_estoque/core/mixins/validation_mixin.dart';
import 'package:nexus_estoque/core/widgets/form_input_search_widget.dart';
import 'package:nexus_estoque/features/transaction/data/model/transaction_model.dart';
import 'package:nexus_estoque/features/transaction/pages/transaction_form_page/cubit/transaction_cubit.dart';
import 'package:nexus_estoque/features/transaction/pages/transaction_form_page/widgets/date_input_field.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form_page/widgets/input_quantity.dart';
import 'package:nexus_estoque/features/transfer/pages/product_selection_transfer/pages/product_transfer_form_page/widgets/produc_transfer_card.dart';

class TransactionFormPage extends StatefulWidget {
  const TransactionFormPage({super.key, required this.product});
  final ProductBalanceModel product;

  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState();
}

enum Tm { entrada, saida }

class _TransactionFormPageState extends State<TransactionFormPage>
    with ValidationMixi {
  final formKey = GlobalKey<FormState>();
  Tm? tmSelected = Tm.entrada;
  final TextEditingController warehouseController = TextEditingController();
  final TextEditingController batchController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController batchDateController = TextEditingController();
  final TextEditingController quantityController =
      TextEditingController(text: '1.00');
  ClientModel? clientSelected;

  @override
  void initState() {
    warehouseController.text = widget.product.localPadrao;
    super.initState();
  }

  @override
  void dispose() {
    warehouseController.dispose();
    batchController.dispose();
    addressController.dispose();
    quantityController.dispose();
    batchDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            ProductHeaderCard(
              productDetail: widget.product,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Radio<Tm>(
                            value: Tm.entrada,
                            groupValue: tmSelected,
                            onChanged: (Tm? value) {
                              setState(() {
                                tmSelected = value;
                                batchDateController.clear();
                              });
                            },
                          ),
                          const Text("Entrada")
                        ],
                      ),
                      Row(
                        children: [
                          Radio<Tm>(
                            value: Tm.saida,
                            groupValue: tmSelected,
                            onChanged: (Tm? value) {
                              setState(() {
                                tmSelected = value;
                                batchDateController.clear();
                              });
                            },
                          ),
                          const Text("Saida")
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          clientSelected != null
                              ? clientSelected!.nome
                              : 'Selecione o Cliente',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final value = await ClientSearchModal.show(context);
                          setState(() {
                            clientSelected = value;
                          });

                          /*  if (value is AddressModel) {
                        addressController.text = value.codigo;
                        batchController.text = value.lote;
                      } */
                        },
                        icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
                      ),
                    ],
                  ),
                  InputSearchWidget(
                    label: "Armazem",
                    autoFocus: false,
                    controller: warehouseController,
                    validator: isNotEmpty,
                    onPressed: () async {
                      final value = await WarehouseSearchModal.show(
                          context, widget.product, tmSelected!);
                      warehouseController.text = value;
                    },
                  ),
                  if (widget.product.localizacao == 'S' &&
                      tmSelected! == Tm.saida)
                    InputSearchWidget(
                      label: "Endereço",
                      controller: addressController,
                      validator: isNotEmpty,
                      onPressed: () async {
                        final value = await AddressSearchModal.show(
                            context, warehouseController.text, widget.product);
                        if (value is AddressModel) {
                          addressController.text = value.codigo;
                          batchController.text = value.lote;
                        }
                      },
                    ),
                  if (widget.product.lote == 'L')
                    InputSearchWidget(
                      label: "Lote",
                      controller: batchController,
                      validator: isNotEmpty,
                      onPressed: () async {
                        final value = await BatchSearchModal.show(
                            context,
                            widget.product,
                            warehouseController.text,
                            tmSelected!);
                        batchController.text = value;
                      },
                    ),
                  if (widget.product.lote == 'L' && tmSelected! == Tm.entrada)
                    DateTextField(
                      controller: batchDateController,
                      validator: isDate,
                    ),
                  InputQuantity(
                    controller: quantityController,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      var codcli = "";
                      var lojacli = "";
                      var nomecli = "";

                      final isValid = formKey.currentState!.validate();
                      if (isValid) {
                        final tm = tmSelected == Tm.entrada ? '001' : '501';

                        if (clientSelected != null) {
                          codcli = clientSelected!.codigo;
                          lojacli = clientSelected!.loja;
                          nomecli = clientSelected!.nome;
                        }

                        final transaction = TransactionModel(
                            codigo: widget.product.codigo,
                            local: warehouseController.text,
                            quantidade: double.parse(quantityController.text),
                            lote: batchController.text,
                            endereco: addressController.text,
                            validade: batchDateController.text,
                            codcli: codcli,
                            lojacli: lojacli,
                            nomecli: nomecli);

                        context
                            .read<TransactionCubit>()
                            .postTransaction(transaction, tm);
                      }
                    },
                    child: const SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Center(child: Text("Confirmar")),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
