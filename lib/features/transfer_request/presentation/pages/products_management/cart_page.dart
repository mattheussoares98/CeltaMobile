import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class CartPage extends ConsumerStatefulWidget {
  final DraftKey draftKey;
  final bool requestTypeAllowChangePrice;
  const CartPage({
    super.key,
    required this.draftKey,
    required this.requestTypeAllowChangePrice,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  int? selectedIndex;

  String formatPacking(String value) {
    final firstDigitMatch = RegExp(r'\d').firstMatch(value);

    if (firstDigitMatch == null) {
      return value;
    }

    final index = firstDigitMatch.start;
    final textPart = value.substring(0, index);
    var numberPart = value.substring(index);

    if (numberPart.contains('.')) {
      while (numberPart.endsWith('0')) {
        numberPart = numberPart.substring(0, numberPart.length - 1);
      }

      if (numberPart.endsWith('.')) {
        numberPart = numberPart.substring(0, numberPart.length - 1);
      }
    }

    return '$textPart$numberPart'.replaceAll(RegExp(r'\.'), ',');
  }

  void changeSelectedIndex(int index) {
    if (selectedIndex == index) {
      setState(() {
        selectedIndex = null;
      });
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(insertTransferRequestControllerProvider(widget.draftKey), (
      p,
      n,
    ) {
      n.doOnSuccess(p, () {
        showSnackBarMessage(context, 'Pedido salvo com sucesso'.hardcoded);
      });
    });

    final pendingAsync = ref.watch(
      cartProductsStateControllerProvider(widget.draftKey),
    );

    final lastSavedAsync = ref.watch(lastSavedNumberStateControllerProvider);

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                if (lastSavedAsync.value != null)
                  LastSavedNumber(number: lastSavedAsync.value!),
                SliverList.builder(
                  itemCount: pendingAsync.value?.length ?? 0,
                  itemBuilder: (_, index) {
                    final item = pendingAsync.value![index];

                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  changeSelectedIndex(index);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    Sizes.p8,
                                    Sizes.p8,
                                    0,
                                    Sizes.p8,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TitleAndSubTitle(
                                              title: item.product.Name,
                                              subTitle:
                                                  " (${formatPacking(item.product.PackingQuantity)})",
                                              titleStyle:
                                                  theme.textTheme.titleMedium,
                                              subTitleStyle:
                                                  theme.textTheme.bodyMedium,
                                            ),
                                            TitleAndSubTitle(
                                              title: 'PLU'.hardcoded,
                                              subTitle: item.product.PLU,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  flex: 20,
                                                  child: _ColumnTitleAndValue(
                                                    title: 'Qtd'.hardcoded,
                                                    value: item.quantity,
                                                    isPrice: false,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 35,
                                                  child: _ColumnTitleAndValue(
                                                    title: 'Preço'.hardcoded,
                                                    value: item.value,
                                                    isPrice: true,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 45,
                                                  child: _ColumnTitleAndValue(
                                                    title: 'Total'.hardcoded,
                                                    value:
                                                        item.quantity *
                                                        item.value,
                                                    isPrice: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              showAlertDialog(
                                                context: context,
                                                title:
                                                    'Remover item?'.hardcoded,
                                                cancelActionText:
                                                    'Cancelar'.hardcoded,
                                                defaultActionText:
                                                    'Remover'.hardcoded,
                                                onOkPressed: () {
                                                  ref
                                                      .read(
                                                        cartProductsStateControllerProvider(
                                                          widget.draftKey,
                                                        ).notifier,
                                                      )
                                                      .removeItem(item);
                                                },
                                              );
                                            },
                                            icon: Icon(
                                              isIOS
                                                  ? CupertinoIcons.delete
                                                  : Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                          Icon(
                                            isIOS
                                                ? CupertinoIcons.pencil
                                                : Icons.edit,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (selectedIndex == index) ...[
                                Padding(
                                  padding: const EdgeInsets.all(Sizes.p8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            DefaultTextFormField(
                                              labelText: 'Quantidade'.hardcoded,
                                              hintText: 'Quantidade'.hardcoded,
                                            ),
                                            if (widget
                                                .requestTypeAllowChangePrice)
                                              DefaultTextFormField(
                                                labelText: 'Preço'.hardcoded,
                                                hintText: 'Preço'.hardcoded,
                                              ),
                                          ],
                                        ),
                                      ),
                                      gapW8,
                                      Column(
                                        children: [
                                          Text('Show total price'),
                                          PrimaryButton(
                                            text: 'Alterar'.hardcoded,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                if ((pendingAsync.value?.length ?? 0) > 2) ...[
                  ClearCartButton(draftKey: widget.draftKey),
                  gapSliverH16,
                ],
              ],
            ),
          ),
          Footer(draftKey: widget.draftKey),
        ],
      ),
    );
  }
}

class _ColumnTitleAndValue extends StatelessWidget {
  final String title;
  final double value;
  final bool isPrice;
  const _ColumnTitleAndValue({
    required this.title,
    required this.value,
    required this.isPrice,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.disabledColor,
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              if (isPrice)
                TextSpan(
                  text: "R\$ ".hardcoded,
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                ),
              TextSpan(
                text: value.toString().toBrazilianNumber(2, !isPrice),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
