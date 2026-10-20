import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/components.dart';

class PrintButton extends ConsumerWidget {
  final int enterpriseCode;
  final int? saleRequestId;
  final int? customerCode;
  const PrintButton({
    super.key,
    required this.enterpriseCode,
    this.saleRequestId,
    this.customerCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> showDialog() async {
      showAlertDialog(
        context: context,
        title: context.l10n.print,
        actions: [],
        contentWidget: SizedBox(
          height: 200,
          child: IpToPrintPage(
            enterpriseCode: enterpriseCode,
            saleRequestId: saleRequestId,
            customerCode: customerCode,
          ),
        ),
      );
    }

    final provider = saleRequestDetailsStateControllerProvider(
      ref.read(saleRequestArgsProvider),
    );

    final canPrint = ref.watch(
      provider.select((s) => s.value != null && !s.isLoading),
    );

    return IconButton(
      icon: const PlatformIcon(
        cupertinoIcon: CupertinoIcons.printer,
        materialIcon: Icons.print,
      ),
      onPressed: canPrint ? showDialog : null,
    );
  }
}
