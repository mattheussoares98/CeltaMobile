import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/buy_movement/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectDateAndSearchButton extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const SelectDateAndSearchButton({super.key, required this.enterpriseCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectDateAndSearchButtonState();
}

class _SelectDateAndSearchButtonState
    extends ConsumerState<SelectDateAndSearchButton> {
  static final now = DateTime.now();
  DateTime selectedDate = now;

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(
      shallowBuyMovementStateControllerProvider(
        widget.enterpriseCode,
      ).select((s) => s.isLoading),
    );
    return IgnorePointer(
      ignoring: isLoading,
      child: Row(
        mainAxisAlignment: .spaceEvenly,
        children: [
          Flexible(
            child: PrimaryButton(
              text: 'Data inicial '.hardcoded + selectedDate.formatDate(),
              onPressed: () async {
                final newDate = await GetNewDate.get(
                  currentSelectedDate: selectedDate,
                  minimumDate: now.subtract(const Duration(days: 365 * 5)),
                  maximumDate: now,
                  insertHoursAndMinutes: false,
                  context: context,
                );

                if (newDate != null) {
                  setState(() {
                    selectedDate = newDate;
                  });
                }
              },
            ),
          ),
          PrimaryTextButton(
            text: 'Pesquisar'.hardcoded,
            onPressed: () => ref
                .read(
                  shallowBuyMovementStateControllerProvider(
                    widget.enterpriseCode,
                  ).notifier,
                )
                .load(selectedDate),
          ),
        ],
      ),
    );
  }
}
