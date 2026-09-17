import 'dart:math';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/details/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

part './components/appbar_actions.dart';
part './components/print_label_details_body.dart';

class PrintLabelLayoutDetailsPage extends ConsumerWidget {
  final int enterpriseCode;
  final int labelCode;
  final bool showProblemReportAction;

  const PrintLabelLayoutDetailsPage({
    super.key,
    required this.enterpriseCode,
    required this.labelCode,
    this.showProblemReportAction = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = printLabelLayoutDetailsControllerProvider(labelCode);
    final saveProvider = printLabelLayoutSaveControllerProvider(labelCode);
    final layoutName = ref.watch(provider.select((s) => s.value?.name));

    ref.observeLoading([saveProvider]);

    ref.listen(saveProvider, (p, n) {
      n.showAlertDialogOnError(context);
      n.showToastOnSuccess(
        context,
        previous: p,
        message: 'Leiaute salvo com sucesso'.hardcoded,
      );
    });

    void onPop() async {
      if (ref.read(provider.notifier).shouldConfirmPop) {
        final confirmed = await showAlertDialog(
          context: context,
          title: "Atenção".hardcoded,
          content:
              'Todas alterações realizadas serão perdidas. Deseja realmente fechar a tela?'
                  .hardcoded,
          cancelActionText: 'Não'.hardcoded,
          defaultActionText: 'Descartar alterações'.hardcoded,
        );

        if (confirmed != true || !context.mounted) return;
        ref.invalidate(provider);
        context.pop();
      } else {
        context.pop();
      }
    }

    return BaseScaffold(
      isScrollable: false,
      onPopInvokedWithResult: onPop,
      refreshProvider: provider,
      refreshConfirmationMessage: ref.read(provider.notifier).shouldConfirmPop
          ? 'Todas as alterações realizadas serão perdidas. Deseja realmente atualizar os dados?'
                .hardcoded
          : null,
      padding: const .fromLTRB(Sizes.p8, 0, Sizes.p8, Sizes.p8),
      appBar: BaseAppBar(
        title: layoutName ?? 'Detalhes do leiaute'.hardcoded,
        actions: [
          _AppbarActions(
            showProblemReportAction: showProblemReportAction,
            enterpriseCode: enterpriseCode,
            labelCode: labelCode,
          ),
        ],
      ),
      body: AsyncValueWidget(
        value: ref.watch(provider),
        tryAgain: () => ref.invalidate(provider),
        data: (layout) {
          List<Widget> items = [
            PrintLabelLayoutGeneralInformation(layout: layout),
            PrintLabelLayoutPrinterParameters(layout: layout),
            PrintLabelLayoutFormParameters(layout: layout),
            PrintLabelLayoutLabelParameters(layout: layout),
          ];

          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final isWide = width >= Breakpoint.desktop;
              final preview = ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: isWide
                      ? double.infinity
                      : min(constraints.maxHeight * 0.3, 250),
                  maxWidth: isWide ? width / 2 : constraints.maxHeight,
                ),
                child: PrintLabelLayoutPreview(layout: layout),
              );

              final body = Expanded(
                child: _PrintLabelDetailsBody(
                  key: ValueKey(isWide.toString()),
                  items: items,
                  layout: layout,
                  isWide: isWide,
                ),
              );

              return isWide
                  ? Row(children: [preview, gapW16, body])
                  : Column(children: [preview, gapH8, body]);
            },
          );
        },
      ),
    );
  }
}
