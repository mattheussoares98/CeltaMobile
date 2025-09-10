import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'permission_details_controller.g.dart';

@riverpod
Future<EnterprisePermissionEntity?> permissionDetailsController(
  Ref ref,
  int enterpriseId,
) {
  final repository = ref.watch(enterpriseManagerRepositoryProvider);

  return repository.getEnterprisePermissionsById(enterpriseId);
}
