import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/synchronizer/presentation/pages/components/components.dart';
import 'package:celta_inventario/features/synchronizer/presentation/pages/details/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SynchronizerProductsWithErrosPage extends ConsumerStatefulWidget {
  const SynchronizerProductsWithErrosPage({
    super.key,
    required this.items,
    required this.errorKey,
  });
  final List<BSFProductWithErrorSynchronizerErrorGroupEntity> items;
  final String errorKey;

  @override
  ConsumerState<SynchronizerProductsWithErrosPage> createState() =>
      _SynchronizerProductsWithErrosPageState();
}

class _SynchronizerProductsWithErrosPageState
    extends ConsumerState<SynchronizerProductsWithErrosPage> {
  int currentIndex = 0; //TODO create a separated controller for this

  @override
  Widget build(BuildContext context) {
    final activeType = BSFProductWithErrorType.values[currentIndex];

    final selectedCodes = ref.watch(
      selectedSynchronizerCodesStateControllerProvider(
        SynchronizerErrorDetailType.productWithError,
      ),
    );
    final hasSelected = selectedCodes.isNotEmpty;

    final group = widget.items.firstWhereOrNull((e) => e.type == activeType);
    final allCodes = group?.errors.map((e) => e.code).toList() ?? const [];

    List<ProductWithErrorActionParams> getParams(List<int> targetCodes) {
      if (group == null) return [];
      return group.errors
          .where((e) => targetCodes.contains(e.code))
          .map(
            (e) => ProductWithErrorActionParams(
              enterpriseCode: e.enterpriseCode,
              productCode: e.code,
              productPackingCode: e.productPackingCode,
              enterpriseCommerceSiteCode: e.enterpriseCommerceSiteCode,
            ),
          )
          .toList();
    }

    final notifier = ref.read(handleSelectedCodesControllerProvider.notifier);

    final List<SelectableAction> actions = [];

    if (group != null && group.errors.isNotEmpty) {
      switch (activeType) {
        case BSFProductWithErrorType.error:
          actions.addAll([
            SelectableAction(
              label: 'Reenviar todos'.hardcoded,
              onPressed: () => notifier.markProductsToSendAgain(
                getParams(allCodes),
                widget.errorKey,
              ),
            ),
            SelectableAction(
              label: 'Reenviar selecionados'.hardcoded,
              onPressed: hasSelected
                  ? () => notifier.markProductsToSendAgain(
                      getParams(selectedCodes.toList()),
                      widget.errorKey,
                    )
                  : null,
            ),
            SelectableAction(
              label: 'Ignorar todos'.hardcoded,
              onPressed: () => notifier.markProductsToIgnoreError(
                getParams(allCodes),
                widget.errorKey,
              ),
            ),
            SelectableAction(
              label: 'Ignorar selecionados'.hardcoded,
              onPressed: hasSelected
                  ? () => notifier.markProductsToIgnoreError(
                      getParams(selectedCodes.toList()),
                      widget.errorKey,
                    )
                  : null,
            ),
          ]);
        case BSFProductWithErrorType.markedToSendAgain:
          actions.addAll([
            SelectableAction(
              label: 'Desmarcar todos'.hardcoded,
              onPressed: () => notifier.unmarkProductsToSendAgain(
                getParams(allCodes),
                widget.errorKey,
              ),
            ),
            SelectableAction(
              label: 'Desmarcar selecionados'.hardcoded,
              onPressed: hasSelected
                  ? () => notifier.unmarkProductsToSendAgain(
                      getParams(selectedCodes.toList()),
                      widget.errorKey,
                    )
                  : null,
            ),
          ]);
        case BSFProductWithErrorType.markedToIgnoreError:
          break;
      }
    }

    return BaseScaffold(
      isScrollable: false,
      usePadding: false,
      bottomNavigationBar: BaseBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) => setState(() {
          currentIndex = value;
        }),
        items: BSFProductWithErrorType.values.map((type) {
          final group = widget.items.firstWhereOrNull((e) => e.type == type);
          final quantity = group?.errors.length ?? 0;

          final IconData materialIcon;
          final IconData cupertinoIcon;

          switch (type) {
            case BSFProductWithErrorType.error:
              materialIcon = Icons.error_outline;
              cupertinoIcon = CupertinoIcons.exclamationmark_circle;
            case BSFProductWithErrorType.markedToSendAgain:
              materialIcon = Icons.sync;
              cupertinoIcon = CupertinoIcons.refresh;
            case BSFProductWithErrorType.markedToIgnoreError:
              materialIcon = Icons.visibility_off_outlined;
              cupertinoIcon = CupertinoIcons.eye_slash;
          }

          final String label = switch (type) {
            BSFProductWithErrorType.error => 'Erro'.hardcoded,
            BSFProductWithErrorType.markedToSendAgain => 'Reenviar'.hardcoded,
            BSFProductWithErrorType.markedToIgnoreError =>
              'Ignorados'.hardcoded,
          };

          return BaseBottomNavigationBarItem(
            label: label,
            platformIcon: PlatformIcon(
              materialIcon: materialIcon,
              cupertinoIcon: cupertinoIcon,
            ),
            badgeLabel: quantity.toString(),
          );
        }).toList(),
      ),
      body: Column(
        children: [
          SelectableActions(
            detailType: SynchronizerErrorDetailType.productWithError,
            errorKey: widget.errorKey,
            selectableItems: widget.items,
            actions: actions,
          ),
          Expanded(
            child: IndexedStack(
              index: currentIndex,
              children: BSFProductWithErrorType.values.map((type) {
                final group = widget.items.firstWhereOrNull(
                  (e) => e.type == type,
                );
                final errors = group?.errors ?? const [];

                if (errors.isEmpty) return const SynchronizerEmptyErrors();

                final groupedErrors = groupBy(
                  errors,
                  (e) => e.enterprisePersonalizedCode,
                );
                final keys = groupedErrors.keys.toList();

                return ResponsiveListFlow(
                  itemCount: keys.length,
                  padding: const EdgeInsets.all(Sizes.p8),
                  itemBuilder: (context, index) {
                    final code = keys[index];
                    final enterpriseErrors = groupedErrors[code] ?? [];
                    final fantasyName =
                        enterpriseErrors.firstOrNull?.enterpriseFantasyName ??
                        '';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: Sizes.p8),
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        title: BaseRichText(
                          texts: [
                            BaseText.title('$code - $fantasyName '),
                            BaseText.title(
                              '(${enterpriseErrors.length})',
                              color: Colors.red,
                            ),
                          ],
                        ),
                        children: enterpriseErrors.map((item) {
                          return SynchronizerProductErrorItem(item: item);
                        }).toList(),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
