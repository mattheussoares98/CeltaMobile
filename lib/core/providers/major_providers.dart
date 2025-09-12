import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/database_keys.dart';
import '../data/datasource/enterprise/enterprise.dart';
import '../data/datasource/session/session.dart';
import '../domain/contracts/contracts.dart';
import '../domain/repositories/repositores.dart';
import '../infraestructure/infrastructure.dart';

part 'major_providers.g.dart';

@Riverpod(keepAlive: true)
Box hiveBox(Ref ref) {
  return Hive.box(DatabaseKeys.application.name);
}

@Riverpod(keepAlive: true)
HttpClient httpClient(Ref ref) {
  //TODO gemini said to remove this. Test if it works
  return HttpAdapter(http.Client());
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
ISupabaseEnterpriseDataSource supabaseEnterpriseDataSource(Ref ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return SupabaseEnterpriseDataSource(supabase);
}

@riverpod
ISoapEnterpriseDataSource soapEnterpriseDataSource(Ref ref) {
  final soapAdapter = ref.watch(soapAdapterProvider);
  return SoapEnterpriseDataSource(soapAdapter: soapAdapter);
}

@riverpod
IEnterpriseRepository enterpriseRepository(Ref ref) {
  final supabaseEnterpriseDatasource = ref.watch(
    supabaseEnterpriseDataSourceProvider,
  );
  final soapEnterpriseDatasource = ref.watch(soapEnterpriseDataSourceProvider);

  return EnterpriseRepositoryImpl(
    supabaseEnterpriseDatasource: supabaseEnterpriseDatasource,
    soapEnterpriseDatasource: soapEnterpriseDatasource,
  );
}

@riverpod
ILocalSessionDataSource localSessionDataSource(Ref ref) {
  return LocalSessionDataSource(ref.watch(hiveBoxProvider));
}

@riverpod
ILocalSessionRepository localSessionRepository(Ref ref) {
  return LocalSessionRepositoryImpl(ref.watch(localSessionDataSourceProvider));
}
