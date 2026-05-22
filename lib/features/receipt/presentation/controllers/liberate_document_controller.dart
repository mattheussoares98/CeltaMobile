import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/receipt/providers.dart';
import 'package:celta_inventario/features/receipt/presentation/controllers/controllers.dart';

part 'liberate_document_controller.g.dart';

@riverpod
class LiberateDocumentController extends _$LiberateDocumentController {
  @override
  FutureOr<void> build(int CodigoInterno_ProcRecebDoc) {}

  Future<void> liberate() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final validatedUser = await ref.watch(
        validatedUserSessionProvider.future,
      );

      ref
          .read(appUsageStateControllerProvider.notifier)
          .addUsage(UsageType.liberateReceiptDocument);

      await ref
          .read(soapLiberateDocumentDatasourceProvider)
          .liberate(
            workingUrl: validatedUser!.enterprise!.workingUrl!,
            crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
            CodigoInterno_ProcRecebDoc: CodigoInterno_ProcRecebDoc,
          );
      ref.invalidate(receiptsStateControllerProvider);
    });
  }
}
