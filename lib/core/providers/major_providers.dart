import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/database_keys.dart';
import '../data/datasource/datasource.dart';
import '../domain/repositories/repositores.dart';
import '../infraestructure/infrastructure.dart';

part 'major_providers.g.dart';

@Riverpod(keepAlive: true)
Box hiveBox(Ref ref) {
  return Hive.box(DatabaseKeys.application.name);
}

@Riverpod(keepAlive: true)
http.Client client(Ref ref) {
  return http.Client();
}

@Riverpod(keepAlive: true)
SupabaseClient supabaseClient(Ref ref) {
  return Supabase.instance.client;
}

@Riverpod(keepAlive: true)
SoapAdapter soapAdapter(Ref ref) {
  final client = ref.watch(clientProvider);
  return SoapAdapter(client);
}

@riverpod
ISupabaseEnterpriseDatasource supabaseEnterpriseDatasource(Ref ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return SupabaseEnterpriseDatasource(supabase);
}

@riverpod
ISoapEnterpriseDatasource soapEnterpriseDatasource(Ref ref) {
  final soapAdapter = ref.watch(soapAdapterProvider);
  return SoapEnterpriseDatasource(soapAdapter: soapAdapter);
}

@riverpod
IEnterpriseRepository enterpriseRepository(Ref ref) {
  final supabaseEnterpriseDatasource = ref.watch(
    supabaseEnterpriseDatasourceProvider,
  );
  final soapEnterpriseDatasource = ref.watch(soapEnterpriseDatasourceProvider);

  return EnterpriseRepositoryImpl(
    supabaseEnterpriseDatasource: supabaseEnterpriseDatasource,
    soapEnterpriseDatasource: soapEnterpriseDatasource,
  );
}

@riverpod
ILocalUserSessionDatasource localUserSessionDatasource(Ref ref) {
  return LocalUserSessionDatasource(ref.watch(hiveBoxProvider));
}

@riverpod
ILocalUserSessionRepository localSessionRepository(Ref ref) {
  return LocalUserSessionRepositoryImpl(
    ref.watch(localUserSessionDatasourceProvider),
  );
}

@riverpod
ISoapProductsDatasource soapProductsDatasource(Ref ref) {
  return SoapProductsDatasource(ref.watch(soapAdapterProvider));
}

@riverpod
ISoapProductsRepository soapProductsRepository(Ref ref) {
  return SoapProductsRepositoryImpl(ref.watch(soapProductsDatasourceProvider));
}
