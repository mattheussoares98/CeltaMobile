import 'package:celta_intelligence/features/settings/presentation/controllers/app_settings_state_controller.dart';
import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/domain/entities/entities.dart';
import '../core/providers/scanner/scanner.dart';
import '../core/validators/validators.dart';
import '../features/settings/presentation/pages/pages.dart';
import 'commom_widgets.dart';

class DefaultSearchProducts extends ConsumerStatefulWidget {
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
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DefaultSearchProductsState();
}

class _DefaultSearchProductsState extends ConsumerState<DefaultSearchProducts> {
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

  String getHintText(AppSettingsEntity? settings) {
    final defaultHint = 'NOME-PLU-EAN-%-BALANÇA'.hardcoded;

    switch (settings?.searchPreference) {
      case SearchProductTypePreference.dynamic:
        return defaultHint;
      case SearchProductTypePreference.personalizedCode:
        return SearchProductTypePreference.personalizedCode.name;
      case SearchProductTypePreference.legacyCode:
        return SearchProductTypePreference.legacyCode.name;
      default:
        return defaultHint;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final settings = ref.watch(appSettingsStateControllerProvider).value;
    final hintText = getHintText(settings);

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
                  if (theme.platform == TargetPlatform.iOS ||
                      theme.platform == TargetPlatform.android)
                    _DefaultIcon(
                      onPress: () async {
                        final value = await ref
                            .read(barcodeScannerRepositoryProvider)
                            .scan();
                        if (value != null) {
                          widget.searchValueController.text = value;
                          widget.searchProducts();
                        }
                      },
                      materialIcon: Icons.camera_alt,
                      cupertinoIcon: CupertinoIcons.camera_fill,
                      iconColor: widget.isLoading ? theme.disabledColor : null,
                    ),
                  _DefaultIcon(
                    onPress: () {
                      showModalPage(SettingsPage(), context);
                    },
                    materialIcon: Icons.settings,
                    cupertinoIcon: CupertinoIcons.settings,
                    iconColor: widget.isLoading ? theme.disabledColor : null,
                  ),
                ],
              ),
            ),
            labelText: hintText,
            hintText: hintText,
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
