import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultDropDown<T> extends StatefulWidget {
  final void Function(T)? onChanged;
  final Future<bool> Function(T)? onBeforeChange;
  final List<DropdownMenuItem<T>>? items;
  final Widget? hint;
  final T? selectedItem;
  final String? label;
  final double? dropdownHeight;
  final String? Function(T?)? validator;
  final bool showLabelAtTopLeft;
  final bool isSimple;
  final String? adviceMessage;

  const DefaultDropDown({
    required this.onChanged,
    required this.items,
    required this.selectedItem,
    required this.label,
    this.onBeforeChange,
    this.hint,
    this.dropdownHeight = 40,
    this.validator,
    this.showLabelAtTopLeft = false,
    this.isSimple = false,
    this.adviceMessage,
    super.key,
  });

  @override
  State<DefaultDropDown<T>> createState() => _DefaultDropDownState<T>();
}

class _DefaultDropDownState<T> extends State<DefaultDropDown<T>> {
  final _fieldKey = GlobalKey<FormFieldState<T>>();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final topLeftLabel =
        widget.selectedItem != null &&
            widget.showLabelAtTopLeft == true &&
            widget.label?.isNotEmpty == true
        ? Positioned(
            left: Sizes.p4,
            child: Text(
              widget.label!,
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 10),
            ),
          )
        : null;

    if (PlatformUtil.isCupertino && !widget.isSimple) {
      final double screenWidth = MediaQuery.sizeOf(context).width;
      final selectedMenuItem = widget.items?.firstWhereOrNull(
        (item) => item.value == widget.selectedItem,
      );
      return FormField(
        validator: widget.validator,
        initialValue: widget.selectedItem,
        builder: (state) {
          return Column(
            children: [
              SizedBox(
                height: widget.dropdownHeight,
                child: Stack(
                  children: [
                    ?topLeftLabel,
                    CupertinoButton(
                      disabledColor: theme.disabledColor.withAlpha(100),
                      padding: const EdgeInsets.only(left: 15),
                      color: theme.disabledColor.withAlpha(50),
                      onPressed:
                          widget.onChanged == null ||
                              (widget.items?.length ?? 0) < 1
                          ? null
                          : () async {
                              if (widget.adviceMessage != null) {
                                showAlertDialog(
                                  context: context,
                                  title: 'Atenção!'.hardcoded,
                                  content: widget.adviceMessage!,
                                );
                              }
                              if (!context.mounted) return;
                              final selected = await showCupertinoModalPopup<T>(
                                context: context,
                                builder: (_) => CupertinoActionSheet(
                                  title: Text('Selecionar'.hardcoded),
                                  actions: widget.items!.map((item) {
                                    return CupertinoActionSheetAction(
                                      onPressed: () {
                                        if (item.enabled) {
                                          Navigator.of(context).pop(item.value);
                                        }
                                      },
                                      child: item.child,
                                    );
                                  }).toList(),
                                  cancelButton: CupertinoActionSheetAction(
                                    isDefaultAction: true,
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text(
                                      'Cancelar'.hardcoded,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            color:
                                                CupertinoColors.destructiveRed,
                                          ),
                                    ),
                                  ),
                                ),
                              );

                              if (selected != null &&
                                  widget.onChanged != null) {
                                if (selected == widget.selectedItem) return;
                                if (widget.onBeforeChange != null) {
                                  final confirmed =
                                      await widget.onBeforeChange!(selected);
                                  if (!confirmed) return;
                                }
                                widget.onChanged!(selected);
                              }
                            },
                      child: Row(
                        children: [
                          Expanded(
                            child: selectedMenuItem != null
                                ? DefaultTextStyle(
                                    style:
                                        theme.textTheme.bodyLarge ??
                                        const TextStyle(),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    child: selectedMenuItem.child,
                                  )
                                : Text(
                                    widget.label ?? 'Selecionar'.hardcoded,
                                    maxLines: 1,
                                    style: theme.textTheme.bodyLarge,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          ),
                          if (screenWidth > 300)
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: Sizes.p16,
                              ),
                              child: Icon(CupertinoIcons.chevron_down),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (state.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 15),
                  child: Text(
                    state.errorText!,
                    style: const TextStyle(
                      color: CupertinoColors.systemRed,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          );
        },
      );
    }

    final bool isDropdownEnabled =
        widget.onChanged != null && (widget.items?.length ?? 0) > 0;

    return SizedBox(
      height: widget.dropdownHeight,
      child: Material(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(Sizes.p8)),
        ),
        color: theme.disabledColor.withAlpha(30),
        child: InkWell(
          onTap: isDropdownEnabled ? () {} : null,
          customBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(Sizes.p8)),
          ),
          child: Stack(
            children: [
              ?topLeftLabel,
              DropdownButtonFormField<T>(
                key: _fieldKey,
                autovalidateMode: AutovalidateMode.onUserInteractionIfError,
                decoration: const InputDecoration(border: InputBorder.none),
                isDense: true,
                padding: const EdgeInsets.only(left: Sizes.p8),
                dropdownColor: Colors.white,
                validator: widget.validator,
                initialValue: widget.selectedItem,
                isExpanded: true,
                alignment: Alignment.center,
                iconSize: 17,
                onTap: widget.adviceMessage == null
                    ? null
                    : () {
                        showAlertDialog(
                          context: context,
                          title: 'Atenção!'.hardcoded,
                          content: widget.adviceMessage!,
                        );
                      },
                hint:
                    widget.hint ??
                    (widget.label != null ? Text(widget.label!) : null),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: theme.textTheme.titleMedium?.fontSize,
                  color: Colors.black,
                  height: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                items: widget.items,
                onChanged:
                    widget.onChanged == null || (widget.items?.length ?? 0) < 1
                    ? null
                    : (value) async {
                        if (value != null) {
                          if (value == widget.selectedItem) return;
                          if (widget.onBeforeChange != null) {
                            final confirmed = await widget.onBeforeChange!(
                              value,
                            );
                            if (confirmed) {
                              widget.onChanged!(value);
                            } else {
                              _fieldKey.currentState?.didChange(
                                widget.selectedItem,
                              );
                            }
                          } else {
                            widget.onChanged!(value);
                          }
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
