import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers.dart';

part 'auth_manager_state_controller.g.dart';

@riverpod
Stream<User?> authManagerState(Ref ref) {
  return ref.watch(authManagerRepositoryProvider).onAuthStateChange;
}
