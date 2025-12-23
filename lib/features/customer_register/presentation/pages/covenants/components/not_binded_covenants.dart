import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/validators/validators.dart';
import '../../../../domain/entities/entities.dart';

class NotBindedCovenants extends StatelessWidget {
  final List<CovenantEntity> notBindedCovenants;
  final void Function(int index) changeSelectedIndex;
  final int? selectedIndex;
  final void Function(CovenantEntity covenant) bindCovenant;
  final TextEditingController limitController;
  final FocusNode limitFocusNode;
  const NotBindedCovenants({
    super.key,
    required this.notBindedCovenants,
    required this.changeSelectedIndex,
    required this.selectedIndex,
    required this.bindCovenant,
    required this.limitController,
    required this.limitFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverList.builder(
      itemCount: notBindedCovenants.length + 1,
      itemBuilder: (_, index) {
        if (index == 0) {
          return DefaultTitle(title: 'Convênios sem vínculo'.hardcoded);
        }

        final covenant = notBindedCovenants[index - 1];

        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  changeSelectedIndex(index);
                },
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.p8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        covenant.Nome_Convenio ?? '',
                        style: theme.textTheme.titleMedium,
                      ),
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
                        child: DefaultTextFormField(
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
                            NonEmptyValidator(),
                            NumberValidator(
                              allowDecimal: true,
                              maxDecimalHouses: 2,
                            ),
                          ]),
                          onFieldSubmitted: (_) {
                            bindCovenant(covenant);
                          },
                        ),
                      ),
                      gapW8,
                      PrimaryButton(
                        text: 'Vincular'.hardcoded,
                        onPressed: () {
                          bindCovenant(covenant);
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
