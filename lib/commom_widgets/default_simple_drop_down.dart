import 'package:flutter/material.dart';

import '../constants/constants.dart';

class DefaultSimpleDropDown<T> extends StatelessWidget {
  final void Function(T?)? onChanged;
  final List<DropdownMenuItem<T>> items;
  final T value;
  final String hint;
  final String? Function(T?)? validator;

  const DefaultSimpleDropDown({
    super.key,
    required this.onChanged,
    required this.items,
    required this.value,
    required this.hint,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: DropdownButtonFormField<T>(
        decoration: InputDecoration(border: InputBorder.none),
        initialValue: value,
        padding: EdgeInsets.symmetric(horizontal: Sizes.p16),
        items: items,
        alignment: Alignment.center,
        isExpanded: true,
        onChanged: onChanged,
        isDense: true,
        dropdownColor: Colors.white,
        validator: validator,
        iconSize: 30,
        hint: Text(hint),
      ),
    );
  }
}
