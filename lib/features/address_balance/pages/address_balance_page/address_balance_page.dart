import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/features/address_balance/data/model/address_balance_model.dart';
import 'package:nexus_estoque/features/address_balance/data/repositories/address_balance_repository.dart';
import 'package:nexus_estoque/features/address_balance/pages/address_balance_page/cubit/address_balance_cubit.dart';
import 'package:nexus_estoque/features/address_balance/pages/address_balance_page/widgets/address_product_balance_card.dart';

class AddressBalancePage extends ConsumerStatefulWidget {
  const AddressBalancePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddressBalancePageState();
}

class _AddressBalancePageState extends ConsumerState<AddressBalancePage> {
  List<AddressBalanceModel> listBalances = [];
  final TextEditingController controller = TextEditingController();
  final FocusNode focus = FocusNode();
  late AddressBalanceCubit cubit;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saldo por Endereço')),
      body: BlocProvider(
        create: (context) => AddressBalanceCubit(
            repository: ref.read(addressBalanceRepositoryProvider)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                showCursor: true,
                autofocus: true,
                controller: controller,
                focusNode: focus,
                onSubmitted: (e) {
                  cubit.fetchAddressBalances(controller.text);
                  focus.requestFocus();
                  controller.clear();
                },
                decoration: const InputDecoration(
                  //prefixIcon: Icon(Icons.search),
                  label: Text("Cód. Endereço"),
                  /*  suffixIcon: IconButton(
                      onPressed: () async {
                        await AddressSearchModal.show(context);
                      },
                      icon: Icon(Icons.search)), */
                ),
              ),
              Expanded(
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
                              .fetchAddressBalances(controller.text);
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

                      return RefreshIndicator(
                        onRefresh: () async {
                          context
                              .read<AddressBalanceCubit>()
                              .fetchAddressBalances(controller.text);
                        },
                        child: ListView.builder(
                          itemCount: listBalances.length,
                          itemBuilder: (context, index) {
                            return AddressProductBalanceCard(
                                productBalance: listBalances[index]);
                          },
                        ),
                      );
                    }
                    return const Center(
                      child: Text("Informe o cód. do endereço"),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
