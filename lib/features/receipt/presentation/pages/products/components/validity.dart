import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../localization/string_hardcoded.dart';

class Validity extends StatefulWidget {
  final ProductEntity product;
  const Validity({super.key, required this.product});

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
          newValidity = widget.product.DataValidade_ProcRecebDocProEmb;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Row(
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
              newValidity == null &&
                      widget.product.DataValidade_ProcRecebDocProEmb != null
                  ? DateFormat(
                      'dd/MM/yyyy',
                    ).format(widget.product.DataValidade_ProcRecebDocProEmb!)
                  : newValidity != null
                  ? DateFormat('dd/MM/yyyy').format(newValidity!)
                  : 'Nenhuma'.hardcoded,
              style: theme.textTheme.titleSmall?.copyWith(
                fontStyle: FontStyle.italic,
                color:
                    newValidity == null &&
                        widget.product.DataValidade_ProcRecebDocProEmb == null
                    ? Colors.red
                    : theme.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
