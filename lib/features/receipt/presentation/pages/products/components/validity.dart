import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Validity extends StatefulWidget {
  final ProductEntity product;
  final DateTime? newValidityDate;
  final void Function(DateTime? newValidityDate) onValidityDateChanged;
  const Validity({
    super.key,
    required this.product,
    required this.newValidityDate,
    required this.onValidityDateChanged,
  });

  @override
  State<Validity> createState() => _ValidityState();
}

class _ValidityState extends State<Validity> {
  DateTime? newValidity;
  final now = DateTime.now();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        setState(() {
          newValidity =
              widget.newValidityDate ??
              widget.product.DataValidade_ProcRecebDocProEmb;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Align(
              alignment: Alignment.centerLeft,
              child: PrimaryTextButton(
                text: 'Nova validade'.hardcoded,
                icon: const PlatformIcon(
                  cupertinoIcon: CupertinoIcons.calendar,
                  materialIcon: Icons.calendar_month,
                ),
                onPressed: () async {
                  newValidity = await GetNewDate.get(
                    minimumDate: now,
                    maximumDate: now.add(const Duration(days: 365 * 10)),
                    context: context,
                    currentSelectedDate: newValidity,
                    insertHoursAndMinutes: false,
                  );
                  widget.onValidityDateChanged(newValidity);
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
                newValidity?.formatDate(DateFormatType.ddMMyyyy) ??
                    'Nenhuma'.hardcoded,
                style: context.theme.textTheme.titleSmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: newValidity == null
                      ? Colors.red
                      : context.theme.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
