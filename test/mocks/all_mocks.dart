import 'dart:async';

import 'package:celta_intelligence/core/data/datasource/datasource.dart';
import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/contracts/contracts.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/domain/errors/errors.dart';
import 'package:celta_intelligence/core/domain/repositories/repositores.dart';
import 'package:celta_intelligence/features/auth/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/auth/data/models/models.dart';
import 'package:celta_intelligence/features/auth/domain/repositories/repositories.dart';
import 'package:celta_intelligence/features/enterprise_manager/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/enterprise_manager/data/models/models.dart';
import 'package:celta_intelligence/features/enterprise_manager/domain/entities/entities.dart';
import 'package:celta_intelligence/features/enterprise_manager/domain/repositories/repositories.dart';
import 'package:faker/faker.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Listener<T> extends Mock {
  void call(T? previous, T next);
}

class _FakePostgrestFilterBuilder<T> extends Fake
    implements PostgrestFilterBuilder<T> {
  final Future<T> _future;
  _FakePostgrestFilterBuilder(this._future);

  @override
  PostgrestFilterBuilder<T> eq(String column, dynamic value) => this;

  @override
  Future<R> then<R>(
    FutureOr<R> Function(T value) onValue, {
    Function? onError,
  }) {
    return _future.then(onValue, onError: onError);
  }
}

class _FakeSupabaseQueryBuilder extends Fake implements SupabaseQueryBuilder {
  final Future<List<Map<String, dynamic>>> _future;
  _FakeSupabaseQueryBuilder(this._future);

  @override
  PostgrestFilterBuilder<List<Map<String, dynamic>>> select([
    String columns = '*',
  ]) {
    return _FakePostgrestFilterBuilder(_future);
  }
}

class SupabaseClientSpy extends Fake implements SupabaseClient {
  dynamic _rpcReturnValue;
  Object? _rpcErrorToThrow;

  void mockResponse(dynamic data) {
    _rpcReturnValue = data;
    _rpcErrorToThrow = null;
  }

  void mockFromError(Object error) {
    _rpcErrorToThrow = error;
    _rpcReturnValue = null;
  }

  @override
  SupabaseQueryBuilder from(String table) {
    if (_rpcErrorToThrow != null) {
      return _FakeSupabaseQueryBuilder(Future.error(_rpcErrorToThrow!));
    }
    return _FakeSupabaseQueryBuilder(Future.value(_rpcReturnValue));
  }

  final List<Map<String, dynamic>> rpcCallHistory = [];
  String? get lastRpcFunction =>
      rpcCallHistory.isNotEmpty ? rpcCallHistory.last['fn'] as String? : null;
  Map<String, dynamic>? get lastRpcParams => rpcCallHistory.isNotEmpty
      ? rpcCallHistory.last['params'] as Map<String, dynamic>?
      : null;

  @override
  PostgrestFilterBuilder<T> rpc<T>(
    String fn, {
    Map<String, dynamic>? params,
    dynamic get = false,
  }) {
    rpcCallHistory.add({'fn': fn, 'params': params});
    if (_rpcErrorToThrow != null) {
      final error = _rpcErrorToThrow!;
      _rpcErrorToThrow = null;
      return _FakePostgrestFilterBuilder<T>(Future.error(error));
    }
    final future = Future.value(_rpcReturnValue as T);
    return _FakePostgrestFilterBuilder<T>(future);
  }
}

class MockBox extends Mock implements Box {
  MockBox() {
    when(() => this.delete(any())).thenAnswer((_) async => {});
    when(() => this.put(any(), any())).thenAnswer((_) async => {});
  }

  void mockGet(String key, dynamic value) {
    when(() => this.get(key)).thenReturn(value);
  }
}

