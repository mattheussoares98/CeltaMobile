import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/extensions/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageDiscountOrIncrement extends ConsumerStatefulWidget {
  final BSFValueTypeEntity? valueType;
  final bool allowUpdate;
  final String title;
  final void Function(BSFValueTypeEntity value) onUpdate;
  final VoidCallback onRemove;
  final String notAllowedMessage;
  const ManageDiscountOrIncrement({
    super.key,
    required this.valueType,
    required this.allowUpdate,
    required this.title,
    required this.onUpdate,
    required this.onRemove,
    required this.notAllowedMessage,
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
      _selectedType = widget.valueType?.type ?? PercentageOrValue.percentage;
      final val = widget.valueType?.value;
      _valueController.text = (val != null && val > 0) ? val.toString() : '';
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
    final value = widget.valueType?.value ?? 0;

    if (value == 0 && !widget.allowUpdate) {
      return const SizedBox.shrink();
    }

    final subtitle = value > 0
        ? '${widget.valueType?.value?.toString().toBrazilianNumber()} ${widget.valueType?.type?.symbol ?? ''}'
        : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!widget.allowUpdate && value > 0)
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
                        TitleAndSubTitle(
                          title: widget.title,
                          subTitle: subtitle,
                          removeColon: subtitle == null,
                        ),
                        if (value > 0 &&
                            widget.valueType?.type ==
                                PercentageOrValue.percentage)
                          Consumer(
                            builder: (context, ref, child) {
                              final currentSaleRequestBrutValue = ref.watch(
                                insertUpdateStateControllerProvider.select(
                                  (s) => s.value?.totalProductsBrut ?? 0,
                                ),
                              );

                              return TitleAndSubTitle(
                                title: 'Valor líquido'.hardcoded,
                                subTitle: widget.valueType?.calculateItemValue(
                                  currentSaleRequestBrutValue,
                                ),
                                subTitleIsPrice: true,
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  if (value > 0)
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
                          : (value > 0
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 65,
                      child: DefaultTextFormField(
                        controller: _valueController,
                        focusNode: _focusNode,
                        labelText: 'Valor'.hardcoded,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: FormValidators.compose([
                          NonEmptyValidator(),
                          NumberValidator(allowDecimal: true),
                        ]),
                      ),
                    ),
                    gapW8,
                    Flexible(
                      flex: 35,
                      child: DefaultDropDown<PercentageOrValue>(
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
