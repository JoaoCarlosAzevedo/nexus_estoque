import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import '../../../../core/mixins/validation_mixin.dart';

import '../../../address_balance/data/model/address_balance_model.dart';
import '../../../address_balance/data/repositories/address_balance_repository.dart';
import '../../../address_balance/pages/address_balance_page/cubit/address_balance_cubit.dart';
import 'widgets/products_status_widget.dart';

const List<String> list = <String>['1', '2', '3', '4'];

class AddressInventoryPage extends ConsumerStatefulWidget {
  const AddressInventoryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddressInventoryPageState();
}

class _AddressInventoryPageState extends ConsumerState<AddressInventoryPage>
    with ValidationMixi {
  final TextEditingController addressController = TextEditingController();

  final FocusNode addressFocus = FocusNode();
  List<AddressBalanceModel> listBalances = [];
  late AddressBalanceCubit cubit;
  final DateFormat formatter = DateFormat('yyyyMMdd');

  String dropdownValue = list.first;

  @override
  void dispose() {
    addressController.dispose();
    addressFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String doc = formatter.format(DateTime.now());
    Future.delayed(const Duration(),
        () => SystemChannels.textInput.invokeMethod('TextInput.hide'));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventário"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Documento: $doc$dropdownValue",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Contagem: ",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: Theme.of(context).textTheme.titleLarge,
                    underline: Container(
                      height: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const ProductsStatusWidget(),
            const Divider(),
            TextFormField(
              focusNode: addressFocus,
              autofocus: true,
              textInputAction: TextInputAction.next,
              // textInputAction: TextInputAction.next,
              onFieldSubmitted: (e) {
                Future.delayed(
                    const Duration(),
                    () => SystemChannels.textInput
                        .invokeMethod('TextInput.hide'));
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
            Expanded(
              child: BlocProvider(
                create: (context) => AddressBalanceCubit(
                    repository: ref.read(addressBalanceRepositoryProvider)),
                child: BlocListener<AddressBalanceCubit, AddressBalanceState>(
                  listener: (context, state) {
                    if (state is AddressBalanceLoaded) {
                      if (state.addressBalances.isNotEmpty) {
                        context.read<AddressBalanceCubit>().resetState();

                        context.push(
                            "/inventario_endereco/form/$doc$dropdownValue",
                            extra: state.addressBalances.first);
                      }
                    }
                  },
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
                        /* 
                                                  if (listBalances.length > 1) {
                                                    return const Center(
                                                      child: Text(
                                                          "Endereço digitado possui saldo em mais de um armazém"),
                                                    );
                                                  } */

                        return ListView.builder(
                          itemCount: listBalances.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                onTap: () {
                                  context.push(
                                      "/inventario_endereco/form/$doc$dropdownValue",
                                      extra: listBalances[index]);
                                },
                                /*       leading: IconButton(
                                                  onPressed: () {
                                                    context.push(
                                                      '/inventario_endereco/consulta/${listBalances[index].armazem}/${listBalances[index].codEndereco}',
                                                    );
                                                  },
                                                  icon: const Icon(Icons.search)), */
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
            ),
          ],
        ),
      ),
    );
  }

  void hideKeyboard() async {
    await Future.delayed(
      const Duration(milliseconds: 100),
      () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
    );
  }
}
