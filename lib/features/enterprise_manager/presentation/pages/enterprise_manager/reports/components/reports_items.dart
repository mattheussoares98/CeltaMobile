import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../core/presentation/controllers/app_usage/app_usage.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../../../utils/utils.dart';

class ReportsItems extends ConsumerStatefulWidget {
  const ReportsItems({super.key});

  @override
  ConsumerState<ReportsItems> createState() => _ReportsItemsState();
}

class _ReportsItemsState extends ConsumerState<ReportsItems> {
  final filterController = TextEditingController();

  @override
  void dispose() {
    filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        DefaultTextFormField(
          controller: filterController,
          hintText: 'Filtrar empresa|usuário|tipo'.hardcoded,
          labelText: 'Filtrar'.hardcoded,
        ),
        Expanded(
          child: AsyncValueWidget(
            value: ref.watch(appUsageStateControllerProvider),
            tryAgain: null,
            data: (usageReports) {
              if (usageReports?.isEmpty ?? true) {
                return Center(child: Text('Nenhum uso encontrado'.hardcoded));
              }

              return AnimatedBuilder(
                animation: filterController,
                builder: (_, _) {
                  final usageByEnterprise = groupBy(
                    usageReports!.nonNulls.where((e) {
                      final filter = filterController.text
                          .toLowerCase()
                          .removeWhiteSpaces();
                      final enterpriseName = e.enterpriseName!
                          .toLowerCase()
                          .removeWhiteSpaces();

                      return filterController.text.isEmpty ||
                          enterpriseName.contains(filter);
                    }),
                    (e) => e.enterpriseName!,
                  );

                  final groupEntries = usageByEnterprise.entries.toList()
                    ..sort((a, b) => a.key.compareTo(b.key));
                  final totalRequests = groupEntries.fold<int>(
                    0,
                    (sum, e) =>
                        sum +
                        e.value.fold<int>(0, (sum, r) => sum + r.requestCount),
                  );

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              '${groupEntries.length} clientes'.hardcoded,
                            ),
                          ),
                          gapW8,
                          Flexible(
                            flex: 2,
                            child: Text('$totalRequests requisições'.hardcoded),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ResponsiveListFlow(
                          itemCount: groupEntries.length,
                          itemBuilder: (_, enterpriseIndex) {
                            final enterpriseName =
                                groupEntries[enterpriseIndex].key;
                            final reports = groupEntries[enterpriseIndex].value;

                            final typeTotals =
                                groupBy(
                                    reports,
                                    (e) => e.usageType,
                                  ).entries.map((entry) {
                                    final type = entry.key;
                                    final total = entry.value.fold<int>(
                                      0,
                                      (sum, r) => sum + r.requestCount,
                                    );
                                    return (
                                      name: type.description,
                                      total: total,
                                    );
                                  }).toList()
                                  ..sort((a, b) => b.total.compareTo(a.total));

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                vertical: Sizes.p4,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(Sizes.p8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${enterpriseName.toUpperCase()} (${typeTotals.fold<int>(0, (s, t) => s + t.total).toString().toBrazilianNumber(0)})',
                                      style: theme.textTheme.titleMedium,
                                    ),

                                    _RequestsByTypeOrUser(
                                      groupingByType: true,
                                      reports: reports,
                                    ),
                                    const Divider(),
                                    _RequestsByTypeOrUser(
                                      groupingByType: false,
                                      reports: reports,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RequestsByTypeOrUser extends StatelessWidget {
  final bool groupingByType;
  final List<AppUsageEntity> reports;
  const _RequestsByTypeOrUser({
    required this.groupingByType,
    required this.reports,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groupedValues =
        groupBy(
            reports,
            (e) => groupingByType ? e.usageType.description : e.userName,
          ).entries.map((entry) {
            final name = entry.key;
            final total = entry.value.fold(0, (sum, r) => sum + r.requestCount);
            return (name: name, total: total);
          }).toList()
          ..sort((a, b) => b.total.compareTo(a.total));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          groupingByType
              ? 'Requisições por tipo'.hardcoded
              : 'Requisições por usuário'.hardcoded,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.primaryColor,
          ),
        ),
        gapH4,
        Wrap(
          children: [
            ...groupedValues.map((t) {
              return Padding(
                padding: const EdgeInsets.only(
                  right: Sizes.p4,
                  bottom: Sizes.p4,
                ),
                child: Chip(label: Text('${t.name}-${t.total}')),
              );
            }),
          ],
        ),
      ],
    );
  }
}
