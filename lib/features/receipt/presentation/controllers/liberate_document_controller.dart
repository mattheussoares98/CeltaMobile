import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../providers.dart';

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

      await ref
          .read(soapLiberateDocumentDatasourceProvider)
          .liberate(
            baseUrl: validatedUser!.enterprise!.baseUrl!,
            crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
            CodigoInterno_ProcRecebDoc: CodigoInterno_ProcRecebDoc,
          );
    });
  }
}
