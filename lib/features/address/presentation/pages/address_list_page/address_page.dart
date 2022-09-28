import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_estoque/features/address/data/model/product_address_model.dart';
import 'package:nexus_estoque/features/address/presentation/pages/address_list_page/cubit/product_address_cubit.dart';
import 'package:nexus_estoque/features/address/presentation/pages/address_list_page/cubit/product_address_state.dart';
import 'package:nexus_estoque/features/address/presentation/pages/product_address_form_page/address_form_page.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  @override
  void initState() {
    context.read<ProductAddressCubit>().fetchProductAddress();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Endereçamento"),
        centerTitle: true,
      ),
      body: Padding(
        //padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
        padding: const EdgeInsets.all(0),
        child: Container(
          padding: const EdgeInsets.all(10),
          color: Theme.of(context).selectedRowColor,
          child: Column(
            children: [
              /*   TextField(
                enabled: true,
                autofocus: false,
                onSubmitted: (value) {},
                decoration: const InputDecoration(
                  label: Text("Código | Descrição"),
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.qr_code_scanner_rounded),
                ),
              ), */
              Expanded(
                child: BlocBuilder<ProductAddressCubit, ProductAddressState>(
                  builder: (context, state) {
                    if (state is ProductAddresInitial) {
                      return const Center(
                        child: Text("State Initital"),
                      );
                    }
                    if (state is ProductAddressLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state is ProductAddressError) {
                      return Center(
                        child: Text(state.failure.error),
                      );
                    }
                    if (state is ProductAddressLoaded) {
                      final list = state.productAddresList;
                      return ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return AddressCard(
                            data: list[index],
                          );
                        },
                      );
                    }
                    return const Text("Error State");
                  },
                ),
              )
              //Divider(),
            ],
          ),
        ),
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  final ProductAddress data;
  const AddressCard({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddressForm(
                productAddress: data,
              ),
            ),
          );
        },
        title: Text(
          data.descricao,
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Codigo",
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        data.codigo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Saldo",
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        "${data.saldo}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      )
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Lote",
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        data.lote,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Armazem",
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        data.armazem,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
