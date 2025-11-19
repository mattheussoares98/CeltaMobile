import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../domain/entities/entities.dart';
import '../../providers/providers.dart';

part 'concurrents_state_controller.g.dart';

@riverpod
class ConcurrentsStateController extends _$ConcurrentsStateController {
  @override
  Future<List<ConcurrentEntity>> build() async {
    final validatedUser = await ref.watch(validatedUserSessionProvider.future);

    return await ref
        .read(soapLoadConcurrentsRepositoryProvider)
        .load(
          crossIdentity: validatedUser!.user.CrossIdentity_Usuario!,
          baseUrl: validatedUser.enterprise!.baseUrl!,
          searchValue: null,
        );
  }
}
