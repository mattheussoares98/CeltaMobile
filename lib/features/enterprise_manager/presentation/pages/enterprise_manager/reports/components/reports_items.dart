import 'dart:async';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/localization/localization.dart';
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
            child: Center(child: BaseText(context.l10n.noUsageFound)),
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
                        (r.usageType == null
                                ? null
                                : context.l10n.usageName(r.usageType!))
                            ?.toLowerCase()
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
            child: Center(child: BaseText(context.l10n.noResultsFound)),
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
                      child: BaseText(
                        context.l10n.customersCount(filteredEnterprises.length),
                      ),
                    ),
                    gapW8,
                    Flexible(
                      flex: 2,
                      child: BaseText(
                        context.l10n.requestsCount(totalRequests),
                      ),
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
              child: ExpansionTile(
                title: BaseText.titleMedium(
                  '${enterpriseName?.toUpperCase()} (${total.toString().toBrazilianNumber(0)})',
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Sizes.p8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                ],
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
            (e) => groupingByType
                ? (e.usageType == null
                      ? null
                      : context.l10n.usageName(e.usageType!))
                : e.userName,
          ).entries.map((entry) {
            final name = entry.key;
            final total = entry.value.fold(0, (sum, r) => sum + r.requestCount);
            return (name: name, total: total);
          }).toList()
          ..sort((a, b) => b.total.compareTo(a.total));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseText.title(
          groupingByType
              ? context.l10n.requestsByType
              : context.l10n.requestsByUser,
          color: context.theme.primaryColor,
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
                child: Chip(label: BaseText('${t.name}-${t.total}')),
              );
            }),
          ],
        ),
      ],
    );
  }
}
