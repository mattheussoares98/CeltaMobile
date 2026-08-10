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
    return AsyncValueWidget(
      value: ref.watch(enterprisesStateControllerProvider()),
      tryAgain: null,
      errorMaxLines: 1,
      data: (enterprises) {
        final items = enterprises
            .map((e) {
              // Keep it simple: a single Text is much cheaper than RichText/TextSpan
              final text =
                  '${e.PersonalizedCode} - ${e.name} (${e.CnpjNumber})';

              return DropdownMenuItem<EnterpriseEntity>(
                value: e,
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.theme.textTheme.titleSmall,
                ),
              );
            })
            .toList(growable: false);

        return Consumer(
          builder: (context, ref, child) {
            final selectedEnterprise = enterprises.firstWhereOrNull(
              (e) => e.Code == enterpriseCode,
            );
            return RepaintBoundary(
              child: BaseDropDown<EnterpriseEntity>(
                hint: Text('Selecione a empresa'.hardcoded),
                selectedItem: selectedEnterprise,
                label: selectedEnterprise != null
                    ? '${selectedEnterprise.PersonalizedCode} - ${selectedEnterprise.name}'
                    : null,
                onChanged: (enterprise) async {
                  onChange(enterprise.Code);
                },
                items: items,
              ),
            );
          },
        );
      },
    );
  }
}
