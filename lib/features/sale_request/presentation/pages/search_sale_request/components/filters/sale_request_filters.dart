import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../controllers/controllers.dart';
import 'filters.dart';

class SaleRequestFilters extends ConsumerStatefulWidget {
  final TextEditingController startController;
  final GlobalKey<FormState> filtersFormKey;
  final int enterpriseCode;

  const SaleRequestFilters({
    super.key,
    required this.startController,
    required this.filtersFormKey,
    required this.enterpriseCode,
  });

  @override
  ConsumerState<SaleRequestFilters> createState() => _SaleRequestFiltersState();
}

class _SaleRequestFiltersState extends ConsumerState<SaleRequestFilters> {
  static final now = DateTime.now();
  final _endController = TextEditingController();
  final _endFocusNode = FocusNode();
  final _codeController = TextEditingController();
  final _codFocusNode = FocusNode();
  final expansibleController = ExpansibleController();

  @override
  void dispose() {
    _endController.dispose();
    _codeController.dispose();
    _endFocusNode.dispose();
    _codFocusNode.dispose();
    expansibleController.dispose();
    super.dispose();
  }

  void _onSearch() {
    // Logic to call your load method
    if (widget.filtersFormKey.currentState?.validate() != true) {
      return;
    }

    expansibleController.collapse();

    ref
        .read(
          saleRequestsStateControllerProvider(widget.enterpriseCode).notifier,
        )
        .load(
          startDateHourOfCreation:
              widget.startController.text.toDateTime() ?? now,
          endDateHourOfCreation: _endController.text.toDateTime(),
          personalizedCodes: _codeController.text.isNotEmpty
              ? [_codeController.text]
              : null,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    ref.listen(saleRequestsStateControllerProvider(widget.enterpriseCode), (
      p,
      n,
    ) {
      n.doOnSuccess(p, () {
        if (n.value != null) {
          expansibleController.collapse();
        }
      });
    });

    return RepaintBoundary(
      child: ResponsiveScrollableWidget(
        child: Card(
          child: ExpansionTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizes.p12),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizes.p12),
            ),
            backgroundColor: theme.primaryColorLight.withAlpha(30),
            collapsedBackgroundColor: theme.primaryColorDark.withAlpha(30),
            childrenPadding: const EdgeInsets.all(Sizes.p8),
            iconColor: theme.primaryColorDark,
            collapsedIconColor: theme.primaryColor,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            controller: expansibleController,
            initiallyExpanded: true,
            title: Text(
              'Filtros de busca'.hardcoded,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Sizes.p16,
                  0,
                  Sizes.p16,
                  Sizes.p16,
                ),
                child: Form(
                  key: widget.filtersFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      StartDateField(
                        controller: widget.startController,
                        onSubmit: _endFocusNode.requestFocus,
                      ),
                      gapH8,
                      AnimatedBuilder(
                        animation: widget.startController,
                        builder: (context, child) {
                          final minimumDate =
                              widget.startController.text.toDateTime() ??
                              now.subtract(const Duration(days: 365 * 5));

                          return EndDateField(
                            controller: _endController,
                            focusNode: _endFocusNode,
                            onSubmit: _codFocusNode.requestFocus,
                            minimumDate: minimumDate,
                          );
                        },
                      ),
                      gapH8,
                      DefaultTextFormField(
                        controller: _codeController,
                        focusNode: _codFocusNode,
                        labelText: 'Código Personalizado'.hardcoded,
                        hintText: 'Digite o código...'.hardcoded,
                        onFieldSubmitted: (_) => _onSearch(),
                      ),
                      gapH20,
                      Consumer(
                        builder: (_, ref, child) {
                          return PrimaryButton(
                            text: 'Pesquisar'.hardcoded,
                            onPressed: _onSearch,
                            isLoading: ref.watch(
                              saleRequestsStateControllerProvider(
                                widget.enterpriseCode,
                              ).select((s) => s.isLoading),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
