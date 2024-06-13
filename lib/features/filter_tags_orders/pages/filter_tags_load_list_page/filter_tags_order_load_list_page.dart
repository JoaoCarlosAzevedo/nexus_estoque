import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';

import '../../../../core/utils/datetime_formatter.dart';
import '../../../filter_tags/data/repositories/filter_tag_repository.dart';
import 'widgets/filter_tags_order_card_widget.dart';

class FilterTagsOrderLoadListPage extends ConsumerStatefulWidget {
  const FilterTagsOrderLoadListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FilterTagsOrderLoadListPageState();
}

class _FilterTagsOrderLoadListPageState
    extends ConsumerState<FilterTagsOrderLoadListPage> {
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
    final futureProvider = ref.watch(allLoadsProvider('$dateIni/$dateEnd'));
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text("Lista Cargas"),
            Text(
              "${yyyymmddToDate(dateIni)} - ${yyyymmddToDate(dateEnd)}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                ref.invalidate(allLoadsProvider);
              },
              icon: const Icon(Icons.refresh)),
          IconButton(
              onPressed: () {
                pickeDateRange(context);
              },
              icon: const Icon(Icons.calendar_month)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: futureProvider.when(
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
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return LoadSimpleCardWidget(
                  load: data[index],
                  onTap: () {
                    context.push(
                      '/etiqueta_filtros_pedidos/${data[index].load}',
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
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
