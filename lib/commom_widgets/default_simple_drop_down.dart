import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class DefaultSimpleDropDown<T> extends StatelessWidget {
  final void Function(T?)? onChanged;
  final List<DropdownMenuItem<T>>? items;
  final T value;
  final String hint;
  final String? Function(T?)? validator;
  final bool? isLoading;

  const DefaultSimpleDropDown({
    super.key,
    required this.onChanged,
    required this.items,
    required this.value,
    required this.hint,
    this.validator,
    this.isLoading,
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
        icon: Padding(
          padding: const EdgeInsets.only(right: Sizes.p8),
          child: isLoading == true ? _LoadingWidget() : _IconWidget(),
        ),
        hint: Text(hint),
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

class _LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return theme.platform == TargetPlatform.iOS
        ? CupertinoActivityIndicator(color: theme.disabledColor)
        : const CircularProgressIndicator();
  }
}
