import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus_estoque/features/filter_tags/pages/filter_tags_invoice_products_page/filter_tag_tab2.dart';

import '../filter_tags_load_page/cubit/filter_tag_load_cubit.dart';
import 'filter_tag_tab1.dart';

class FilterTagsInvoiceProductsPage extends ConsumerStatefulWidget {
  const FilterTagsInvoiceProductsPage({required this.cubit, super.key});

  final FilterTagLoadCubit cubit;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FilterTagsInvoiceProductsPageState();
}

class _FilterTagsInvoiceProductsPageState
    extends ConsumerState<FilterTagsInvoiceProductsPage> {
  bool filterFaturado = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Seleção de Produtos"),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Row(
                  children: [
                    Text("Produtos NF"),
                    SizedBox(
                      width: 10,
                    ),
                    FaIcon(
                      FontAwesomeIcons.clipboardCheck,
                    ),
                  ],
                ),
              ),
              Tab(
                icon: Row(
                  children: [
                    Text("Embalagem"),
                    SizedBox(
                      width: 10,
                    ),
                    FaIcon(
                      FontAwesomeIcons.boxOpen,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: BlocProvider.value(
            value: widget.cubit,
            child: BlocListener<FilterTagLoadCubit, FilterTagLoadState>(
              listener: (context, state) {
                if (state is FilterTagLoadLoaded) {
                  if (state.selectedInvoice == null) {
                    Navigator.pop(context);
                  }
                }
              },
              child: BlocBuilder<FilterTagLoadCubit, FilterTagLoadState>(
                builder: (context, state) {
                  if (state is FilterTagLoadError) {
                    return const Center(
                      child: Text("Error"),
                    );
                  }
                  if (state is FilterTagLoadLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is FilterTagLoadInitial) {
                    return const Center(
                      child: Text("Invalid State"),
                    );
                  }

                  if (state is FilterTagLoadLoaded) {
                    if (state.selectedInvoice == null) {
                      return const Center(
                        child: Text("Selecione a NF"),
                      );
                    }

                    return TabBarView(
                      children: [
                        FilterTagTab1(invoice: state.selectedInvoice!),
                        FilterTagTab2(invoice: state.selectedInvoice!),
                      ],
                    );
                  }
                  return const Center(
                    child: Text("Invalid state!"),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
