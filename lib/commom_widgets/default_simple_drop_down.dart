import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import 'commom_widgets.dart';

class DefaultSimpleDropDown<T> extends StatelessWidget {
  final void Function(T?)? onChanged;
  final List<DropdownMenuItem<T>>? items;
  final T value;
  final String hint;
  final String? Function(T?)? validator;
  final bool? isLoading;
  final AutovalidateMode? autovalidateMode;
  final void Function(T?)? onTap;

  const DefaultSimpleDropDown({
    super.key,
    required this.onChanged,
    required this.items,
    required this.value,
    required this.hint,
    this.validator,
    this.isLoading,
    this.autovalidateMode,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onChanged == null ? null : () {},
        child: DropdownButtonFormField<T>(
          onTap: onTap == null ? null : () => onTap!(value),
          decoration: const InputDecoration(
            border: InputBorder.none,
            errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
            focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide.none),
          ),
          initialValue: value,
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
          items: items,
          alignment: Alignment.center,
          isExpanded: true,
          onChanged: onChanged,
          autovalidateMode: autovalidateMode,
          isDense: true,
          dropdownColor: Colors.white,
          validator: validator,
          icon: Padding(
            padding: const EdgeInsets.only(right: Sizes.p8),
            child: SizedBox(
              child: isLoading == true
                  ? const LoadingWidget(size: Sizes.p16, padding: Sizes.p4)
                  : _IconWidget(),
            ),
          ),
          hint: Center(child: Text(hint)),
        ),
      ),
    );
  }
}

class _IconWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Icon(
      theme.platform == TargetPlatform.iOS
          ? CupertinoIcons.chevron_down
          : Icons.arrow_drop_down,
      size: theme.platform == TargetPlatform.iOS ? Sizes.p12 : null,
    );
  }
}
