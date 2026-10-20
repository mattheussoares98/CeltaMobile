import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/process_authorization/presentation/models/models.dart';
import 'package:celta_inventario/features/process_authorization/presentation/pages/vote/vote.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OpenVotePageButton extends ConsumerWidget {
  final int processCode;
  final bool showDeviceRotationIcon;
  final bool usePrimaryButton;
  const OpenVotePageButton({
    super.key,
    required this.processCode,
    this.showDeviceRotationIcon = true,
    this.usePrimaryButton = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final process = ref.watch(
      judgmentsStateControllerProvider.select(
        (s) => s.value?.firstWhereOrNull((e) => e.code == processCode),
      ),
    );

    if (process?.status != BSFProcessAuthorizationJudgementStatus.awaiting) {
      return const SizedBox.shrink();
    }

    Future<void> onTap() async {
      final currentProcess = process;
      if (currentProcess == null ||
          currentProcess.status !=
              BSFProcessAuthorizationJudgementStatus.awaiting) {
        showToastMessage(
          context.l10n.thisProcessHasAlreadyBeenReviewed,
          type: .error,
        );
        return;
      }
      final loggedUser = await ref.read(validatedUserSessionProvider.future);
      if (!context.mounted) return;
      final isAuthorizator =
          process?.authorizators?.any(
            (e) =>
                (e.identification?.isNotEmpty ?? false) &&
                e.identification?.toLowerCase().trim() ==
                    loggedUser?.user.name?.toLowerCase().trim(),
          ) ??
          false;

      if (!isAuthorizator) {
        showToastMessage(context.l10n.notAuthorizer, type: ToastType.error);
        return;
      }
      if (context.mounted) {
        final judgments = ref.read(judgmentsStateControllerProvider).value;
        final nextDestination =
            loggedUser?.user.name == null || judgments == null
            ? null
            : ProcessAuthorizationDestination.nextSaleRequestJudgment(
                current: currentProcess,
                judgments: judgments,
                authorizatorIdentification: loggedUser!.user.name!,
              );
        final router = GoRouter.of(context);
        final didVote = await showModalPage<bool>(
          VotePage(processCode: processCode),
          context,
        );
        if (didVote != true) return;

        if (nextDestination != null) {
          router.goNamed(
            nextDestination.route.name,
            pathParameters: nextDestination.pathParameters,
          );
        } else if (currentProcess.enterprise?.code != null) {
          router.goNamed(
            Routes.processAuthorization.name,
            pathParameters: {
              'enterpriseCode': currentProcess.enterprise!.code.toString(),
            },
          );
        }
      }
    }

    Widget voteButton = usePrimaryButton
        ? PrimaryButton(
            text: context.l10n.vote,
            onPressed: process == null ? null : onTap,
          )
        : PrimaryTextButton(
            text: context.l10n.vote,
            onPressed: process == null ? null : onTap,
          );

    if (PlatformUtil.isMobile) {
      return Column(
        mainAxisSize: .min,
        crossAxisAlignment: .end,
        children: [
          if (PlatformUtil.isMobile && showDeviceRotationIcon)
            PlatformIcon(
              materialIcon: Icons.screen_rotation,
              cupertinoIcon: CupertinoIcons.rotate_right,
              color: context.theme.disabledColor,
              size: 14,
            ),
          Flexible(child: voteButton),
        ],
      );
    }
    return voteButton;
  }
}
