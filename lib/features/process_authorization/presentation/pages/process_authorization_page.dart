import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ProcessAuthorizationPage extends ConsumerWidget {
  final int enterpriseCode;
  const ProcessAuthorizationPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScaffold(
      isScrollable: false,
      refreshProvider: judgmentsStateControllerProvider,
      appBar: BaseAppBar(title: 'Autorização de processos'.hardcoded),
      body: AsyncValueWidget(
        value: ref.watch(judgmentsStateControllerProvider),
        tryAgain: () => ref.invalidate(judgmentsStateControllerProvider),
        data: (data) {
          data.removeWhere(
            (e) =>
                e.status == BSFProcessAuthorizationJudgementStatus.authorized,
          );
          final groupedData = groupBy(data, (e) => e.status);

          return ResponsiveListFlow(
            itemCount: groupedData.length,
            itemBuilder: (context, index) {
              final key = groupedData.keys.elementAt(index);
              final value = groupedData.values.elementAt(index);
              return Padding(
                padding: const EdgeInsets.only(bottom: Sizes.p8),
                child: ExpansionTile(
                  title: TitleAndSubTitle(
                    title: key?.label ?? '',
                    subTitle: value.length,
                    removeColon: true,
                    subTitleStyle: context.theme.textTheme.titleSmall?.copyWith(
                      color: context.theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  childrenPadding: const EdgeInsets.all(Sizes.p4),
                  children: value.map((e) {
                    return Card(
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        onTap: () {
                          context.goNamed(
                            Routes.processAuthorizationDetails.name,
                            pathParameters: {
                              'enterpriseCode': e.enterprise!.code.toString(),
                              'processCode': e.code.toString(),
                            },
                          );
                        },
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(Sizes.p8),
                              child: Column(
                                crossAxisAlignment: .stretch,
                                children: [
                                  TitleAndSubTitle(
                                    title: null,
                                    subTitle: e.enterprise?.name ?? '',
                                  ),
                                  TitleAndSubTitle(
                                    title: null,
                                    subTitle:
                                        e
                                            .authorizationProcessItem
                                            ?.category
                                            ?.name ??
                                        '',
                                  ),
                                  DefaultText.titleMedium(
                                    e.authorizationProcessItem?.name ?? '',
                                  ),
                                  if (e.dateTimeOfCreation != null)
                                    TitleAndSubTitle(
                                      title: 'Data',
                                      subTitle: DateFormat(
                                        'dd/MM/yyyy HH:mm:ss',
                                      ).format(e.dateTimeOfCreation!),
                                    ),
                                  TitleAndSubTitle(
                                    title: 'Processo iniciado por',
                                    subTitle: e.user?.identification,
                                  ),
                                ],
                              ),
                            ),
                            const Positioned(
                              bottom: Sizes.p8,
                              right: Sizes.p8,
                              child: PlatformIcon(
                                materialIcon: Icons.arrow_outward_rounded,
                                cupertinoIcon: CupertinoIcons.arrow_up_right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
