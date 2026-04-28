import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../domain/entities/entities.dart';

class DiscountsSection extends StatefulWidget {
  final List<BSFDiscountEntity> discounts;
  final PercentageOrValue discountType;
  final ValueChanged<List<BSFDiscountEntity>> onDiscountsChanged;

  const DiscountsSection({
    super.key,
    required this.discounts,
    required this.discountType,
    required this.onDiscountsChanged,
  });

  @override
  State<DiscountsSection> createState() => _DiscountsSectionState();
}

class _DiscountsSectionState extends State<DiscountsSection> {
  late PercentageOrValue _currentType;

  @override
  void initState() {
    super.initState();
    _currentType = widget.discountType;
  }

  bool get _isPercentage => _currentType == PercentageOrValue.percentage;

  void _addDiscount() {
    final newDiscount = BSFDiscountEntity(
      order: (widget.discounts.length) + 1,
      discountOrigin: null,
      user: null,
      justification: null,
      discount: BSFValueTypeEntity(type: _currentType, value: 0),
    );
    widget.onDiscountsChanged([...widget.discounts, newDiscount]);
  }

  void _removeDiscount(int index) {
    final list = List<BSFDiscountEntity>.from(widget.discounts);
    list.removeAt(index);
    // Re-order
    for (var i = 0; i < list.length; i++) {
      list[i] = BSFDiscountEntity(
        order: i + 1,
        discountOrigin: list[i].discountOrigin,
        user: list[i].user,
        justification: list[i].justification,
        discount: list[i].discount,
      );
    }
    widget.onDiscountsChanged(list);
  }

  void _updateDiscountValue(int index, double value) {
    final list = List<BSFDiscountEntity>.from(widget.discounts);
    list[index] = BSFDiscountEntity(
      order: list[index].order,
      discountOrigin: list[index].discountOrigin,
      user: list[index].user,
      justification: list[index].justification,
      discount: BSFValueTypeEntity(type: _currentType, value: value),
    );
    widget.onDiscountsChanged(list);
  }

  void _onTypeChanged(PercentageOrValue type) {
    setState(() {
      _currentType = type;
    });

    // Update all existing discounts type
    final list = widget.discounts.map((d) {
      return BSFDiscountEntity(
        order: d.order,
        discountOrigin: d.discountOrigin,
        user: d.user,
        justification: d.justification,
        discount: BSFValueTypeEntity(type: type, value: d.discount?.value ?? 0),
      );
    }).toList();

    widget.onDiscountsChanged(list);
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Descontos'.hardcoded,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SegmentedButton<PercentageOrValue>(
              segments: [
                ButtonSegment(
                  value: PercentageOrValue.value,
                  label: Text('R\$'.hardcoded),
                ),
                ButtonSegment(
                  value: PercentageOrValue.percentage,
                  label: Text('%'.hardcoded),
                ),
              ],
              selected: {_currentType},
              onSelectionChanged: (selected) {
                _onTypeChanged(selected.first);
              },
            ),
          ],
        ),
        gapH8,
        if (widget.discounts.isEmpty)
          Text(
            'Nenhum desconto adicionado'.hardcoded,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ...List.generate(widget.discounts.length, (index) {
          final discount = widget.discounts[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: Sizes.p8),
            child: Row(
              children: [
                Expanded(
                  child: DefaultTextFormField(
                    labelText: 'Desconto ${index + 1} (${_currentType.symbol})'
                        .hardcoded,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    onChanged: (value) {
                      _updateDiscountValue(index, double.tryParse(value) ?? 0);
                    },
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        text: (discount.discount?.value ?? 0).toString(),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isIOS ? CupertinoIcons.delete : Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () => _removeDiscount(index),
                ),
              ],
            ),
          );
        }),
        gapH8,
        if (_isPercentage || widget.discounts.isEmpty)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _addDiscount,
              icon: Icon(isIOS ? CupertinoIcons.add : Icons.add),
              label: Text(
                _isPercentage
                    ? 'Adicionar desconto'.hardcoded
                    : 'Adicionar desconto'.hardcoded,
              ),
            ),
          ),
      ],
    );
  }
}
