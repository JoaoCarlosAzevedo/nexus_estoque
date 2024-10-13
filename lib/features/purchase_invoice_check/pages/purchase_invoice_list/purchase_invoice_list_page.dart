import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';
import 'package:nexus_estoque/features/purchase_invoice_check/pages/purchase_invoice_list/widgets/plate_input_modarl.dart';

import '../../../../core/utils/datetime_formatter.dart';
import '../../data/model/purchase_invoice_model.dart';
import '../../data/repositories/purchase_invoice_repository.dart';
import '../purchase_invoice_products/purchase_invoice_products_page.dart';

class PurchaseInvoiceListPage extends ConsumerStatefulWidget {
  const PurchaseInvoiceListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PurchaseInvoiceListPageState();
}

class _PurchaseInvoiceListPageState
    extends ConsumerState<PurchaseInvoiceListPage> {
  late String dateIni;
  late String dateEnd;
  @override
  void initState() {
    dateIni = datetimeToYYYYMMDD(DateTime.now());
    dateEnd = datetimeToYYYYMMDD(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final futureProvider =
        ref.watch(purchaseInvoicesProvider('$dateIni/$dateEnd'));
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text("Veículos x Notas"),
            Text(
              "${yyyymmddToDate(dateIni)} - ${yyyymmddToDate(dateEnd)}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                ref.invalidate(purchaseInvoicesProvider);
              },
              icon: const Icon(Icons.refresh)),
          IconButton(
              onPressed: () {
                pickeDateRange(context);
              },
              icon: const Icon(Icons.calendar_month)),
        ],
      ),
      body: futureProvider.when(
        skipLoadingOnRefresh: false,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) {
          return Center(child: Text(err.toString()));
        },
        data: (data) {
          if (data.isEmpty) {
            return const Center(
              child: Text("Nenhum registro encontrado."),
            );
          }
          return GroupedListView<PurchaseInvoice, String>(
            elements: data,
            groupBy: (element) => element.getAggregator(),
            groupSeparatorBuilder: (String groupByValue) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Card(
                    shape: Border(
                      left: BorderSide(
                          color: statusInvoices(data
                                  .where((element) => element
                                      .getAggregator()
                                      .contains(groupByValue))
                                  .toList())
                              ? Colors.green
                              : Colors.red,
                          width: 5),
                    ),
                    child: ListTile(
                      onTap: isEditable(groupByValue)
                          ? null
                          : () {
                              redirect(data
                                  .where((element) => element
                                      .getAggregator()
                                      .contains(groupByValue))
                                  .toList());
                            },
                      leading: FaIcon(
                        FontAwesomeIcons.truck,
                        color: isEditable(groupByValue) ? Colors.red : null,
                      ),
                      title: Text(
                        groupByValue,
                        overflow: TextOverflow.visible,
                      ),
                      trailing: isEditable(groupByValue)
                          ? IconButton(
                              onPressed: () async {
                                showPlateInputModal(
                                    context,
                                    data
                                        .where((element) => element
                                            .getAggregator()
                                            .contains(groupByValue))
                                        .toList());
                              },
                              icon: const FaIcon(
                                FontAwesomeIcons.penToSquare,
                                color: Colors.green,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
              );
            },
            itemBuilder: (context, PurchaseInvoice element) {
              return const Visibility(
                visible: false,
                child: Text(""),
              );
            },
            useStickyGroupSeparators: true, // optional
            floatingHeader: true, // optional
            order: GroupedListOrder.ASC, // optional
          );
        },
      ),
    );
  }

  bool statusInvoices(List<PurchaseInvoice> invoices) {
    for (var invoice in invoices) {
      for (var product in invoice.purchaseInvoiceProducts) {
        if (product.checkedBd < product.quantidade) {
          return false;
        }
      }
    }
    return true;
  }

  void redirect(List<PurchaseInvoice> invoices) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PurchaseInvoiceProdutcts(
          invoices: invoices,
        ),
      ),
    );
  }

  bool isEditable(String value) {
    if (value.trim().contains('CARGA')) {
      return true;
    }
    return false;
  }

  Future pickeDateRange(BuildContext ctx) async {
    final DateTimeRange dateRange =
        DateTimeRange(start: DateTime.now(), end: DateTime.now());

    final themeData = Theme.of(context);
    DateTimeRange? datePicked = await showDateRangePicker(
        context: context,
        initialDateRange: dateRange,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        builder: (context, Widget? child) => Theme(
              data: themeData.copyWith(
                datePickerTheme: const DatePickerThemeData(
                    rangeSelectionBackgroundColor: AppColors.background),
                appBarTheme: themeData.appBarTheme.copyWith(
                    backgroundColor: Colors.blue,
                    iconTheme: themeData.appBarTheme.iconTheme!
                        .copyWith(color: Colors.red)),
                colorScheme: const ColorScheme.light(
                  onPrimary: Colors.white,
                  primary: Colors.grey,
                  //surface: Colors.green,
                ),
              ),
              child: child!,
            ));

    if (datePicked == null) return;

    setState(() {
      dateIni = datetimeToYYYYMMDD(datePicked.start);
      dateEnd = datetimeToYYYYMMDD(datePicked.end);
    });
  }
}
