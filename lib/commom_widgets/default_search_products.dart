import 'package:celta_inventario/features/settings/presentation/controllers/app_settings_state_controller.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/constants.dart';
import '../core/domain/entities/entities.dart';
import '../core/infraestructure/infrastructure.dart';
import '../core/presentation/controllers/products/products.dart';
import '../core/validators/validators.dart';
import '../features/settings/presentation/pages/pages.dart';
import '../utils/utils.dart';
import 'commom_widgets.dart';

class DefaultSearchProducts extends ConsumerStatefulWidget {
  final bool isLoading;
  final VoidCallback searchProducts;
  final TextEditingController searchValueController;
  final FocusNode? focusNode;
  final bool? allowEmptySearchValue;
  final SearchProductKey searchProductKey;
  final VoidCallback? doOnSearchSucceeds;
  final Modules? module;
  const DefaultSearchProducts({
    super.key,
    required this.isLoading,
    required this.searchProducts,
    required this.searchValueController,
    required this.searchProductKey,
    this.focusNode,
    this.allowEmptySearchValue,
    this.doOnSearchSucceeds,
    this.module,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DefaultSearchProductsState();
}

class _DefaultSearchProductsState extends ConsumerState<DefaultSearchProducts> {
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    formKey.currentState?.dispose();
  }

  void searchProducts({bool? searchByCamera}) async {
    if (searchByCamera == true) {
      final code = await BarcodeScannerService.scanBarcode(context);
      if (code == null) return;
      widget.searchValueController.text = code;
    }

    if (formKey.currentState?.validate() != true) {
      return;
    }
    widget.searchProducts();
  }

  SearchProductTypePreference? get _searchPreference => ref.watch(
    appSettingsStateControllerProvider.select((s) => s.value?.searchPreference),
  );

  String get hintText {
    final defaultHint = 'NOME-PLU-EAN-%-BALANÇA'.hardcoded;

    if (_searchPreference == SearchProductTypePreference.dynamic) {
      return defaultHint;
    }

    return _searchPreference?.name ?? defaultHint;
  }

  void onTapDeleteIcon() {
    widget.searchValueController.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      widget.focusNode?.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    ref.listen(searchProductsStateControllerProvider(widget.searchProductKey), (
      p,
      n,
    ) {
      n.doOnSuccess(p, () {
        widget.searchValueController.clear();
        widget.doOnSearchSucceeds?.call();
      });
    });

    return SizedBox(
      width: Breakpoint.desktop,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          return Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.only(top: Sizes.p4),
              child: DefaultTextFormField(
                key: const ValueKey('search_products'),
                maxLength: 40,
                enabled: !widget.isLoading,
                controller: widget.searchValueController,
                focusNode: widget.focusNode,
                validator: FormValidators.compose([
                  if (widget.allowEmptySearchValue != true) NonEmptyValidator(),
                  if (_searchPreference == SearchProductTypePreference.ean)
                    NumberValidator(allowDecimal: false),
                ]),
                onFieldSubmitted: (_) => searchProducts(),
                prefixIcon: width < 220
                    ? null
                    : _DefaultIcon(
                        onPress: widget.isLoading ? null : onTapDeleteIcon,
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
                      if (width >= 220 && !widget.isLoading)
                        _DefaultIcon(
                          onPress: widget.isLoading ? null : searchProducts,
                          materialIcon: Icons.search,
                          cupertinoIcon: CupertinoIcons.search,
                          iconColor: widget.isLoading
                              ? theme.disabledColor
                              : null,
                        )
                      else if (widget.isLoading) ...[
                        const LoadingWidget(padding: 0, size: Sizes.p16),
                        gapW12,
                      ],
                      if (theme.platform == TargetPlatform.iOS ||
                          theme.platform == TargetPlatform.android)
                        _DefaultIcon(
                          onPress: widget.isLoading
                              ? null
                              : () => searchProducts(searchByCamera: true),
                          materialIcon: Icons.camera_alt,
                          cupertinoIcon: CupertinoIcons.camera_fill,
                          iconColor: widget.isLoading
                              ? theme.disabledColor
                              : null,
                        ),
                      _DefaultIcon(
                        onPress: widget.isLoading
                            ? null
                            : () {
                                showModalPage(
                                  SettingsPage(module: widget.module),
                                  context,
                                );
                              },
                        materialIcon: Icons.settings,
                        cupertinoIcon: CupertinoIcons.settings,
                        iconColor: widget.isLoading
                            ? theme.disabledColor
                            : null,
                      ),
                    ],
                  ),
                ),
                labelText:
                    'Consultar produtos (${_searchPreference?.name ?? 'Dinâmico'})'
                        .hardcoded,
                hintText: hintText,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DefaultIcon extends StatelessWidget {
  final VoidCallback? onPress;
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
