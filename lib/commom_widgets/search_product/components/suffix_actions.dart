import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/commom_widgets/search_product/components/components.dart';
import 'package:celta_inventario/commom_widgets/search_product/mixin/mixin.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/settings/presentation/pages/pages.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class SuffixActions extends ConsumerStatefulWidget {
  final bool isLoading;
  final GlobalKey<FormState> formKey;
  final TextEditingController searchValueController;
  final void Function(int? exactProductCode) searchProducts;
  final SearchProductKey searchProductKey;

  const SuffixActions({
    super.key,
    required this.isLoading,
    required this.formKey,
    required this.searchValueController,
    required this.searchProducts,
    required this.searchProductKey,
  });

  @override
  ConsumerState<SuffixActions> createState() => _SuffixActionsState();
}

class _SuffixActionsState extends ConsumerState<SuffixActions>
    with BaseSearchProductsMixin {
  Future<void> _searchByCamera() async {
    if (await Permission.camera.isGranted) {
      onSearch(
        widget.formKey,
        searchByCamera: true,
        controller: widget.searchValueController,
        onProductSelected: widget.searchProducts,
      );
      return;
    }

    if (!mounted) return;
    final openSettings = await showAlertDialog(
      context: context,
      title: 'Permissão da câmera'.hardcoded,
      content: 'Permita o acesso à câmera nas configurações do dispositivo.'
          .hardcoded,
      cancelActionText: 'Cancelar'.hardcoded,
      defaultActionText: 'Abrir configurações'.hardcoded,
    );
    if (openSettings == true) await openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtil.isMobile;
    final width = MediaQuery.sizeOf(context).width;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (width >= 220)
          DefaultIcon(
            onPress: () => onSearch(
              widget.formKey,
              controller: widget.searchValueController,
              onProductSelected: widget.searchProducts,
            ),
            materialIcon: Icons.search,
            cupertinoIcon: CupertinoIcons.search,
            iconColor: null,
            isLoading: widget.isLoading,
          ),
        if (isMobile)
          DefaultIcon(
            onPress: widget.isLoading ? null : _searchByCamera,
            materialIcon: Icons.camera_alt,
            cupertinoIcon: CupertinoIcons.camera_fill,
            iconColor: widget.isLoading ? context.theme.disabledColor : null,
            showWhenIsSmallPage: true,
          ),
        if (width >= 220)
          DefaultIcon(
            showWhenIsSmallPage: true,
            onPress: widget.isLoading
                ? null
                : () {
                    ShallowProductsOverlay.hide();
                    FocusManager.instance.primaryFocus?.unfocus();
                    showModalPage(
                      SettingsPage(module: widget.searchProductKey.module),
                      context,
                    );
                  },
            materialIcon: Icons.settings,
            cupertinoIcon: CupertinoIcons.settings,
            iconColor: widget.isLoading ? context.theme.disabledColor : null,
          ),
      ],
    );
  }
}
