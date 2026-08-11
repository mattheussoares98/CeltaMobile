import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/presentation/controllers/enterprises/enterprises.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part './enterprise_dropdown.dart';

class SynchronizerManualExecutionPage extends ConsumerStatefulWidget {
  const SynchronizerManualExecutionPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ManualExecutionPageState();
}

class _ManualExecutionPageState
    extends ConsumerState<SynchronizerManualExecutionPage> {
  int? enterpriseCode;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      isScrollable: false,
      usePadding: false,
      refreshProvider: enterpriseCode == null
          ? null
          : manualExecutionSchedulesStateControllerProvider(enterpriseCode!),
      appBar: BaseAppBar(
        titleWidget: _EnterpriseDropdown(
          enterpriseCode: enterpriseCode,
          onChange: (code) => setState(() => enterpriseCode = code),
        ),
      ),
      body: enterpriseCode == null
          ? const SizedBox.shrink()
          : AsyncValueWidget(
              value: ref.watch(
                manualExecutionEnterprisesStateControllerProvider,
              ),
              tryAgain: () => ref.invalidate(
                manualExecutionEnterprisesStateControllerProvider,
              ),
              data: (enterprises) {
                return Consumer(
                  builder: (_, ref, _) {
                    final provider =
                        manualExecutionSchedulesStateControllerProvider(
                          enterpriseCode!,
                        );

                    return AsyncValueWidget(
                      value: ref.watch(provider),
                      tryAgain: () => ref.invalidate(provider),
                      data: (schedules) {
                        return ListView.separated(
                          separatorBuilder: (_, _) => const Divider(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: Sizes.p8,
                          ),
                          itemCount: schedules.length,
                          itemBuilder: (context, index) {
                            final schedule = schedules[index];
                            return Consumer(
                              builder: (_, ref, _) {
                                final provider =
                                    executeManualScheduleControllerProvider(
                                      enterpriseCode: enterpriseCode!,
                                      scheduleCode: schedule.code,
                                    );
                                final (isLoading, errorMessage) = ref.watch(
                                  provider.select(
                                    (s) => (s.isLoading, s.error?.toString()),
                                  ),
                                );

                                return Column(
                                  crossAxisAlignment: .stretch,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: .start,
                                            children: [
                                              BaseText.title(schedule.name),
                                              if (schedule
                                                      .dateOfLastExecution !=
                                                  null)
                                                BaseText(
                                                  schedule.dateOfLastExecution!
                                                      .formatDate(
                                                        .ddMMyyyyHHmm,
                                                      ),
                                                  color: context
                                                      .theme
                                                      .disabledColor,
                                                ),
                                            ],
                                          ),
                                        ),
                                        PrimaryTextButton(
                                          isLoading: ref.watch(
                                            provider.select((s) => s.isLoading),
                                          ),
                                          text: 'Executar'.hardcoded,
                                          onPressed: ref
                                              .read(provider.notifier)
                                              .execute,
                                        ),
                                      ],
                                    ),
                                    if (errorMessage != null)
                                      BaseText.error(errorMessage),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
