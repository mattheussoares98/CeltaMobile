import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/customer_register/domain/entities/entities.dart';
import 'package:celta_inventario/features/customer_register/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotBindedCovenants extends ConsumerWidget {
  final List<CovenantEntity>? covenants;
  final void Function(int index) changeSelectedIndex;
  final int? selectedIndex;
  final void Function(CovenantEntity covenant) bindCovenant;
  final TextEditingController limitController;
  final FocusNode limitFocusNode;
  const NotBindedCovenants({
    super.key,
    required this.covenants,
    required this.changeSelectedIndex,
    required this.selectedIndex,
    required this.bindCovenant,
    required this.limitController,
    required this.limitFocusNode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerCovenants = ref.watch(
      customerStateControllerProvider.select((s) => s.value?.CustomerCovenants),
    );

    final notBindedCovenants = covenants
        ?.where(
          (e) =>
              customerCovenants
                  ?.where(
                    (x) =>
                        e.CodigoInterno_Convenio?.toInt() == x.covenant?.Code,
                  )
                  .toList()
                  .isEmpty !=
              false,
        )
        .toList();

    if (notBindedCovenants == null || notBindedCovenants.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverList.builder(
      itemCount: notBindedCovenants.length + 1,
      itemBuilder: (_, index) {
        if (index == 0) {
          return BaseText.headline(
            'Convênios sem vínculo'.hardcoded,
            textAlign: TextAlign.center,
          );
        }

        final covenant = notBindedCovenants[index - 1];

        return _CovenantItem(
          key: ValueKey('${covenant.Codigo_Convenio}'),
          changeSelectedIndex: changeSelectedIndex,
          covenant: covenant,
          selectedIndex: selectedIndex,
          limitController: limitController,
          limitFocusNode: limitFocusNode,
          bindCovenant: bindCovenant,
          index: index,
        );
      },
    );
  }
}

class _CovenantItem extends StatelessWidget {
  final void Function(int index) changeSelectedIndex;
  final CovenantEntity covenant;
  final int? selectedIndex;
  final TextEditingController limitController;
  final FocusNode limitFocusNode;
  final void Function(CovenantEntity covenant) bindCovenant;
  final int index;
  const _CovenantItem({
    super.key,
    required this.changeSelectedIndex,
    required this.covenant,
    required this.selectedIndex,
    required this.limitController,
    required this.limitFocusNode,
    required this.bindCovenant,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isIOS = PlatformUtil.isCupertino;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: isIOS ? null : () => changeSelectedIndex(index),
            child: Padding(
              padding: const EdgeInsets.all(Sizes.p8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BaseText.titleMedium(covenant.Nome_Convenio ?? ''),
                  TitleAndSubTitle(
                    title: 'CNPJ '.hardcoded,
                    subTitle: covenant.Cnpj_Convenio,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TitleAndSubTitle(
                          title: 'Endereço '.hardcoded,
                          subTitle:
                              "${covenant.Logradouro_Convenio}, ${covenant.NumEndereco_Convenio}",
                        ),
                      ),
                      SelectedIconIndicator(
                        selected: selectedIndex == index,
                        onTap: () => changeSelectedIndex(index),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (selectedIndex == index)
            Padding(
              padding: const EdgeInsets.all(Sizes.p8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: BaseTextFormField(
                      controller: limitController,
                      focusNode: limitFocusNode,
                      labelText: 'Limite R\$'.hardcoded,
                      hintText: 'Limite R\$'.hardcoded,
                      maxLength: 12,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: FormValidators.compose([
                        const NonEmptyValidator(),
                        NumberValidator(allowDecimal: true),
                      ]),
                      onFieldSubmitted: (_) {
                        bindCovenant(covenant);
                      },
                    ),
                  ),
                  gapW16,
                  Flexible(
                    child: PrimaryButton(
                      text: 'Vincular'.hardcoded,
                      onPressed: () => bindCovenant(covenant),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
