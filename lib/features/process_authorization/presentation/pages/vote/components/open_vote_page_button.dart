import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/process_authorization/presentation/pages/vote/vote.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OpenVotePageButton extends ConsumerWidget {
  final int processCode;
  const OpenVotePageButton({super.key, required this.processCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final process = ref.watch(
      judgmentsStateControllerProvider.select(
        (s) => s.value?.firstWhereOrNull((e) => e.code == processCode),
      ),
    );
    final voteButton = PrimaryTextButton(
      text: 'Votar'.hardcoded,
      onPressed: process == null
          ? null
          : () async {
              if (process.status !=
                  BSFProcessAuthorizationJudgementStatus.awaiting) {
                showToastMessage(
                  'Esse processo já foi julgado'.hardcoded,
                  type: .error,
                );
                return;
              }
              final loggedUser = await ref.read(
                validatedUserSessionProvider.future,
              );
              final isAuthorizator =
                  process.authorizators?.any(
                    (e) =>
                        (e.identification?.isNotEmpty ?? false) &&
                        e.identification?.toLowerCase().trim() ==
                            loggedUser?.user.name?.toLowerCase().trim(),
                  ) ??
                  false;

              if (!isAuthorizator) {
                showToastMessage(
                  'Você não é um autorizador. Por isso não pode votar nesse processo',
                  type: ToastType.error,
                );
                return;
              }
              if (context.mounted) {
                showModalPage(VotePage(processCode: processCode), context);
              }
            },
    );

    if (PlatformUtil.isMobile) {
      return Column(
        mainAxisSize: .min,
        crossAxisAlignment: .end,
        children: [
          if (PlatformUtil.isMobile)
            PlatformIcon(
              materialIcon: Icons.screen_rotation,
              cupertinoIcon: CupertinoIcons.rotate_right,
              color: context.theme.disabledColor,
              size: 14,
            ),
          Expanded(child: voteButton),
        ],
      );
    }
    return voteButton;
  }
}
