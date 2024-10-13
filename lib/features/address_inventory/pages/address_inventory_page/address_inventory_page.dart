import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import '../../../../core/mixins/validation_mixin.dart';

import '../../../../core/widgets/form_input_no_keyboard_search_widget.dart';
import '../../../address_balance/data/model/address_balance_model.dart';
import '../../../address_balance/data/repositories/address_balance_repository.dart';
import '../../../address_balance/pages/address_balance_page/cubit/address_balance_cubit.dart';
import '../../../auth/providers/login_controller_provider.dart';
import '../../../auth/providers/login_state.dart';
import '../../data/repositories/inventory_repository.dart';
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
  String doc = "";
  String user = "";

  @override
  void dispose() {
    addressController.dispose();
    addressFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final docProvider = ref.
    final authUser = ref.read(loginControllerProvider);

    if (authUser is LoginStateSuccess) {
      user = authUser.user.id;
    }

    final docProvider = ref.watch(remoteGetInventoryDocProvider(user));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventário"),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            docProvider.when(
              skipLoadingOnRefresh: false,
              data: (data) {
                doc = data;
                return Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contagem: ${doc.substring(doc.length - 1)}',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        Text(
                          'Documento: $data',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    IconButton(
                      onPressed: () {
                        ref.invalidate(remoteGetInventoryDocProvider);
                      },
                      icon: const Icon(Icons.refresh),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final address = AddressBalanceModel(
                            descProd: '',
                            codProd: '',
                            um: '',
                            armazem: '',
                            codEndereco: '',
                            quantidade: 0.0,
                            empenho: 0.0,
                            endereDesc: '',
                            armazemDesc: '',
                            ultimoMov: '');
                        context.push("/inventario_endereco/form/$doc",
                            extra: address);
                      },
                      style:
                          TextButton.styleFrom(backgroundColor: Colors.orange),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Contagem s/ Endereço",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                    ),
                  ],
                );
              },
              error: ((error, stackTrace) => Row(
                    children: [
                      const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(error.toString()),
                      IconButton(
                        onPressed: () {
                          ref.invalidate(remoteGetInventoryDocProvider);
                        },
                        icon: const Icon(Icons.refresh),
                      ),
                    ],
                  )),
              loading: () => Row(
                children: [
                  Text(
                    "Documento: ",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    ),
                  ),
                ],
              ),
            ),
            const ProductsStatusWidget(),
            const Divider(),
            NoKeyboardTextSearchForm(
              focusNode: addressFocus,
              label: 'Endereço',
              autoFocus: true,
              onSubmitted: (e) {
                cubit.fetchAddressBalances(e);
                addressController.clear();
                addressFocus.requestFocus();
              },
              validator: isNotEmpty,
              controller: addressController,
            ),
            /* TextFormField(
              focusNode: addressFocus,
              autofocus: true,
              textInputAction: TextInputAction.next,
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
            ), */
            Expanded(
              child: BlocProvider(
                create: (context) => AddressBalanceCubit(
                    repository: ref.read(addressBalanceRepositoryProvider)),
                child: BlocListener<AddressBalanceCubit, AddressBalanceState>(
                  listener: (context, state) {
                    if (state is AddressBalanceLoaded) {
                      if (state.addressBalances.isNotEmpty) {
                        context.read<AddressBalanceCubit>().resetState();
                        state.addressBalances
                            .sort((a, b) => a.armazem.compareTo(b.armazem));

                        if (doc.isEmpty) {
                          AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  //title: 'Alerta',
                                  desc: "Erro ao carregar contagem",
                                  //btnCancelOnPress: () {},
                                  btnOkOnPress: () {},
                                  btnOkColor: Theme.of(context).primaryColor)
                              .show();
                        } else {
                          context.push("/inventario_endereco/form/$doc",
                              extra: state.addressBalances.first);
                        }
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
