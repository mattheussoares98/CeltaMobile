import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/validators/validators.dart';
import 'commom_widgets.dart';

class DefaultSearchProducts extends StatefulWidget {
  final bool isLoading;
  final VoidCallback searchProducts;
  final TextEditingController searchValueController;
  const DefaultSearchProducts({
    super.key,
    required this.isLoading,
    required this.searchProducts,
    required this.searchValueController,
  });

  @override
  State<DefaultSearchProducts> createState() => _DefaultSearchProductsState();
}

class _DefaultSearchProductsState extends State<DefaultSearchProducts> {
  final formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  void searchProducts() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }
    widget.searchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        return Form(
          key: formKey,
          child: DefaultTextFormField(
            maxLength: 40,
            enabled: !widget.isLoading,
            controller: widget.searchValueController,
            focusNode: focusNode,
            validator: FormValidators.compose([NonEmptyValidator()]),
            onFieldSubmitted: (_) {
              searchProducts();
            },
            prefixIcon: width < 220
                ? null
                : _DefaultIcon(
                    onPress: () {
                      widget.searchValueController.clear();
                      focusNode.requestFocus();
                    },
                    materialIcon: Icons.delete,
                    cupertinoIcon: CupertinoIcons.delete,
                    iconColor: widget.isLoading
                        ? theme.disabledColor
                        : Colors.red,
                  ),

            suffixIcon: FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (width >= 220)
                    _DefaultIcon(
                      onPress: searchProducts,
                      materialIcon: Icons.search,
                      cupertinoIcon: CupertinoIcons.search,
                      iconColor: widget.isLoading ? theme.disabledColor : null,
                    ),
                  _DefaultIcon(
                    onPress: () {
                      //TODO implement
                    },
                    materialIcon: Icons.camera_alt,
                    cupertinoIcon: CupertinoIcons.camera_fill,
                    iconColor: widget.isLoading ? theme.disabledColor : null,
                  ),
                  _DefaultIcon(
                    onPress: () {
                      //TODO implement
                    },
                    materialIcon: Icons.settings,
                    cupertinoIcon: CupertinoIcons.settings,
                    iconColor: widget.isLoading ? theme.disabledColor : null,
                  ),
                ],
              ),
            ),
            labelText: 'NOME-PLU-EAN-%-BALANÇA'.hardcoded,
            hintText: 'NOME-PLU-EAN-%-BALANÇA'
                .hardcoded, //TODO show personalizedCode if is enabled this option
          ),
        );
      },
    );
  }
}

class _DefaultIcon extends StatelessWidget {
  final VoidCallback onPress;
  final IconData materialIcon;
  final IconData cupertinoIcon;
  final Color? iconColor;
  const _DefaultIcon({
    required this.onPress,
    required this.materialIcon,
    required this.cupertinoIcon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      visualDensity: VisualDensity.comfortable,
      onPressed: onPress,
      icon: Icon(
        theme.platform == TargetPlatform.iOS ? cupertinoIcon : materialIcon,
        color: iconColor,
      ),
    );
  }
}
