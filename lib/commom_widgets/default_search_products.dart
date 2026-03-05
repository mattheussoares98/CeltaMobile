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
    formKey.currentState?.dispose();
    super.dispose();
  }

  void _onSearch({bool? searchByCamera}) async {
    if (searchByCamera == true) {
      final code = await BarcodeScannerService.scanBarcode(context);
      if (code == null) return;
      widget.searchValueController.text = code;
    }

    if (formKey.currentState?.validate() == true) {
      widget.searchProducts();
    }
  }

  void _onTapDeleteIcon() {
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

    return RepaintBoundary(
      child: Container(
        width: Breakpoint.desktop,

        color: theme.scaffoldBackgroundColor,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            return Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.only(top: Sizes.p4),
                child: Consumer(
                  builder: (context, ref, _) {
                    final pref = ref.watch(
                      appSettingsStateControllerProvider.select(
                        (s) => s.value?.searchPreference,
                      ),
                    );

                    final defaultHint = 'NOME-PLU-EAN-%-BALANÇA'.hardcoded;
                    final hint = (pref == SearchProductTypePreference.dynamic)
                        ? defaultHint
                        : (pref?.name ?? defaultHint);

                    return DefaultTextFormField(
                      key: const ValueKey('search_input_field'),
                      maxLength: 40,
                      enabled: !widget.isLoading,
                      controller: widget.searchValueController,
                      focusNode: widget.focusNode,
                      validator: FormValidators.compose([
                        if (widget.allowEmptySearchValue != true)
                          NonEmptyValidator(),
                        if (pref == SearchProductTypePreference.ean)
                          NumberValidator(allowDecimal: false),
                      ]),
                      onFieldSubmitted: (_) => _onSearch(),
                      prefixIcon: width < 220
                          ? null
                          : _DefaultIcon(
                              onPress: widget.isLoading
                                  ? null
                                  : _onTapDeleteIcon,
                              materialIcon: Icons.delete,
                              cupertinoIcon: CupertinoIcons.delete,
                              iconColor: widget.isLoading
                                  ? theme.disabledColor
                                  : Colors.red,
                            ),
                      suffixIcon: _SuffixActions(
                        width: width,
                        isLoading: widget.isLoading,
                        onSearch: () => _onSearch(),
                        onCamera: () => _onSearch(searchByCamera: true),
                        module: widget.module,
                      ),
                      labelText:
                          'Consultar produtos (${pref?.name ?? 'Dinâmico'})'
                              .hardcoded,
                      hintText: hint,
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SuffixActions extends StatelessWidget {
  final double width;
  final bool isLoading;
  final VoidCallback onSearch;
  final VoidCallback onCamera;
  final Modules? module;

  const _SuffixActions({
    required this.width,
    required this.isLoading,
    required this.onSearch,
    required this.onCamera,
    this.module,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile =
        theme.platform == TargetPlatform.iOS ||
        theme.platform == TargetPlatform.android;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (width >= 220)
          _DefaultIcon(
            onPress: onSearch,
            materialIcon: Icons.search,
            cupertinoIcon: CupertinoIcons.search,
            iconColor: null,
          ),
        if (isMobile)
          _DefaultIcon(
            onPress: isLoading ? null : onCamera,
            materialIcon: Icons.camera_alt,
            cupertinoIcon: CupertinoIcons.camera_fill,
            iconColor: isLoading ? theme.disabledColor : null,
          ),
        _DefaultIcon(
          onPress: isLoading
              ? null
              : () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  showModalPage(SettingsPage(module: module), context);
                },
          materialIcon: Icons.settings,
          cupertinoIcon: CupertinoIcons.settings,
          iconColor: isLoading ? theme.disabledColor : null,
        ),
      ],
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
      visualDensity: VisualDensity.compact,
      onPressed: onPress,
      icon: Icon(
        theme.platform == TargetPlatform.iOS ? cupertinoIcon : materialIcon,
        color: iconColor,
        size: 20,
      ),
    );
  }
}
