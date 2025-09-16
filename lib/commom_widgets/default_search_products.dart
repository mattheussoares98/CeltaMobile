import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/presentation/theme/theme.dart';
import '../core/validators/validators.dart';

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

  @override
  void dispose() {
    super.dispose();
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
          child: TextFormField(
            enabled: !widget.isLoading,
            controller: widget.searchValueController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: FormValidators.compose([NonEmptyValidator()]),
            onFieldSubmitted: (_) {
              searchProducts();
            },
            decoration: AppDecorations.input(
              context: context,
              prefixIcon: width < 220
                  ? null
                  : IconButton(
                      onPressed: () {
                        widget.searchValueController.clear();
                      },
                      icon: Icon(
                        defaultTargetPlatform == TargetPlatform.iOS
                            ? CupertinoIcons.delete
                            : Icons.delete,
                        color: widget.isLoading
                            ? theme.disabledColor
                            : Colors.red,
                      ),
                    ),
              suffixIcon: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (width >= 220)
                      IconButton(
                        onPressed: searchProducts,
                        icon: Icon(
                          defaultTargetPlatform == TargetPlatform.iOS
                              ? CupertinoIcons.search
                              : Icons.search,
                        ),
                      ),
                    IconButton(
                      onPressed: () {
                        //TODO implement
                      },
                      icon: Icon(
                        defaultTargetPlatform == TargetPlatform.iOS
                            ? CupertinoIcons.camera_fill
                            : Icons.camera_alt,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        //TODO implement
                      },
                      icon: Icon(
                        defaultTargetPlatform == TargetPlatform.iOS
                            ? CupertinoIcons.settings
                            : Icons.settings,
                      ),
                    ),
                  ],
                ),
              ),
              labelText: 'NOME-PLU-EAN-%'.hardcoded,
              hintText: 'NOME-PLU-EAN-%'
                  .hardcoded, //TODO show personalizedCode if is enabled this option
            ),
          ),
        );
      },
    );
  }
}
