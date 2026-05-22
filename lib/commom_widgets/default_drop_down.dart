import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';

class DefaultDropDown<T> extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (PlatformUtil.isCupertino) {
      final double screenWidth = MediaQuery.sizeOf(context).width;
      return FormField(
        validator: validator,
        initialValue: selectedItem,
        builder: (state) {
          return Column(
            children: [
              SizedBox(
                height: dropdownHeight,
                child: CupertinoButton(
                  disabledColor: theme.disabledColor.withAlpha(100),
                  padding: const EdgeInsets.only(left: 15),
                  color: theme.disabledColor.withAlpha(50),
                  onPressed: onChanged == null || (items?.length ?? 0) < 1
                      ? null
                      : () async {
                          final selected = await showCupertinoModalPopup<T>(
                            context: context,
                            builder: (_) => CupertinoActionSheet(
                              title: Text('Selecionar'.hardcoded),
                              actions: items!.map((item) {
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

                          if (selected != null && onChanged != null) {
                            onChanged!(selected);
                          }
                        },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          label ?? 'Selecionar'.hardcoded,
                          maxLines: 1,
                          style: theme.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (screenWidth > 300)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: Sizes.p16),
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

    return SizedBox(
      height: dropdownHeight,
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.p8),
        ),
        color: theme.disabledColor.withAlpha(50),
        child: DropdownButtonFormField<T>(
          autovalidateMode: AutovalidateMode.onUserInteractionIfError,
          decoration: const InputDecoration(border: InputBorder.none),
          isDense: true,
          padding: const EdgeInsets.only(left: Sizes.p8),
          dropdownColor: Colors.white,
          validator: validator,
          initialValue: selectedItem,
          isExpanded: true,
          alignment: Alignment.center,
          iconSize: 17,
          hint: hint,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: theme.textTheme.titleMedium!.fontSize,
            color: Colors.black,
            height: 1,
            overflow: TextOverflow.ellipsis,
          ),
          items: items,
          onChanged: onChanged == null || (items?.length ?? 0) < 1
              ? null
              : (value) {
                  if (value != null && onChanged != null) {
                    onChanged!(value);
                  }
                },
        ),
      ),
    );
  }
}
