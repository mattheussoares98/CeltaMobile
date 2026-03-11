import 'package:celta_inventario/features/settings/presentation/controllers/app_settings_state_controller.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/constants.dart';
import '../../core/domain/entities/entities.dart';
import '../../core/infraestructure/services/services.dart';
import '../../core/presentation/controllers/products/products.dart';
import '../../core/validators/validators.dart';
import '../../features/settings/presentation/pages/pages.dart';
import '../../routing/routing.dart';
import '../../utils/utils.dart';
import '../core/presentation/pages/shallow_search_products/models/models.dart';
import 'commom_widgets.dart';

class DefaultSearchProducts extends ConsumerStatefulWidget {
  final void Function(int? exactProductCode) searchProducts;
  final TextEditingController searchValueController;
  final FocusNode? focusNode;
  final bool? allowEmptySearchValue;
  final bool? isLoading;
  final SearchProductKey searchProductKey;

  const DefaultSearchProducts({
    super.key,
    required this.searchProducts,
    required this.searchValueController,
    required this.searchProductKey,
    this.focusNode,
    this.allowEmptySearchValue,
    this.isLoading,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DefaultSearchProductsState();
}

class _DefaultSearchProductsState extends ConsumerState<DefaultSearchProducts> {
  final formKey = GlobalKey<FormState>();

  void onTextChanged(String value) async {
    if (value.removeWhiteSpaces().length < 3 || int.tryParse(value) != null) {
      ref.invalidate(shallowProductsStateControllerProvider);
      return;
    }

    final product =
        await context.pushNamed(Routes.shallowSearchProducts.name, extra: value)
            as TappedProductModel;

    if (product.textField != null) {
      widget.searchValueController.text = product.textField ?? '';
    }

    switch (product.closedShallowPageType) {
      case ClosePageAction.cancel:
        break;
      case ClosePageAction.tapProduct:
        widget.searchProducts(product.codigoInternoProEmb);
        break;
      case ClosePageAction.submit:
        if (widget.searchValueController.text.removeWhiteSpaces().length >= 3 &&
            ref.read(
              shallowProductsStateControllerProvider.select(
                (s) => s.value?.isNotEmpty == true,
              ),
            )) {
          widget.searchProducts(product.codigoInternoProEmb);
        }
        break;
    }
  }

  void onSearch(GlobalKey<FormState> formKey, {bool? searchByCamera}) async {
    if (searchByCamera == true) {
      final code = await BarcodeScannerService.scanBarcode(context);
      if (code == null) return;
      widget.searchValueController.text = code;
    }

    if (formKey.currentState?.validate() == true) {
      widget.searchProducts(null);
    }
  }

  void onTapDeleteIcon() {
    widget.searchValueController.clear();
    widget.focusNode?.requestFocus();
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
      });
    });

    return RepaintBoundary(
      child: SizedBox(
        width: Breakpoint.desktop,
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

                    final isLoading =
                        (widget.isLoading ??
                            ref.watch(
                              searchProductsStateControllerProvider(
                                widget.searchProductKey,
                              ).select((s) => s.isLoading),
                            )) ==
                        true;

                    final defaultHint = 'NOME-PLU-EAN-%-BALANÇA'.hardcoded;
                    final hint = (pref == SearchProductTypePreference.dynamic)
                        ? defaultHint
                        : (pref?.name ?? defaultHint);

                    return DefaultTextFormField(
                      key: const ValueKey('search_input_field'),
                      maxLength: 40,
                      onChanged: onTextChanged,
                      enabled: isLoading == false,
                      controller: widget.searchValueController,
                      focusNode: widget.focusNode,
                      validator: FormValidators.compose([
                        if (widget.allowEmptySearchValue != true)
                          NonEmptyValidator(),
                        if (pref == SearchProductTypePreference.ean)
                          NumberValidator(allowDecimal: false),
                      ]),
                      onFieldSubmitted: (_) => onSearch(formKey),
                      prefixIcon: width < 220
                          ? null
                          : _DefaultIcon(
                              onPress: isLoading ? null : onTapDeleteIcon,
                              materialIcon: Icons.delete,
                              cupertinoIcon: CupertinoIcons.delete,
                              iconColor: isLoading
                                  ? theme.disabledColor
                                  : Colors.red,
                            ),
                      suffixIcon: _SuffixActions(
                        width: width,
                        isLoading: isLoading,
                        onSearch: () => onSearch(formKey),
                        onCamera: () => onSearch(searchByCamera: true, formKey),
                        module: widget.searchProductKey.module,
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
            isLoading: isLoading,
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
  final bool isLoading;

  const _DefaultIcon({
    required this.onPress,
    required this.materialIcon,
    required this.cupertinoIcon,
    required this.iconColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      visualDensity: VisualDensity.compact,
      onPressed: onPress,
      icon: isLoading
          ? const LoadingWidget(padding: 0, size: Sizes.p16)
          : Icon(
              theme.platform == TargetPlatform.iOS
                  ? cupertinoIcon
                  : materialIcon,
              color: iconColor,
              size: 20,
            ),
    );
  }
}
