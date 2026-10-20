// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/presentation/widgets/address/address.dart';
import 'package:celta_inventario/features/competing_prices/domain/entities/entities.dart';
import 'package:celta_inventario/features/competing_prices/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/competing_prices/presentation/pages/insert_update_concurrent/insert_update_concurrent.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ConcurrentsItems extends ConsumerWidget {
  final ResearchEntity selectedResearch;
  final int enterpriseCode;
  const ConcurrentsItems({
    super.key,
    required this.selectedResearch,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onTap({
      required ConcurrentEntity concurrent,
      required bool? concurrentBindedInResearch,
    }) async {
      void navigate() {
        context.goNamed(
          Routes.competingPricesProducts.name,
          pathParameters: {
            'concurrentCode': concurrent.ConcurrentCode.toString(),
            'researchCode': selectedResearch.Code.toString(),
            'enterpriseCode': enterpriseCode.toString(),
          },
          extra: {
            'researchName': selectedResearch.Name,
            'concurrentName': concurrent.Name,
          },
        );
      }

      if (concurrentBindedInResearch == true) {
        navigate();
      } else {
        final succeeds = await ref
            .read(insertUpdateResearchControllerProvider.notifier)
            .insertUpdate(
              name: selectedResearch.Name!,
              observations: selectedResearch.Observation,
              researchCode: selectedResearch.Code,
              concurrentToAssociate: concurrent,
              enterpriseCode: enterpriseCode,
            );

        if (succeeds) {
          navigate();
        }
      }
    }

    return AsyncValueWidget(
      value: ref.watch(concurrentsStateControllerProvider),
      tryAgain: () => ref.invalidate(concurrentsStateControllerProvider),
      data: (concurrents) {
        concurrents.sort(
          (a, b) => a.ConcurrentCode.toString().compareTo(
            b.ConcurrentCode.toString(),
          ),
        );
        return ResponsiveListFlow(
          itemCount: concurrents.length,
          itemBuilder: (context, index) {
            final concurrent = concurrents[index];

            bool? concurrentBindedInResearch =
                selectedResearch.Concurrents?.any(
                  (e) => e.ConcurrentCode == concurrent.ConcurrentCode,
                );

            return ConcurrentItem(
              key: ValueKey(concurrent.ConcurrentCode),
              onTap: () => onTap(
                concurrent: concurrent,
                concurrentBindedInResearch: concurrentBindedInResearch,
              ),
              concurrent: concurrent,
              concurrentBindedInResearch: concurrentBindedInResearch,
            );
          },
        );
      },
    );
  }
}

class ConcurrentItem extends StatelessWidget {
  final VoidCallback onTap;
  final ConcurrentEntity concurrent;
  final bool? concurrentBindedInResearch;
  const ConcurrentItem({
    super.key,
    required this.onTap,
    required this.concurrent,
    required this.concurrentBindedInResearch,
  });

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.sizeOf(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TitleAndSubTitle(
                title: context.l10n.code,
                subTitle: concurrent.ConcurrentCode.toString(),
              ),
              TitleAndSubTitle(
                title: context.l10n.name,
                subTitle: concurrent.Name.toString(),
              ),
              TitleAndSubTitle(
                title: null,
                subTitle: concurrentBindedInResearch == true
                    ? context.l10n.associatedWithSurvey
                    : context.l10n.notAssociatedWithSurvey,
                subTitleStyle: context.theme.textTheme.titleMedium?.copyWith(
                  color: concurrentBindedInResearch == true
                      ? Colors.green
                      : Colors.red,
                ),
              ),
              if (concurrent.Observation != null &&
                  concurrent.Observation!.isNotEmpty)
                TitleAndSubTitle(
                  title: context.l10n.notes,
                  subTitle: concurrent.Observation.toString(),
                ),
              AddressDetails(address: concurrent.Address),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PrimaryTextButton(
                    text: context.l10n.editCompetitor,
                    onPressed: () {
                      showModalPage(
                        InsertUpdateConcurrentPage(
                          concurrentUpdating: concurrent,
                        ),
                        context,
                      );
                    },
                    platformIcon: mediaSize.width < 300
                        ? null
                        : const PlatformIcon(
                            cupertinoIcon: CupertinoIcons.pencil,
                            materialIcon: Icons.edit,
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
