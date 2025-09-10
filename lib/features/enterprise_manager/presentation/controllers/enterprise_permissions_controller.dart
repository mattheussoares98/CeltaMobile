import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'enterprise_permissions_controller.g.dart';

@riverpod
Future<EnterprisePermissionEntity?> enterprisePermissions(
  Ref ref,
  int enterpriseId,
) {
  final repository = ref.watch(enterpriseManagerRepositoryProvider);

  return repository.getEnterprisePermissionsById(enterpriseId);
}
