import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/features/enterprise_manager/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StartAndEndDate extends ConsumerWidget {
  const StartAndEndDate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: ResponsiveCenter(
        maxContentWidth: Breakpoint.tablet,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [const _SelectPeriod(), gapH8, _UpdateButton()],
        ),
      ),
    );
  }
}

class _UpdateButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PrimaryButton(
      text: 'Atualizar'.hardcoded,
      isLoading: ref.watch(
        appUsageStateControllerProvider.select((s) => s.isLoading),
      ),
      onPressed: () async {
        ref
            .read(appUsageStateControllerProvider.notifier)
            .loadRemoteUsageReport(
              ref.read(reportPeriodStateControllerProvider),
            );
      },
    );
  }
}

class _SelectPeriod extends ConsumerWidget {
  const _SelectPeriod();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();

    return Column(
      children: [
        DefaultText('Mês/ano'.hardcoded),
        Row(
          children: [
            Flexible(
              child: Consumer(
                builder: (_, ref, _) {
                  return BaseDropDown<int>(
                    onChanged: (month) => ref
                        .read(reportPeriodStateControllerProvider.notifier)
                        .update(startMonth: month),
                    items: List.generate(
                      12,
                      (index) => DropdownMenuItem(
                        value: index + 1,
                        child: DefaultText('${index + 1}'),
                      ),
                    ),
                    selectedItem: ref.watch(
                      reportPeriodStateControllerProvider.select(
                        (s) => s.month,
                      ),
                    ),
                    label: '',
                    isSimple: true,
                  );
                },
              ),
            ),
            gapW8,
            Flexible(
              flex: 2,
              child: Consumer(
                builder: (_, ref, _) {
                  return BaseDropDown<int>(
                    onChanged: (year) => ref
                        .read(reportPeriodStateControllerProvider.notifier)
                        .update(startYear: year),
                    items: List.generate(
                      2,
                      (index) => DropdownMenuItem(
                        value: now.year - index,
                        child: DefaultText('${now.year - index}'),
                      ),
                    ),
                    selectedItem: ref.watch(
                      reportPeriodStateControllerProvider.select((s) => s.year),
                    ),
                    label: '',
                    isSimple: true,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
