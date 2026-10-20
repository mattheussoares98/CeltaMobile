import 'package:celta_inventario/features/process_authorization/presentation/localization/localization.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/process_authorization/presentation/models/models.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProcessesItems extends ConsumerWidget {
  final BSFProcessAuthorizationJudgementStatus status;
  const ProcessesItems({super.key, required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onTap(BSFProcessAuthorizationJudgmentEntity process) async {
      final type = process.authorizationProcessItem?.typeAccordingToTheCode;
      final destination = ProcessAuthorizationDestination.fromJudgment(process);
      if (destination == null) {
        showToastMessage(
          context.l10n.unsupportedAuthorizationType(
            type == null ? '' : context.l10n.authorizationProcessType(type),
          ),
          type: ToastType.error,
        );
        return;
      }

      if (context.mounted) {
        context.goNamed(
          destination.route.name,
          pathParameters: destination.pathParameters,
        );
      }
    }

    return AsyncValueWidget(
      value: ref.watch(judgmentsStateControllerProvider),
      tryAgain: () => ref.invalidate(judgmentsStateControllerProvider),
      data: (data) {
        final filteredData = data.where((e) => e.status == status).toList();

        if (filteredData.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: .center,
              children: [
                BaseRichText(
                  textAlign: .center,
                  texts: [
                    BaseText.title(context.l10n.noProcessesFoundWithStatus),
                    BaseText.error(
                      '${context.l10n.authorizationStatus(status).toLowerCase()} ',
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        filteredData.sort((a, b) {
          final timeA = a.dateTimeOfCreation;
          final timeB = b.dateTimeOfCreation;

          if (timeA == null && timeB == null) return 0;
          if (timeA == null) return -1;
          if (timeB == null) return 1;

          return timeB.compareTo(timeA);
        });

        final groupedProcesses = groupBy(filteredData, (process) {
          final destination = ProcessAuthorizationDestination.fromJudgment(
            process,
          );
          if (destination?.route == Routes.processAuthorizationSaleRequest &&
              destination?.saleRequestCode != null) {
            return (
              'saleRequest',
              destination!.enterpriseCode,
              destination.saleRequestCode,
            );
          }
          return (
            'type',
            process.authorizationProcessItem?.typeAccordingToTheCode,
          );
        });

        return ListView.builder(
          padding: .zero,
          itemCount: groupedProcesses.keys.length,
          itemBuilder: (context, index) {
            final processes = groupedProcesses.values.elementAt(index);
            final firstProcess = processes.first;
            final type =
                firstProcess.authorizationProcessItem?.typeAccordingToTheCode;
            final destination = ProcessAuthorizationDestination.fromJudgment(
              firstProcess,
            );
            final title = destination?.saleRequestCode != null
                ? context.l10n.salesOrderWithCode(
                    (destination?.saleRequestNumber ??
                            destination?.saleRequestCode)
                        .toString(),
                  )
                : type == null
                ? null
                : context.l10n.authorizationProcessType(type);
            return Padding(
              padding: const EdgeInsets.only(bottom: Sizes.p8),
              child: ExpansionTile(
                title: BaseRichText(
                  texts: [
                    BaseText.title('$title '),
                    BaseText("(${processes.length})", color: Colors.red),
                  ],
                ),
                children: processes
                    .map(
                      (process) => Card(
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          onTap: () => onTap(process),
                          child: Padding(
                            padding: const EdgeInsets.all(Sizes.p8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TitleAndSubTitle(
                                  title: null,
                                  subTitle: process.enterprise?.name ?? '',
                                ),
                                BaseText.titleMedium(
                                  process.authorizationProcessItem?.name ?? '',
                                ),
                                if (process.dateTimeOfCreation != null)
                                  TitleAndSubTitle(
                                    title: context.l10n.date,
                                    subTitle: process.dateTimeOfCreation!
                                        .formatDate(
                                          DateFormatType.ddMMyyyyHHmmss,
                                        ),
                                  ),
                                TitleAndSubTitle(
                                  title: context.l10n.processStartedBy,
                                  subTitle: process.user?.identification,
                                ),
                                if (process.authorizators?.isNotEmpty ?? false)
                                  TitleAndSubTitle(
                                    title: context.l10n.authorizers,
                                    subTitle: process.authorizators
                                        ?.map((e) => e.identification)
                                        .join('; '),
                                  ),
                                if (process.observationsVotes?.isNotEmpty ??
                                    false)
                                  TitleAndSubTitle(
                                    title: context.l10n.notes,
                                    subTitle: process.observationsVotes,
                                  ),
                                if (process.votes?.isNotEmpty ?? false) ...[
                                  ...List.generate(process.votes!.length, (
                                    index,
                                  ) {
                                    final vote = process.votes![index];
                                    return Column(
                                      crossAxisAlignment: .start,
                                      children: [
                                        if ((index + 1) <=
                                            process.votes!.length)
                                          const Divider(),
                                        if (index == 0)
                                          BaseText.titleMedium(
                                            context.l10n.reviews,
                                            color: Colors.red,
                                          ),
                                        TitleAndSubTitle(
                                          title: context.l10n.username,
                                          subTitle: vote.user?.identification,
                                        ),
                                        if (vote.observations?.isNotEmpty ??
                                            false)
                                          TitleAndSubTitle(
                                            title: context.l10n.notes,
                                            subTitle: vote.observations,
                                          ),
                                      ],
                                    );
                                  }),
                                  const Align(
                                    alignment: .centerRight,
                                    child: PlatformIcon(
                                      materialIcon: Icons.arrow_outward_rounded,
                                      cupertinoIcon:
                                          CupertinoIcons.arrow_up_right,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            );
          },
        );
      },
    );
  }
}
