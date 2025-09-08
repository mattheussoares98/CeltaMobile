import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/database_keys.dart';
import '../data/data_source/enterprise/enterprise.dart';
import '../domain/contracts/contracts.dart';
import '../infraestructure/infrastructure.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
Box hiveBox(Ref ref) {
  return Hive.box(DatabaseKeys.application.name);
}

@Riverpod(keepAlive: true)
HttpClient httpClient(Ref ref) {
  return HttpAdapter(http.Client());
}

@Riverpod(keepAlive: true)
SupabaseClient supabaseClient(Ref ref) {
  return Supabase.instance.client;
}

@Riverpod(keepAlive: true)
SoapAdapter soapAdapter(Ref ref) {
  final client = ref.watch(httpClientProvider);
  return SoapAdapter(client);
}

@Riverpod(keepAlive: true)
ISupabaseEnterpriseDatasource supabaseEnterpriseDatasource(Ref ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return SupabaseEnterpriseDatasource(supabase);
}
