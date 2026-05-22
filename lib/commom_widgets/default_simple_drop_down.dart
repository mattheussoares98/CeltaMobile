import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultSimpleDropDown<T> extends StatelessWidget {
  final void Function(T?)? onChanged;
  final List<DropdownMenuItem<T>>? items;
  final T value;
  final String hint;
  final String? Function(T?)? validator;
  final bool? isLoading;
  final AutovalidateMode? autovalidateMode;
  final void Function(T?)? onTap;
  final EdgeInsetsGeometry? padding;
  final double? iconSize;

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
    this.padding,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
          padding: padding ?? const EdgeInsets.symmetric(horizontal: Sizes.p16),
          items: items,
          alignment: Alignment.center,
          isExpanded: true,
          onChanged: onChanged,
          autovalidateMode: autovalidateMode,
          isDense: true,
          dropdownColor: Colors.white,
          validator: validator,
          iconSize: iconSize ?? 24,
          icon: Padding(
            padding: const EdgeInsets.only(right: Sizes.p8),
            child: SizedBox(
              child: isLoading == true
                  ? const LoadingWidget(size: Sizes.p16, padding: Sizes.p4)
                  : _IconWidget(),
            ),
          ),
          hint: Center(
            child: Text(
              hint,
              style: onChanged == null
                  ? TextStyle(color: context.theme.disabledColor)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _IconWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlatformIcon(
      cupertinoIcon: CupertinoIcons.chevron_down,
      materialIcon: Icons.arrow_drop_down,
      size: PlatformUtil.isCupertino ? Sizes.p12 : null,
    );
  }
}
