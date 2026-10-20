import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/process_authorization/presentation/pages/goods_receiving_validate_doc_xml/goods_receiving_validate_doc_xml.dart';
import 'package:celta_inventario/features/process_authorization/presentation/pages/vote/components/components.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GRValidateDocXmlPage extends ConsumerStatefulWidget {
  final int processCode;
  const GRValidateDocXmlPage({super.key, required this.processCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GRValidateDocXmlPageState();
}

class _GRValidateDocXmlPageState extends ConsumerState<GRValidateDocXmlPage> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    super.dispose();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final provider = gRDocFiscalNoteDifferencesStateControllerProvider(
      widget.processCode,
    );
    final uiController = gRValidateDocXmlUiControllerProvider(
      widget.processCode,
    );
    final productsWithtoutRegister = ref.watch(
      provider.select((s) => s.value?.productsWithoutCadaster ?? []),
    );

    final judgmentController = judgmentControllerProvider(widget.processCode);

    ref.observeLoading([judgmentController]);
    ref.listen(judgmentController, (previous, next) {
      next.showAlertDialogOnError(context);
      next.doOnSuccess(previous, () {
        ref.invalidate(provider);
      });
    });

    return BaseScaffold(
      isScrollable: false,
      refreshProvider: provider,
      usePadding: false,
      appBar: BaseAppBar(
        title: context.l10n.xmlDifferences,
        actions: [OpenVotePageButton(processCode: widget.processCode)],
      ),
      bottomNavigationBar: Consumer(
        builder: (_, ref, _) {
          final currentIndex = ref.watch(
            uiController.select((s) => s.selectedPageIndex),
          );
          final (notJudgedQuantity, judgedQuantity) = ref.watch(
            provider.select((s) {
              final value = s.value;
              return (
                value
                        ?.productsWithoutJudgementStatusRequestForFiscalNote
                        ?.length ??
                    0,
                value
                        ?.productsWithJudgementStatusRequestForFiscalNote
                        ?.length ??
                    0,
              );
            }),
          );

          return BaseBottomNavigationBar(
            items: [
              BaseBottomNavigationBarItem(
                platformIcon: const PlatformIcon(
                  cupertinoIcon: CupertinoIcons.doc,
                  materialIcon: Icons.list,
                ),
                label: context.l10n.notReviewed,
                badgeLabel: notJudgedQuantity.toString(),
              ),
              BaseBottomNavigationBarItem(
                platformIcon: const PlatformIcon(
                  cupertinoIcon: CupertinoIcons.doc_checkmark,
                  materialIcon: Icons.check_box,
                ),
                label: context.l10n.reviewed,
                badgeLabel: judgedQuantity.toString(),
              ),
              if (productsWithtoutRegister.isNotEmpty)
                BaseBottomNavigationBarItem(
                  platformIcon: const PlatformIcon(
                    cupertinoIcon: CupertinoIcons.question,
                    materialIcon: Icons.question_mark_rounded,
                  ),
                  badgeLabel: productsWithtoutRegister.length.toString(),
                  label: context.l10n.notRegistered,
                ),
            ],
            currentIndex: currentIndex,
            onTap:
                productsWithtoutRegister.length == 1 &&
                    ref.watch(provider.select((s) => s.isLoading)) == true
                //!when link the lat product, hide the not found products bottom navigation bar
                ? (_) {}
                : ref.read(uiController.notifier).updatePageIndex,
          );
        },
      ),
      body: AsyncValueWidget(
        value: ref.watch(provider),
        tryAgain: () => ref.invalidate(provider),
        data: (data) {
          return IndexedStack(
            index: ref.watch(uiController.select((s) => s.selectedPageIndex)),
            children: [
              GRValidateDocXmlProductsTable(
                areJudgedItems: false,
                processCode: widget.processCode,
              ),
              GRValidateDocXmlProductsTable(
                areJudgedItems: true,
                processCode: widget.processCode,
              ),
              if (productsWithtoutRegister.isNotEmpty)
                ProductsWithoutRegisterPage(processCode: widget.processCode),
            ],
          );
        },
      ),
    );
  }
}
