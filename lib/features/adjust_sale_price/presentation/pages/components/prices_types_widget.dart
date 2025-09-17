import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../constants/constants.dart';
import '../../../domain/entities/entities.dart';
import 'components.dart';

class PricesTypesWidget extends StatelessWidget {
  final PriceType? selectedPriceType;
  final void Function(PriceType priceType) onTap;
  const PricesTypesWidget({
    super.key,
    required this.selectedPriceType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [PriceType.sale, PriceType.offer];
    final mediaQuery = MediaQuery.of(context);
    bool showVertical = mediaQuery.size.width < 200;
    final theme = Theme.of(context);

    return Column(
      children: [
        TitleWidget(title: "Tipo de preço".hardcoded),
        if (defaultTargetPlatform == TargetPlatform.iOS)
          CupertinoListSection(
            dividerMargin: 0,
            margin: EdgeInsets.zero,
            topMargin: Sizes.p8,
            backgroundColor: Colors.transparent,
            additionalDividerMargin: 0,
            separatorColor: theme.disabledColor.withAlpha(20),
            header: null,
            children: items.map((priceType) {
              final isSelected = selectedPriceType == priceType;
              return CupertinoListTile(
                title: Text(priceType.name),
                onTap: () => onTap(priceType),
                backgroundColor: isSelected
                    ? theme.primaryColorLight.withAlpha(100)
                    : null,
                trailing: isSelected
                    ? const Icon(
                        CupertinoIcons.check_mark,
                        color: CupertinoColors.activeGreen,
                      )
                    : null,
              );
            }).toList(),
          )
        else ...[
          RadioGroup<PriceType>(
            key: Key(showVertical ? "vertical" : "horizontal"),
            groupValue: selectedPriceType,
            onChanged: (value) {
              onTap(value!);
            },
            child: showVertical
                ? Column(
                    children: items
                        .map((e) => _PriceTypeItem(priceType: e, onTap: onTap))
                        .toList(),
                  )
                : Row(
                    children: items
                        .map(
                          (e) => Flexible(
                            flex: e.name.length,
                            child: _PriceTypeItem(priceType: e, onTap: onTap),
                          ),
                        )
                        .toList(),
                  ),
          ),
          Divider(),
        ],
      ],
    );
  }
}

class _PriceTypeItem extends StatelessWidget {
  final void Function(PriceType newType) onTap;
  final PriceType priceType;
  const _PriceTypeItem({required this.priceType, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(priceType);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(child: Text(priceType.name)),
          Radio(value: priceType),
        ],
      ),
    );
  }
}
