import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/validators/validators.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/controllers.dart';

class LotItems extends ConsumerWidget {
  final List<ProductLotInfoEntity> items;
  final int? selectedIndex;
  final void Function(int index, double quantity) changeSelectedIndex;
  final TextEditingController quantityController;
  final FocusNode quantityFocusNode;
  final int enterpriseCode;
  final EnterpriseEntity? selectedEnterprise;

  const LotItems({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.changeSelectedIndex,
    required this.quantityController,
    required this.quantityFocusNode,
    required this.enterpriseCode,
    required this.selectedEnterprise,
  });

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bool isIos = theme.platform == TargetPlatform.iOS;
    final mediaQuery = MediaQuery.of(context);

    void onSubmit(int index, ProductLotInfoEntity item) {
      if (_formKey.currentState?.validate() != true) {
        return;
      }
      ref
          .read(
            lotStateControllerProvider(
              enterpriseCode,
              selectedEnterprise?.name ?? '',
            ).notifier,
          )
          .addItem(item.copyWith(quantity: quantityController.text.toDouble()));
      changeSelectedIndex(index, 0);
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (_, index) {
        final item = items[index];
        return Padding(
          padding: EdgeInsets.only(
            bottom: (index == items.length - 1) ? Sizes.p32 : 0,
          ),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => changeSelectedIndex(index, item.quantity),
              child: Padding(
                padding: const EdgeInsets.all(Sizes.p8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleAndSubTitle(
                      title: null,
                      subTitle: "${item.product.Name} (${item.product.PLU})",
                    ),
                    TitleAndSubTitle(
                      title: 'Just '.hardcoded,
                      subTitle: item.selectedJustification.Descricao_JustMov,
                    ),
                    TitleAndSubTitle(
                      title: 'De '.hardcoded,
                      subTitle: item.selectedOriginStock.Nome_TipoEstoque,
                    ),
                    TitleAndSubTitle(
                      title: 'Para '.hardcoded,
                      subTitle: item.selectedDestinyStock.Nome_TipoEstoque,
                    ),
                    if (selectedIndex == index) gapH8,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: selectedIndex == index
                              ? Form(
                                  key: _formKey,
                                  child: DefaultTextFormField(
                                    controller: quantityController,
                                    focusNode: quantityFocusNode,
                                    maxLength: 10,
                                    hintText: 'Nova qtd'.hardcoded,
                                    labelText: 'Nova qtd'.hardcoded,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                          decimal: true,
                                          //TODO test in iOS
                                        ),
                                    onFieldSubmitted: (_) {
                                      onSubmit(index, item);
                                    },
                                    suffixIcon: mediaQuery.size.width > 300
                                        ? IconButton(
                                            icon: Icon(
                                              isIos
                                                  ? CupertinoIcons.checkmark
                                                  : Icons.check,
                                            ),
                                            onPressed: () =>
                                                onSubmit(index, item),
                                          )
                                        : null,
                                    validator: FormValidators.compose([
                                      NonEmptyValidator(),
                                      NumberValidator(
                                        allowDecimal: true,
                                        maxDecimalHouses: 3,
                                      ),
                                    ]),
                                  ),
                                )
                              : TitleAndSubTitle(
                                  title: 'Qtd '.hardcoded,
                                  subTitle: item.quantity
                                      .toString()
                                      .toBrazilianNumber(3),
                                ),
                        ),
                        IconButton(
                          onPressed: () =>
                              changeSelectedIndex(index, item.quantity),
                          icon: Icon(
                            isIos ? CupertinoIcons.pencil : Icons.edit_outlined,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showAlertDialog(
                              context: context,
                              title: 'Remover item?'.hardcoded,
                              cancelActionText: 'Cancelar'.hardcoded,
                              defaultActionText: 'Remover'.hardcoded,
                              onOkPressed: () {
                                ref
                                    .read(
                                      lotStateControllerProvider(
                                        enterpriseCode,
                                        selectedEnterprise?.name ?? '',
                                      ).notifier,
                                    )
                                    .removeItem(item);
                              },
                            );
                          },
                          icon: Icon(
                            isIos ? CupertinoIcons.delete : Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
