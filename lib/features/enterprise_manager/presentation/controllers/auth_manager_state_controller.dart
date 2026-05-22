import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:celta_inventario/features/enterprise_manager/providers.dart';

part 'auth_manager_state_controller.g.dart';

@riverpod
Stream<User?> authManagerState(Ref ref) {
  return ref.watch(authManagerRepositoryProvider).onAuthStateChange;
}
