import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestTypeDropDown extends ConsumerWidget {
  const RequestTypeDropDown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRequest = ref.watch(
      insertUpdateStateControllerProvider.select((s) => s.value?.requestType),
    );
    return BaseDropDown<BSFRequestTypeEntity>(
      showLabelAtTopLeft: true,
      label: 'Modelo de pedido'.hardcoded,
      selectedItem: selectedRequest,
      items: [
        DropdownMenuItem(
          value: selectedRequest,
          child: Center(child: Text(selectedRequest?.name ?? '')),
        ),
      ],
      onChanged: null,
    );
  }
}
