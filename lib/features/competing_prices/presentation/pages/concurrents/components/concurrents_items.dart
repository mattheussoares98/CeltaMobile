// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/presentation/widgets/address/address.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../../../routing/routing.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import '../../insert_update_concurrent/insert_update_concurrent.dart';

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
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    final mediaQuery = MediaQuery.of(context);

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
        return RefreshIndicator(
          onRefresh: () async =>
              ref.invalidate(concurrentsStateControllerProvider),
          child: ListView.builder(
            itemCount: concurrents.length,
            itemBuilder: (context, index) {
              final concurrent = concurrents[index];

              bool? concurrentBindedInResearch =
                  selectedResearch.Concurrents?.any(
                    (e) => e.ConcurrentCode == concurrent.ConcurrentCode,
                  );

              return Stack(
                children: [
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => onTap(
                        concurrent: concurrent,
                        concurrentBindedInResearch: concurrentBindedInResearch,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(Sizes.p8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TitleAndSubTitle(
                              title: 'Código'.hardcoded,
                              subTitle: concurrent.ConcurrentCode.toString(),
                            ),
                            TitleAndSubTitle(
                              title: 'Nome'.hardcoded,
                              subTitle: concurrent.Name.toString(),
                            ),
                            TitleAndSubTitle(
                              title: null,
                              subTitle: concurrentBindedInResearch == true
                                  ? 'Associado à pesquisa'.hardcoded
                                  : 'Não associado à pesquisa'.hardcoded,
                              subTitleStyle: theme.textTheme.titleMedium
                                  ?.copyWith(
                                    color: concurrentBindedInResearch == true
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                            ),
                            if (concurrent.Observation != null &&
                                concurrent.Observation!.isNotEmpty)
                              TitleAndSubTitle(
                                title: 'Observação'.hardcoded,
                                subTitle: concurrent.Observation.toString(),
                              ),
                            AddressDetails(address: concurrent.Address),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: PrimaryTextButton(
                      text: 'Alterar concorrente'.hardcoded,
                      onPressed: () {
                        showModalPage(
                          InsertUpdateConcurrentPage(
                            concurrentUpdating: concurrent,
                          ),
                          context,
                        );
                      },
                      icon: mediaQuery.size.width < 300
                          ? null
                          : Icon(isIOS ? CupertinoIcons.pencil : Icons.edit),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
