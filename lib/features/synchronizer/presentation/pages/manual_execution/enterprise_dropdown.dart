part of './synchronizer_manual_execution_page.dart';

class _EnterpriseDropdown extends ConsumerWidget {
  const _EnterpriseDropdown({
    required this.enterpriseCode,
    required this.onChange,
  });
  final int? enterpriseCode;
  final void Function(int? enterpriseCode) onChange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterprises = ref.watch(enterprisesStateControllerProvider()).value;
    return AsyncValueWidget(
      value: ref.watch(manualExecutionEnterprisesStateControllerProvider),
      tryAgain: null,
      errorMaxLines: 1,
      data: (synchronizerEnterprises) {
        final items = synchronizerEnterprises
            .map((item) {
              // Keep it simple: a single Text is much cheaper than RichText/TextSpan
              final enterprise = enterprises?.firstWhereOrNull(
                (e) => e.Code == item.code,
              );
              final text = enterprise != null
                  ? '(${enterprise.PersonalizedCode}) - ${item.name}'
                  : item.name;

              return DropdownMenuItem<ManualExecutionEnterpriseEntity>(
                value: item,
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.theme.textTheme.titleSmall,
                ),
              );
            })
            .toList(growable: false);

        final selectedEnterprise = synchronizerEnterprises.firstWhereOrNull(
          (e) => e.code == enterpriseCode,
        );

        return BaseDropDown<ManualExecutionEnterpriseEntity>(
          hint: Text(context.l10n.selectTheCompany),
          selectedItem: selectedEnterprise,
          label: selectedEnterprise?.name,
          onChanged: (enterprise) async {
            onChange(enterprise.code);
          },
          items: items,
        );
      },
    );
  }
}