class MockSoapAdapter extends Mock implements SoapRequest {
  void mockGet(dynamic value) {
    when(
      () => this.post(
        parameters: any(named: 'parameters'),
        typeOfResponse: any(named: 'typeOfResponse'),
        typeOfResult: any(named: 'typeOfResult'),
        soapAction: any(named: 'soapAction'),
        serviceASMX: any(named: 'serviceASMX'),
        url: any(named: 'url'),
      ),
    ).thenAnswer((_) async => value);
  }
}

class LoginRemoteDataSourceSpy extends Mock implements ISoapLoginDataSource {
  void mockLogin(UserModel user) {
    when(
      () => this.login(
        baseUrl: any(named: 'baseUrl'),
        user: any(named: 'user'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => user);
  }
}

class MockAuthLocalDatasource extends Mock implements IAuthLocalDatasource {
  MockAuthLocalDatasource() {
    when(() => this.logout()).thenAnswer((_) async => {});
  }

  void mockSaveUser(UserEntity user) {
    when(() => this.saveUser(user)).thenAnswer((_) async => {});
  }

  void mockGetUser(UserEntity? user) {
    when(() => this.getUser()).thenAnswer((_) async => user);
  }
}

class MockEnterpriseDatasource extends Mock
    implements ISupabaseEnterpriseDataSource {
  void mockGetEnterprise(SupabaseEnterpriseModel? enterprise) {
    when(
      () => this.getEnterpriseByName(any()),
    ).thenAnswer((_) async => enterprise);
  }
}

class MockAuthRepository extends Mock implements IAuthRepository {
  MockAuthRepository() {
    _mockLoginCall().thenAnswer((_) async => {});
    _mockLogoutCall().thenAnswer((_) async => {});
  }

  When _mockGetCurrentUserCall() => when(() => this.getCurrentUser());

  void mockGetCurrentUser(UserEntity? user) {
    _mockGetCurrentUserCall().thenAnswer((_) async => user);
  }

  void mockGetCurrentUserError() {
    _mockGetCurrentUserCall().thenThrow(Exception());
  }

  When _mockLogoutCall() => when(() => this.logout());
  void mockLogoutError() => _mockLogoutCall().thenThrow(Exception());

  When _mockLoginCall() => when(
    () => this.login(
      enterpriseName: any(named: 'enterpriseName'),
      userName: any(named: 'userName'),
      password: any(named: 'password'),
    ),
  );
  void mockLoginError() {
    _mockLoginCall().thenThrow(Exception());
  }
}

class MockAuthManagerDataSource extends Mock implements IAuthManagerDataSource {
  MockAuthManagerDataSource() {
    when(() => this.logout()).thenAnswer((_) async => {});
  }

  void mockLogin(AuthResponse response) {
    when(() => this.login(any(), any())).thenAnswer((_) async => response);
  }

  void mockGetCurrentUser(User? user) {
    when(() => this.getCurrentUser()).thenAnswer((_) => user);
  }
}

class AuthManagerRepositorySpy extends Mock implements IAuthManagerRepository {
  AuthManagerRepositorySpy() {
    when(() => this.logout()).thenAnswer((_) async => {});
  }

  When _mockLoginCall() => when(() => this.login(any(), any()));

  void mockLogin(AuthResponse response) {
    _mockLoginCall().thenAnswer((_) async => response);
  }

  void mockLoginError() {
    _mockLoginCall().thenThrow(Exception());
  }
}

class SoapRequestSpy extends Mock implements SoapRequest {
  void mockPost(dynamic response) {
    _mockPostCall().thenAnswer((_) async => response);
  }

  void mockPostError() {
    _mockPostCall().thenThrow(BsError(faker.lorem.sentence()));
  }

  When _mockPostCall() => when(
    () => this.post(
      parameters: any(named: "parameters"),
      typeOfResponse: any(named: "typeOfResponse"),
      typeOfResult: any(named: "typeOfResult"),
      soapAction: any(named: "soapAction"),
      serviceASMX: any(named: "serviceASMX"),
      url: any(named: "url"),
    ),
  );
}

class SoapEnterpriseDataSourceSpy extends Mock
    implements ISoapEnterpriseDataSource {
  void mockGetEnterprises(List<SoapEnterpriseModel> response) {
    when(
      () => this.getEnterprises(
        baseUrl: any(named: "baseUrl"),
        crossIdentity: any(named: "crossIdentity"),
      ),
    ).thenAnswer((_) async => response);
  }
}

class SupabaseEnterpriseDataSourceSpy extends Mock
    implements ISupabaseEnterpriseDataSource {
  void mockGetEnterpriseByName(SupabaseEnterpriseModel? response) {
    when(
      () => this.getEnterpriseByName(any()),
    ).thenAnswer((_) async => response);
  }
}

class EnterpriseRepositorySpy extends Mock implements IEnterpriseRepository {
  void mockGetSupabaseEnterpriseByName(EnterpriseEntity? response) {
    when(
      () => this.getSupabaseEnterpriseByName(any()),
    ).thenAnswer((_) async => response);
  }

  void mockGetSoapEnterprises(List<EnterpriseEntity> response) {
    when(
      () => this.getSoapEnterprises(
        url: any(named: "url"),
        crossIdentity: any(named: "crossIdentity"),
      ),
    ).thenAnswer((_) async => response);
  }
}

class EnterpriseManagerDataSourceSpy extends Mock
    implements IEnterpriseManagerDataSource {
  EnterpriseManagerDataSourceSpy() {
    when(
      () => this.createEnterpriseWithSubEnterprises(
        enterpriseName: any(named: "enterpriseName"),
        baseUrl: any(named: "baseUrl"),
        subEnterprises: any(named: "subEnterprises"),
      ),
    ).thenAnswer((_) async => {});

    when(
      () => this.updateModulePermissions(
        enterpriseId: any(named: 'enterpriseId'),
        permissions: any(named: 'permissions'),
      ),
    ).thenAnswer((_) async => {});
  }
  When _mockGetAllEnterprisesPermissionsCall() =>
      when(() => this.getEnterprisePermissions());

  void mockGetAllEnterprisesPermissions(
    List<EnterprisePermissionModel> response,
  ) {
    _mockGetAllEnterprisesPermissionsCall().thenAnswer((_) async => response);
  }

  void mockGetAllEnterprisesPermissionsError() {
    _mockGetAllEnterprisesPermissionsCall().thenThrow(Exception());
  }

  When _mockGetEnterprisePermissionsByIdCall() =>
      when(() => this.getEnterprisePermissionsById(any()));

  void mockGetEnterprisePermissionsById(EnterprisePermissionModel? response) {
    _mockGetEnterprisePermissionsByIdCall().thenAnswer((_) async => response);
  }

  void mockGetEnterprisePermissionsByIdError() {
    _mockGetAllEnterprisesPermissionsCall().thenThrow(Exception());
  }
}

class EnterpriseManagerRepositorySpy extends Mock
    implements IEnterpriseManagerRepository {
  EnterpriseManagerRepositorySpy() {
    _mockCreateEnterpriseCall().thenAnswer((_) async => {});
  }
  void mockCreateEnterpriseError() {
    _mockCreateEnterpriseCall().thenThrow(Exception());
  }

  When _mockCreateEnterpriseCall() => when(
    () => this.createEnterprise(
      enterpriseName: any(named: "enterpriseName"),
      baseUrl: any(named: "baseUrl"),
      userName: any(named: "userName"),
      password: any(named: "password"),
    ),
  );
  When _mockGetAllEnterprisesPermissionsCall() =>
      when(() => this.getAllEnterprisePermissions());

  void mockGetAllEnterprisesPermissions(
    List<EnterprisePermissionEntity> response,
  ) {
    _mockGetAllEnterprisesPermissionsCall().thenAnswer((_) async => response);
  }

  void mockGetAllEnterprisesPermissionsError() {
    _mockGetAllEnterprisesPermissionsCall().thenThrow(Exception());
  }
}
