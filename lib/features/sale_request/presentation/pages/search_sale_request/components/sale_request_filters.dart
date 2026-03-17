import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/validators/validators.dart';
import '../../../../../../utils/utils.dart';
import '../../../controllers/controllers.dart';

class SaleRequestFilters extends ConsumerStatefulWidget {
  final int enterpriseCode;

  const SaleRequestFilters({super.key, required this.enterpriseCode});

  @override
  ConsumerState<SaleRequestFilters> createState() => _SaleRequestFiltersState();
}

class _SaleRequestFiltersState extends ConsumerState<SaleRequestFilters> {
  final _startController = TextEditingController();
  final _endController = TextEditingController();
  final _codeController = TextEditingController();
  final expansibleController = ExpansibleController();
  final formKey = GlobalKey<FormState>();
  final now = DateTime.now();

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    _codeController.dispose();
    expansibleController.dispose();
    super.dispose();
  }

  void _onSearch() {
    // Logic to call your load method
    if (formKey.currentState?.validate() != true) {
      return;
    }

    ref
        .read(
          saleRequestsStateControllerProvider(widget.enterpriseCode).notifier,
        )
        .load(
          startDateHourOfCreation: _startController.text.toDateTime() ?? now,
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
      child: Card(
        margin: const EdgeInsets.all(Sizes.p8),
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
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DefaultTextFormField(
                      controller: _startController,
                      labelText: 'Data Início'.hardcoded,
                      hintText: '00/00/0000'.hardcoded,
                      keyboardType: TextInputType.datetime,
                      inputFormatters: [DateInputFormatter()],
                      validator: FormValidators.compose([
                        NonEmptyValidator(),
                        DateValidator(
                          minimumDate: now.subtract(
                            const Duration(days: 365 * 5),
                          ),
                          maximumDate: DateTime.now(),
                        ),
                      ]),
                    ),
                    DefaultTextFormField(
                      controller: _endController,
                      labelText: 'Data Fim'.hardcoded,
                      hintText: '00/00/0000'.hardcoded,
                      keyboardType: TextInputType.datetime,
                      inputFormatters: [DateInputFormatter()],
                      validator: FormValidators.compose([
                        DateValidator(
                          allowEmptyDate: true,
                          minimumDate: now.subtract(
                            const Duration(days: 365 * 5),
                          ),
                          maximumDate: DateTime.now(),
                        ),
                      ]),
                    ),
                    gapH12,
                    DefaultTextFormField(
                      controller: _codeController,
                      labelText: 'Código Personalizado'.hardcoded,
                      hintText: 'Digite o código...'.hardcoded,
                    ),
                    gapH20,
                    PrimaryButton(
                      text: 'Pesquisar'.hardcoded,
                      onPressed: _onSearch,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
