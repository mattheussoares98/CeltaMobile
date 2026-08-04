part of 'insert_sale_request_to_read_again_modal.dart';

class _SelectCommerceSiteDropDown extends ConsumerWidget {
  const _SelectCommerceSiteDropDown({
    required this.selectedCommerceSite,
    required this.onChangeCommerceSite,
    required this.enterpriseCode,
  });
  final EcCommerceSiteEntity? selectedCommerceSite;
  final void Function(EcCommerceSiteEntity) onChangeCommerceSite;
  final int? enterpriseCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (enterpriseCode == null) return const SizedBox();

    return AsyncValueWidget(
      value: ref.watch(commerceSitesStateControllerProvider(enterpriseCode!)),
      tryAgain: () =>
          ref.invalidate(commerceSitesStateControllerProvider(enterpriseCode!)),
      data: (commerceSites) {
        final items = commerceSites
            .map((e) {
              return DropdownMenuItem<EcCommerceSiteEntity>(
                value: e,
                child: Text(
                  e.environmentName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.theme.textTheme.titleSmall,
                ),
              );
            })
            .toList(growable: false);

        return BaseDropDown<EcCommerceSiteEntity>(
          validator: (value) =>
              value == null ? 'Selecione o site'.hardcoded : null,
          hint: Text('Site'.hardcoded),
          showLabelAtTopLeft: true,
          selectedItem: selectedCommerceSite,
          label: 'Site'.hardcoded,
          onChanged: onChangeCommerceSite,
          items: items,
        );
      },
    );
  }
}
