import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/helpers/helpers.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/synchronizer/presentation/pages/components/components.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SynchronizerPage extends ConsumerWidget {
  const SynchronizerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScaffold(
      isScrollable: false,
      refreshProvider: synchronizerCountStateControllerProvider,
      appBar: BaseAppBar(
        titleWidget: Align(
          alignment: PlatformUtil.isIOS ? .center : .centerLeft,
          child: GestureDetector(
            onLongPress: () =>
                context.pushNamed(Routes.synchronizerManualExecution.name),
            child: BaseText.headline(
              context.l10n.coreModulesSynchronizer,
              fontWeight: .bold,
            ),
          ),
        ),
        subtitle: ModuleIsFreeUntil.isFree(Modules.synchronizer)
            ? BaseText.caption(
                context.l10n.freeUntilDate(
                  ModuleIsFreeUntil.synchronizerLimit.formatDate(),
                ),
                fontStyle: .italic,
                color: context.theme.primaryColor,
              )
            : null,
      ),
      body: AsyncValueWidget(
        value: ref.watch(synchronizerCountStateControllerProvider),
        tryAgain: () =>
            ref.invalidate(synchronizerCountStateControllerProvider),
        data: (errors) {
          errors.removeWhere(
            (e) =>
                e.count <= 0 &&
                !e.errorKey.toLowerCase().contains(
                  context.l10n.salesOrdersReadErrors,
                  //! This error should always be displayed
                ),
          );

          if (errors.isEmpty) {
            return const SynchronizerEmptyErrors();
          }
          return ResponsiveListFlow(
            itemCount: errors.length,
            itemBuilder: (context, index) {
              final error = errors[index];
              return Card(
                clipBehavior: .hardEdge,
                child: InkWell(
                  onTap: () {
                    context.goNamed(
                      Routes.synchronizerDetails.name,
                      pathParameters: {'errorKey': error.errorKey},
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.p8),
                    child: Row(
                      crossAxisAlignment: .end,
                      children: [
                        Expanded(
                          child: BaseRichText(
                            texts: [
                              BaseText.error('(${error.count}) '),
                              BaseText.title(error.description),
                            ],
                          ),
                        ),
                        gapW16,
                        const PlatformIcon(
                          cupertinoIcon: CupertinoIcons.arrow_up_right,
                          materialIcon: Icons.arrow_outward,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
