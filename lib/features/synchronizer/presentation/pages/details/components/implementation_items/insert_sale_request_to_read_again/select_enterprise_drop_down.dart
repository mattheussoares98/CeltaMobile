part of 'insert_sale_request_to_read_again_modal.dart';

class _SelectEnterpriseDropDown extends ConsumerWidget {
  const _SelectEnterpriseDropDown({
    required this.selectedEnterprise,
    required this.onChangeEnterprise,
  });
  final EnterpriseEntity? selectedEnterprise;
  final void Function(EnterpriseEntity) onChangeEnterprise;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: ref.watch(enterprisesStateControllerProvider()),
      tryAgain: null,
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

        return BaseDropDown<EnterpriseEntity>(
          validator: (value) =>
              value == null ? 'Selecione a empresa'.hardcoded : null,
          hint: Text(
            selectedEnterprise != null
                ? '${selectedEnterprise!.PersonalizedCode} - ${selectedEnterprise!.name}'
                : 'Selecione a empresa'.hardcoded,
          ),
          showLabelAtTopLeft: true,
          selectedItem: selectedEnterprise,
          label: 'Empresa'.hardcoded,
          onChanged: onChangeEnterprise,
          items: items,
        );
      },
    );
  }
}
