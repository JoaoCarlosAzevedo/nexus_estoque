import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';
import 'package:nexus_estoque/core/utils/datetime_formatter.dart';

import '../../data/model/carga_group_model.dart';
import '../../providers/cargas_list_provider.dart';
import '../carga_conference_page/carga_conference_page.dart';
import 'widgets/carga_card.dart';

class CargaListPage extends ConsumerStatefulWidget {
  const CargaListPage({super.key});

  @override
  ConsumerState<CargaListPage> createState() => _CargaListPageState();
}

class _CargaListPageState extends ConsumerState<CargaListPage> {
  late String dateIni;
  late String dateEnd;

  @override
  void initState() {
    super.initState();
    dateIni = datetimeToYYYYMMDD(DateTime.now());
    dateEnd = datetimeToYYYYMMDD(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final cargasAsync = ref.watch(cargasListProvider('$dateIni/$dateEnd'));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text("Pedidos x Carga"),
            Text(
              "${yyyymmddToDate(dateIni)} - ${yyyymmddToDate(dateEnd)}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref.invalidate(cargasListProvider);
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () => _pickDateRange(context),
            icon: const Icon(Icons.calendar_month),
          ),
        ],
      ),
      body: cargasAsync.when(
        skipLoadingOnRefresh: false,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(cargasListProvider),
                    child: const Text("Tentar novamente"),
                  ),
                ],
              ),
            ),
          ),
        ),
        data: (cargas) {
          if (cargas.isEmpty) {
            return const Center(
              child: Text("Nenhuma carga encontrada para o período."),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: cargas.length,
            itemBuilder: (context, index) {
              final cargaGroup = cargas[index];
              return CargaCard(
                cargaGroup: cargaGroup,
                onTap: () => _openConference(cargaGroup),
              );
            },
          );
        },
      ),
    );
  }

  void _openConference(CargaGroup cargaGroup) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CargaConferencePage(
          cargaGroup: cargaGroup,
          dateRange: '$dateIni/$dateEnd',
        ),
      ),
    );
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final themeData = Theme.of(context);
    final datePicked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now(),
      ),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: themeData.copyWith(
          datePickerTheme: const DatePickerThemeData(
            rangeSelectionBackgroundColor: AppColors.background,
          ),
          appBarTheme: themeData.appBarTheme.copyWith(
            backgroundColor: Colors.blue,
            iconTheme:
                themeData.appBarTheme.iconTheme!.copyWith(color: Colors.red),
          ),
          colorScheme: const ColorScheme.light(
            onPrimary: Colors.white,
            primary: Colors.grey,
          ),
        ),
        child: child!,
      ),
    );

    if (datePicked == null || !mounted) return;

    setState(() {
      dateIni = datetimeToYYYYMMDD(datePicked.start);
      dateEnd = datetimeToYYYYMMDD(datePicked.end);
    });
  }
}
