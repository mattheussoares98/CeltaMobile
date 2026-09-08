import 'dart:math';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/details/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PrintLabelLayoutDetailsPage extends ConsumerWidget {
  final int labelCode;

  const PrintLabelLayoutDetailsPage({super.key, required this.labelCode});

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

    return BaseScaffold(
      isScrollable: false,
      onPopInvokedWithResult: () {
        if (ref.read(provider.notifier).shouldConfirmPop) {
          showAlertDialog(
            context: context,
            title: "Atenção".hardcoded,
            content:
                'Todas alterações realizadas serão perdidas. Deseja realmente fechar a tela?'
                    .hardcoded,
            cancelActionText: 'Não'.hardcoded,
            defaultActionText: 'Descartar alterações'.hardcoded,
            onOkPressed: () {
              ref.invalidate(provider);
              context.pop();
            },
          );
        } else {
          context.pop();
        }
      },
      refreshProvider: provider,
      padding: const .fromLTRB(Sizes.p8, 0, Sizes.p8, Sizes.p8),
      appBar: BaseAppBar(
        title: layoutName ?? 'Detalhes do leiaute'.hardcoded,
        actions: [
          IconButton(
            key: const Key('report-print-label-problem'),
            tooltip: 'Relatar problema'.hardcoded,
            onPressed: () {
              if (ref.read(provider.notifier).shouldConfirmPop) {
                showAlertDialog(
                  context: context,
                  title: 'Salve o leiaute'.hardcoded,
                  content:
                      'Salve ou descarte as alterações antes de relatar um problema.'
                          .hardcoded,
                  defaultActionText: 'OK'.hardcoded,
                );
                return;
              }
              context.pushNamed(Routes.printLabelProblemReport.name);
            },
            icon: const PlatformIcon(
              cupertinoIcon: CupertinoIcons.exclamationmark_bubble,
              materialIcon: Icons.report_problem_outlined,
            ),
          ),
          Consumer(
            builder: (_, ref, _) {
              final isSaving = ref.watch(
                saveProvider.select((s) => s.isLoading),
              );

              return IconButton(
                key: const Key('save-print-label-layout'),
                tooltip: 'Salvar'.hardcoded,
                onPressed: isSaving
                    ? null
                    : () {
                        showAlertDialog(
                          context: context,
                          title: 'Salvar alterações'.hardcoded,
                          content: 'Deseja realmente salvar as alterações?'
                              .hardcoded,
                          defaultActionText: 'Sim'.hardcoded,
                          cancelActionText: 'Não'.hardcoded,
                          onOkPressed: ref.read(saveProvider.notifier).save,
                        );
                      },
                icon: const PlatformIcon(
                  cupertinoIcon: CupertinoIcons.check_mark,
                  materialIcon: Icons.save_outlined,
                ),
              );
            },
          ),
        ],
      ),
      body: AsyncValueWidget(
        value: ref.watch(provider),
        tryAgain: () => ref.invalidate(provider),
        data: (layout) {
          final coordinateUnit = layout.coordinateUnit;
          List<Widget> items = [
            PrintLabelLayoutGeneralInformation(layout: layout),
            PrintLabelLayoutPrinterParameters(layout: layout),
            PrintLabelLayoutFormParameters(layout: layout),
            PrintLabelLayoutLabelParameters(layout: layout),
          ];

          return LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: min(constraints.maxHeight * 0.3, 250),
                    ),
                    child: PrintLabelLayoutPreview(layout: layout),
                  ),
                  gapH8,
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        gapSliverH8,
                        SliverToBoxAdapter(
                          child: ExpansionTile(
                            title: BaseText.title('Configurações'.hardcoded),
                            subtitle: BaseText.caption(
                              'Impressora, formulário e etiqueta'.hardcoded,
                            ),
                            tilePadding: const .symmetric(horizontal: Sizes.p8),
                            children: [
                              Wrap(
                                spacing: Sizes.p8,
                                runSpacing: Sizes.p8,
                                children: [
                                  ...items.map(
                                    (e) => SizedBox(width: 380, child: e),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        gapSliverH8,
                        SliverToBoxAdapter(
                          child: Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [
                              BaseText.title(
                                'Campos (${layout.fields.length})'.hardcoded,
                              ),
                              Flexible(
                                child: PrintLabelLayoutAddFieldButton(
                                  layoutCode: layout.code,
                                ),
                              ),
                            ],
                          ),
                        ),
                        gapSliverH8,
                        if (layout.fields.isEmpty)
                          SliverToBoxAdapter(
                            child: BaseText.caption(
                              'Nenhum campo configurado'.hardcoded,
                            ),
                          )
                        else
                          ResponsiveListFlow(
                            isSliver: true,
                            itemCount: layout.fields.length,
                            itemBuilder: (context, index) {
                              final field = layout.fields[index];
                              final controller = ref.read(
                                printLabelLayoutDetailsControllerProvider(
                                  layout.code,
                                ).notifier,
                              );

                              return ExpansionTile(
                                title: BaseText.title(field.field?.name ?? ''),
                                subtitle:
                                    field.previewValue?.isNotEmpty == true ||
                                        field.field?.content.isNotEmpty == true
                                    ? BaseText.caption(
                                        field.previewValue ??
                                            field.field!.content,
                                      )
                                    : null,
                                tilePadding: const .only(left: Sizes.p8),
                                trailing: Row(
                                  mainAxisSize: .min,
                                  children: [
                                    IconButton(
                                      onPressed: () => controller
                                          .toggleFieldVisibility(index),
                                      tooltip: field.isVisible
                                          ? 'Ocultar do preview'.hardcoded
                                          : 'Exibir no preview'.hardcoded,
                                      icon: PlatformIcon(
                                        cupertinoIcon: field.isVisible
                                            ? CupertinoIcons.eye
                                            : CupertinoIcons.eye_slash,
                                        materialIcon: field.isVisible
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                      ),
                                    ),

                                    IconButton(
                                      onPressed: () {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        showAlertDialog(
                                          context: context,
                                          title: 'Remover item?'.hardcoded,
                                          onOkPressed: () =>
                                              controller.removeField(index),
                                          cancelActionText:
                                              'Cancelar'.hardcoded,
                                          defaultActionText:
                                              'Remover'.hardcoded,
                                        );
                                      },
                                      icon: const PlatformIcon(
                                        cupertinoIcon: CupertinoIcons.delete,
                                        materialIcon: Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                children: [
                                  PrintLabelLayoutFieldItem(
                                    key: ValueKey(index),
                                    showVisibilityButton: false,
                                    layoutCode: layout.code,
                                    fieldIndex: index,
                                    field: field,
                                    coordinateUnit: coordinateUnit,
                                  ),
                                ],
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
