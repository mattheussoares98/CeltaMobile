import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../localization/string_hardcoded.dart';

class DefaultDropDown<T> extends StatefulWidget {
  final void Function(T)? onChanged;
  final List<DropdownMenuItem<T>>? items;
  final Widget? hint;
  final T? selectedItem;
  final String? label;
  final double? dropdownHeight;
  final String? Function(T?)? validator;

  const DefaultDropDown({
    required this.onChanged,
    required this.hint,
    required this.items,
    required this.selectedItem,
    required this.label,
    this.dropdownHeight = 40,
    this.validator,
    super.key,
  });

  @override
  State<DefaultDropDown<T>> createState() => _DefaultDropDownState<T>();
}

class _DefaultDropDownState<T> extends State<DefaultDropDown<T>> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    if (theme.platform == TargetPlatform.iOS) {
      return FormField(
        validator: widget.validator,
        initialValue: widget.selectedItem,
        builder: (state) {
          return Column(
            children: [
              SizedBox(
                height: widget.dropdownHeight,
                child: CupertinoButton(
                  disabledColor: theme.disabledColor.withAlpha(100),
                  padding: const EdgeInsets.only(left: 15),
                  color: theme.disabledColor.withAlpha(50),
                  onPressed:
                      widget.onChanged == null ||
                          (widget.items?.length ?? 0) < 1
                      ? null
                      : () async {
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
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(
                                  'Cancelar'.hardcoded,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: CupertinoColors.destructiveRed,
                                  ),
                                ),
                              ),
                            ),
                          );

                          if (selected != null && widget.onChanged != null) {
                            widget.onChanged!(selected);
                          }
                        },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.label ?? 'Selecionar'.hardcoded,
                          maxLines: 1,
                          style: theme.textTheme.titleMedium,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (size.width > 300)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Sizes.p16,
                          ),
                          child: Icon(CupertinoIcons.chevron_down),
                        ),
                    ],
                  ),
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

    return Container(
      decoration: BoxDecoration(
        color: theme.disabledColor.withAlpha(50),
        borderRadius: BorderRadius.circular(Sizes.p8),
      ),
      padding: EdgeInsets.symmetric(horizontal: Sizes.p16),
      height: widget.dropdownHeight,
      child: DropdownButtonFormField<T>(
        decoration: InputDecoration(border: InputBorder.none),
        isDense: true,
        dropdownColor: Colors.white,
        validator: widget.validator,
        initialValue: widget.selectedItem,
        isExpanded: true,
        alignment: Alignment.center,
        iconSize: 17,
        hint: widget.hint,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: theme.textTheme.titleMedium!.fontSize,
          color: Colors.black,
          height: 1,
          overflow: TextOverflow.ellipsis,
        ),
        items: widget.items,
        onChanged: widget.onChanged == null || (widget.items?.length ?? 0) < 1
            ? null
            : (value) {
                if (value != null && widget.onChanged != null) {
                  widget.onChanged!(value);
                }
              },
      ),
    );
  }
}
