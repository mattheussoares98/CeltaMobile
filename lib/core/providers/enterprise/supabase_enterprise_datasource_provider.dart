import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/enterprise/enterprise.dart';
import '../supabase/supabase.dart';

part 'supabase_enterprise_datasource_provider.g.dart';

@riverpod
ISupabaseEnterpriseDatasource supabaseEnterpriseDatasource(Ref ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return SupabaseEnterpriseDatasource(supabase);
}
