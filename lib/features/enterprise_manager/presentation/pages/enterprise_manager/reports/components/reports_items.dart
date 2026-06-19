import 'dart:async';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportsItems extends ConsumerStatefulWidget {
  final TextEditingController enterpriseController;
  final TextEditingController usageTypeController;
  const ReportsItems({
    super.key,
    required this.enterpriseController,
    required this.usageTypeController,
  });

  @override
  ConsumerState<ReportsItems> createState() => _ReportsItemsState();
}

class _ReportsItemsState extends ConsumerState<ReportsItems> {
  String _enterpriseFilter = '';
  String _usageTypeFilter = '';
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    widget.enterpriseController.addListener(_onFilterChanged);
    widget.usageTypeController.addListener(_onFilterChanged);
  }

  @override
  void dispose() {
    widget.enterpriseController.removeListener(_onFilterChanged);
    widget.usageTypeController.removeListener(_onFilterChanged);
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onFilterChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 250), () {
      if (mounted) {
        setState(() {
          _enterpriseFilter = widget.enterpriseController.text;
          _usageTypeFilter = widget.usageTypeController.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AsyncValueWidget(
      isSliver: true,
      value: ref.watch(appUsageStateControllerProvider),
      tryAgain: null,
      data: (usageReports) {
        if (usageReports?.isEmpty ?? true) {
          return SliverToBoxAdapter(
            child: Center(child: Text('Nenhum uso encontrado'.hardcoded)),
          );
        }

        final filterEnterprise = _enterpriseFilter
            .toLowerCase()
            .removeWhiteSpaces();
        final filterUsage = _usageTypeFilter.toLowerCase().removeWhiteSpaces();

        final filteredEnterprises =
            usageReports!
                .where((e) {
                  final enterpriseName = e.enterpriseName!
                      .toLowerCase()
                      .removeWhiteSpaces();
                  return _enterpriseFilter.isEmpty ||
                      enterpriseName.contains(filterEnterprise);
                })
                .map((e) {
                  if (_usageTypeFilter.isEmpty) {
                    return e;
                  }
                  final filteredRequests = e.requests.where((r) {
                    final usageTypeDesc =
                        r.usageType?.description
                            .toLowerCase()
                            .removeWhiteSpaces() ??
                        '';
                    return usageTypeDesc.contains(filterUsage);
                  }).toList();
                  return e.copyWith(usages: filteredRequests);
                })
                .where((e) => e.requests.isNotEmpty)
                .toList()
              ..sort((a, b) {
                final aTotal = a.requests.fold<int>(
                  0,
                  (p, n) => p + n.requestCount,
                );
                final bTotal = b.requests.fold<int>(
                  0,
                  (p, n) => p + n.requestCount,
                );
                return bTotal.compareTo(aTotal);
              });

        if (filteredEnterprises.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(child: Text('Nenhum resultado encontrado'.hardcoded)),
          );
        }

        final totalRequests = filteredEnterprises
            .expand((e) => e.requests)
            .fold<int>(0, (p, n) => p + n.requestCount);

        return SliverList.builder(
          itemCount: filteredEnterprises.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        '${filteredEnterprises.length} clientes'.hardcoded,
                      ),
                    ),
                    gapW8,
                    Flexible(
                      flex: 2,
                      child: Text('$totalRequests requisições'.hardcoded),
                    ),
                  ],
                ),
              );
            }

            final e = filteredEnterprises[index - 1];
            final enterpriseName = e.enterpriseName;
            final requests = e.requests;
            final total = requests.fold<int>(0, (p, n) => p + n.requestCount);

            return Card(
              margin: const EdgeInsets.symmetric(vertical: Sizes.p4),
              child: Padding(
                padding: const EdgeInsets.all(Sizes.p8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${enterpriseName?.toUpperCase()} (${total.toString().toBrazilianNumber(0)})',
                      style: context.theme.textTheme.titleMedium,
                    ),
                    _RequestsByTypeOrUser(
                      groupingByType: true,
                      reports: requests,
                    ),
                    const Divider(),
                    _RequestsByTypeOrUser(
                      groupingByType: false,
                      reports: requests,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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
    final groupedValues =
        groupBy(
            reports,
            (e) => groupingByType ? e.usageType?.description : e.userName,
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
          style: context.theme.textTheme.titleSmall?.copyWith(
            color: context.theme.primaryColor,
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
