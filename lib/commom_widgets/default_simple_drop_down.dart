import 'package:flutter/material.dart';

class DefaultSimpleDropDown<T> extends StatelessWidget {
  final void Function(T?)? onChanged;
  final List<DropdownMenuItem<T>> items;
  final T value;
  final Widget? hint;

  const DefaultSimpleDropDown({
    super.key,
    required this.onChanged,
    required this.items,
    required this.value,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      value: value,
      underline: Container(),
      items: items,
      isExpanded: true,
      onChanged: onChanged,
      hint: hint,
    );
  }
}
