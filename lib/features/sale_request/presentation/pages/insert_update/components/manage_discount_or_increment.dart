import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/extensions/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageDiscountOrIncrement extends ConsumerStatefulWidget {
  final List<BSFValueTypeEntity?> valueTypes;
  final bool allowUpdate;
  final String title;
  final void Function(BSFValueTypeEntity value) onUpdate;
  final VoidCallback onRemove;
  final String notAllowedMessage;
  final double? liquidValue;
  const ManageDiscountOrIncrement({
    super.key,
    required this.valueTypes,
    required this.allowUpdate,
    required this.title,
    required this.onUpdate,
    required this.onRemove,
    required this.notAllowedMessage,
    required this.liquidValue,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ItemState();
}

class _ItemState extends ConsumerState<ManageDiscountOrIncrement> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _valueController;
  late final FocusNode _focusNode;

  PercentageOrValue? _selectedType;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _valueController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _valueController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      final firstValue = widget.valueTypes.firstOrNull;
      _selectedType = firstValue?.type ?? PercentageOrValue.percentage;
      final val = firstValue?.value;
      _valueController.text = (val != null && val > 0)
          ? val.toString().toBrazilianNumber()
          : '';
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _confirmChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      final doubleValue = _valueController.text.toDouble() ?? 0.0;
      final updatedEntity = BSFValueTypeEntity(
        type: _selectedType,
        value: doubleValue,
      );

      widget.onUpdate(updatedEntity);

      setState(() {
        _isEditing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final atLeastOneValueBiggerThanZero = widget.valueTypes.any(
      (e) => (e?.value ?? 0) > 0,
    );

    if (!atLeastOneValueBiggerThanZero && !widget.allowUpdate) {
      return const SizedBox.shrink();
    }

    final liquidValue = widget.liquidValue ?? 0;
    final showLiquidValue = liquidValue > 0 || atLeastOneValueBiggerThanZero;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!widget.allowUpdate && !atLeastOneValueBiggerThanZero)
                Text(
                  widget.notAllowedMessage,
                  style: context.theme.textTheme.titleMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Colors.red,
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (atLeastOneValueBiggerThanZero)
                          ...widget.valueTypes.map<Widget>((e) {
                            return Builder(
                              builder: (_) {
                                final value = e?.value ?? 0;
                                return Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TitleAndSubTitle(
                                            title: widget.title,
                                            subTitle: value == 0
                                                ? null
                                                : value
                                                      .toString()
                                                      .toBrazilianNumber(
                                                        2,
                                                        true,
                                                      ),
                                            removeColon: value == 0,
                                            subTitleIsPercentage:
                                                e?.type ==
                                                PercentageOrValue.percentage,
                                            subTitleIsPrice:
                                                e?.type ==
                                                PercentageOrValue.reais,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }),
                        TitleAndSubTitle(
                          title: showLiquidValue
                              ? 'Valor líquido'.hardcoded
                              : widget.title,
                          subTitle: showLiquidValue ? widget.liquidValue : null,
                          subTitleIsPrice: showLiquidValue,
                          removeColon: !showLiquidValue,
                        ),
                      ],
                    ),
                  ),

                  if (atLeastOneValueBiggerThanZero)
                    IconButton(
                      onPressed: () {
                        widget.onRemove();
                        setState(() {
                          _isEditing = false;
                        });
                      },
                      icon: const PlatformIcon(
                        cupertinoIcon: CupertinoIcons.delete,
                        materialIcon: Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  if (widget.allowUpdate)
                    IconButton(
                      onPressed: () {
                        if (_isEditing) {
                          setState(() {
                            _isEditing = false;
                          });
                        } else {
                          _startEditing();
                        }
                      },
                      icon: _isEditing
                          ? const PlatformIcon(
                              cupertinoIcon: CupertinoIcons.xmark,
                              materialIcon: Icons.close,
                            )
                          : (atLeastOneValueBiggerThanZero
                                ? const PlatformIcon(
                                    cupertinoIcon: CupertinoIcons.pencil,
                                    materialIcon: Icons.edit,
                                  )
                                : const PlatformIcon(
                                    cupertinoIcon: CupertinoIcons.plus,
                                    materialIcon: Icons.add,
                                  )),
                    ),
                ],
              ),

              if (_isEditing) ...[
                gapH8,
                Row(
                  children: [
                    Expanded(
                      flex: 65,
                      child: BaseTextFormField(
                        controller: _valueController,
                        focusNode: _focusNode,
                        labelText:
                            'Valor ${_selectedType?.symbol ?? ''}'.hardcoded,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onFieldSubmitted: (_) => _confirmChanges(),
                        validator: FormValidators.compose([
                          const NonEmptyValidator(),
                          NumberValidator(allowDecimal: true),
                        ]),
                      ),
                    ),
                    gapW8,
                    Flexible(
                      flex: 35,
                      child: BaseDropDown<PercentageOrValue>(
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value;
                          });
                        },
                        selectedItem: _selectedType,
                        label: 'Tipo'.hardcoded,
                        isSimple: true,
                        dropdownHeight: 48,
                        items: [
                          DropdownMenuItem(
                            value: PercentageOrValue.percentage,
                            child: Text(PercentageOrValue.percentage.symbol),
                          ),
                          DropdownMenuItem(
                            value: PercentageOrValue.reais,
                            child: Text(PercentageOrValue.reais.symbol),
                          ),
                        ],
                      ),
                    ),
                    gapW4,
                    IconButton(
                      onPressed: _confirmChanges,
                      icon: const PlatformIcon(
                        cupertinoIcon: CupertinoIcons.check_mark,
                        materialIcon: Icons.check,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
