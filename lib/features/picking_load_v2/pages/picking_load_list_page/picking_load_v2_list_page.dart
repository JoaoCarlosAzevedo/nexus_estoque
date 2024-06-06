import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/features/picking_load_v2/pages/picking_load_list_page/cubit/picking_loadv2_cubit.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/datetime_formatter.dart';
import '../../data/model/shippingv2_model.dart';
import '../../data/repositories/pickingv2_repository.dart';
import 'widgets/picking_load_v2_list_widget.dart';

class PickingLoadListPagev2 extends ConsumerStatefulWidget {
  const PickingLoadListPagev2({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PickingLoadListPagev2State();
}

class _PickingLoadListPagev2State extends ConsumerState<PickingLoadListPagev2> {
  bool filterFaturado = false;

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
    return BlocProvider(
      create: (context) => PickingLoadv2Cubit(
          ref.read(pickingv2RepositoryProvider), dateIni, dateEnd),
      child: BlocBuilder<PickingLoadv2Cubit, PickingLoadv2State>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Column(
                children: [
                  const Text("Cargas"),
                  Text(
                    "${yyyymmddToDate(dateIni)} - ${yyyymmddToDate(dateEnd)}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      context
                          .read<PickingLoadv2Cubit>()
                          .fetchPickingLoads(dateIni, dateEnd);
                    },
                    icon: const Icon(Icons.refresh)),
                IconButton(
                    onPressed: () async {
                      await pickeDateRange(context);
                      context
                          .read<PickingLoadv2Cubit>()
                          .fetchPickingLoads(dateIni, dateEnd);
                    },
                    icon: const Icon(Icons.calendar_month))
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<PickingLoadv2Cubit, PickingLoadv2State>(
                  builder: (context, state) {
                    if (state is PickingLoadv2Loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state is PickingLoadv2Error) {
                      return Center(
                        child: Text(state.error.error),
                      );
                    }

                    if (state is PickingLoadv2Loaded) {
                      String load = "";

                      if (state.load.isNotEmpty) {
                        load = state.load;
                      }

                      List<Shippingv2Model> data = state.loads;

                      return PickingLoadV2ListWidget(
                        data: data,
                        load: load,
                        dateIni: dateIni,
                        dateEnd: dateEnd,
                      );
                    }
                    return const Text("Initial");
                  },
                ),
              ),
            ),
          );
        },
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
