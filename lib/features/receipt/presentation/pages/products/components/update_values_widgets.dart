import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/validators/validators.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../../../utils/utils.dart';
import '../../../controllers/controllers.dart';

class UpdateValuesWidgets extends ConsumerStatefulWidget {
  final ProductEntity product;
  final TextEditingController quantityController;
  final SearchProductKey searchProductKey;
  final int receiptCode;
  const UpdateValuesWidgets({
    super.key,
    required this.product,
    required this.quantityController,
    required this.searchProductKey,
    required this.receiptCode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateValuesWidgetsState();
}

class _UpdateValuesWidgetsState extends ConsumerState<UpdateValuesWidgets> {
  DateTime? newValidity;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        setState(() {
          newValidity = widget.product.DataValidade_ProcRecebDocProEmb;
        });
      }
    });
  }

  void update({bool? isSubtract, bool? isAnnul}) {
    if (isAnnul != true && formKey.currentState?.validate() != true) {
      return;
    }

    ref
        .read(updateProductControllerProvider(widget.searchProductKey).notifier)
        .updateValues(
          grDocCode: widget.receiptCode,
          productPackingCode: widget.product.ProductPackingCode!,
          isSubtract: isSubtract == true || isAnnul == true,
          quantity: isAnnul == true
              ? widget.product.Quantidade_ProcRecebDocProEmb ?? 0
              : widget.quantityController.text.toDouble()!,
          newValidityDate: newValidity,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    final bool hasInsertedQuantity =
        widget.product.Quantidade_ProcRecebDocProEmb != null &&
        widget.product.Quantidade_ProcRecebDocProEmb! > 0;

    final now = DateTime.now();

    return Column(
      children: [
        const Divider(),
        Row(
          children: [
            Expanded(
              flex: 6,
              child: Align(
                alignment: Alignment.centerLeft,
                child: PrimaryTextButton(
                  text: 'Nova validade'.hardcoded,
                  icon: Icon(
                    isIOS ? CupertinoIcons.calendar : Icons.calendar_month,
                  ),
                  onPressed: () async {
                    newValidity = await GetNewDate.get(
                      minimumDate: now,
                      maximumDate: now.add(const Duration(days: 365 * 10)),
                      context: context,
                      currentSelectedDate: newValidity,
                      insertHoursAndMinutes: false,
                    );
                    setState(() {});
                  },
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  newValidity != null
                      ? DateFormat('dd/MM/yyyy').format(newValidity!)
                      : 'Nenhuma'.hardcoded,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: newValidity == null
                        ? Colors.red
                        : theme.primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        gapH8,
        Row(
          children: [
            Expanded(
              child: PrimaryButton(
                text: 'Subtrair'.hardcoded,
                onPressed: () => update(isSubtract: true),
              ),
            ),
            gapW8,
            Expanded(
              flex: 2,
              child: PrimaryButton(
                text: 'Somar'.hardcoded,
                onPressed: () => update(isSubtract: false),
              ),
            ),
          ],
        ),
        gapH8,
        Row(
          children: [
            Expanded(
              child: PrimaryButton(
                text: 'Anular'.hardcoded,
                onPressed: hasInsertedQuantity
                    ? () {
                        showAlertDialog(
                          context: context,
                          title: 'Anular'.hardcoded,
                          content: 'Tem certeza que deseja anular a contagem?'
                              .hardcoded,
                          onOkPressed: () {
                            update(isAnnul: true);
                          },
                          defaultActionText: 'Sim'.hardcoded,
                          cancelActionText: 'Não'.hardcoded,
                        );
                      }
                    : null,
                backgroundColor: hasInsertedQuantity
                    ? Colors.red
                    : theme.disabledColor,
              ),
            ),
            gapW8,
            Expanded(
              flex: 3,
              child: Form(
                key: formKey,
                child: DefaultTextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  hintText: 'Quantidade'.hardcoded,
                  labelText: 'Quantidade'.hardcoded,
                  controller: widget.quantityController,
                  validator: FormValidators.compose([
                    NumberValidator(allowDecimal: true, maxDecimalHouses: 3),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
