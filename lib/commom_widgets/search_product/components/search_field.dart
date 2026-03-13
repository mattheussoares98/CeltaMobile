import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/entities/entities.dart';
import '../../../core/presentation/controllers/products/products.dart';
import '../../../core/validators/validators.dart';
import '../../../features/settings/presentation/controllers/controllers.dart';
import '../../../localization/string_hardcoded.dart';
import '../../commom_widgets.dart';
import '../mixin/mixin.dart';
import 'components.dart';

class SearchField extends ConsumerStatefulWidget {
  final bool? isLoading;
  final SearchProductKey searchProductKey;
  final TextEditingController searchValueController;
  final FocusNode? focusNode;
  final void Function(int?) searchProducts;
  final bool? allowEmptySearchValue;
  const SearchField({
    super.key,
    required this.isLoading,
    required this.searchProductKey,
    required this.searchValueController,
    required this.focusNode,
    required this.searchProducts,
    required this.allowEmptySearchValue,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchFieldState();
}

class _SearchFieldState extends ConsumerState<SearchField>
    with DefaultSearchProductsMixin {
  final LayerLink _layerLink = LayerLink();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Form(
        key: formKey,
        child: Consumer(
          builder: (context, ref, child) {
            final isLoading =
                (widget.isLoading == true ||
                ref.watch(
                  searchProductsStateControllerProvider(
                    widget.searchProductKey,
                  ).select((s) => s.isLoading),
                ));

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
              onChanged: (_) => onTextChanged(
                layerLink: _layerLink,
                formKey: formKey,
                controller: widget.searchValueController,
                onProductSelected: widget.searchProducts,
              ),
              enabled: isLoading == false,
              controller: widget.searchValueController,
              focusNode: widget.focusNode,
              validator: FormValidators.compose([
                if (widget.allowEmptySearchValue != true) NonEmptyValidator(),
                if (pref == SearchProductTypePreference.ean)
                  NumberValidator(allowDecimal: false),
              ]),
              onFieldSubmitted: (_) => onSearch(
                formKey,
                controller: widget.searchValueController,
                onProductSelected: widget.searchProducts,
              ),
              prefixIcon: DeleteIcon(
                isLoading: isLoading,
                searchValueController: widget.searchValueController,
                focusNode: widget.focusNode,
              ),
              suffixIcon: SuffixActions(
                isLoading: isLoading,
                formKey: formKey,
                searchValueController: widget.searchValueController,
                searchProducts: widget.searchProducts,
                searchProductKey: widget.searchProductKey,
              ),
              labelText:
                  'Consultar produtos (${pref?.name ?? 'Dinâmico'})'.hardcoded,
              hintText: hint,
            );
          },
        ),
      ),
    );
  }
}
