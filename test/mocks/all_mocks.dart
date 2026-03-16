import 'dart:async';

import 'package:celta_inventario/core/data/datasource/address/address.dart';
import 'package:celta_inventario/core/data/datasource/buyer/buyer.dart';
import 'package:celta_inventario/core/data/datasource/customer/customer.dart';
import 'package:celta_inventario/core/data/datasource/enterprise/enterprise.dart';
import 'package:celta_inventario/core/data/datasource/login/login.dart';
import 'package:celta_inventario/core/data/datasource/products/products.dart';
import 'package:celta_inventario/core/data/datasource/request_type/request_type.dart';
import 'package:celta_inventario/core/data/datasource/resource/resource.dart';
import 'package:celta_inventario/core/data/datasource/settings/settings.dart';
import 'package:celta_inventario/core/data/datasource/stock/stock.dart';
import 'package:celta_inventario/core/data/datasource/supplier/supplier.dart';
import 'package:celta_inventario/core/data/datasource/transfer_justification/transfer_justification.dart';
import 'package:celta_inventario/core/data/datasource/user_session/user_session.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/domain/errors/errors.dart';
import 'package:celta_inventario/core/domain/repositories/customer/customer.dart';
import 'package:celta_inventario/core/domain/repositories/enterprise/enterprise.dart';
import 'package:celta_inventario/core/domain/repositories/products/products.dart';
import 'package:celta_inventario/core/domain/repositories/resource/resource.dart';
import 'package:celta_inventario/core/domain/repositories/settings/settings.dart';
import 'package:celta_inventario/core/domain/repositories/user_session/user_session.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/features/adjust_sale_price/data/datasource/datasource.dart';
import 'package:celta_inventario/features/adjust_sale_price/data/models/models.dart';
import 'package:celta_inventario/features/adjust_sale_price/domain/entities/entities.dart';
import 'package:celta_inventario/features/adjust_sale_price/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/adjust_sale_price/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/auth/data/models/models.dart';
import 'package:celta_inventario/features/auth/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/buy_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/buy_request/data/models/models.dart';
import 'package:celta_inventario/features/customer_register/data/datasource/datasource.dart';
import 'package:celta_inventario/features/customer_register/data/models/models.dart';
import 'package:celta_inventario/features/customer_register/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/enterprise_manager/data/datasource/datasource.dart';
import 'package:celta_inventario/features/enterprise_manager/data/models/models.dart';
import 'package:celta_inventario/features/enterprise_manager/domain/entities/entities.dart';
import 'package:celta_inventario/features/enterprise_manager/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/expedition_conference/data/datasource/datasource.dart';
import 'package:celta_inventario/features/expedition_conference/data/models/models.dart';
import 'package:celta_inventario/features/inventory/data/datasource/datasource.dart';
import 'package:celta_inventario/features/inventory/data/models/models.dart';
import 'package:celta_inventario/features/search_products/data/datasource/datasource.dart';
import 'package:celta_inventario/features/settings/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/transfer_request/data/datasource/datasource.dart';
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
    when(() => this.clear()).thenAnswer((_) async => 0);
  }

  void mockGet(dynamic key, dynamic value) {
    when(() => this.get(key)).thenReturn(value);
  }
}

class SoapLoginDatasourceSpy extends Mock implements ISoapLoginDatasource {
  void mockLogin(UserModel user) {
    when(
      () => this.login(
        workingUrl: any(named: 'workingUrl'),
        user: any(named: 'user'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => user);
  }
}

class MockEnterpriseDatasource extends Mock
    implements ISupabaseEnterpriseDatasource {
  void mockGetEnterprise(SupabaseEnterpriseModel? enterprise) {
    when(
      () => this.getEnterpriseByName(any()),
    ).thenAnswer((_) async => enterprise);
  }
}

class MockAuthRepository extends Mock implements IAuthRepository {
  MockAuthRepository() {
    _mockLoginCall().thenAnswer((_) async => {});
  }

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

class MockAuthManagerDatasource extends Mock implements IAuthManagerDatasource {
  MockAuthManagerDatasource() {
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
  SoapRequestSpy() {
    mockPost(null);
  }
  void mockPost(dynamic response) {
    _mockPostCall().thenAnswer((_) async => response);
  }

  void mockPostError({dynamic error}) {
    _mockPostCall().thenThrow(error ?? BsError(faker.lorem.sentence()));
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

class SoapEnterpriseDatasourceSpy extends Mock
    implements ISoapEnterpriseDatasource {
  void mockGetEnterprises(List<SoapEnterpriseModel> response) {
    when(
      () => this.getEnterprises(
        workingUrl: any(named: "workingUrl"),
        crossIdentity: any(named: "crossIdentity"),
        enterpriseOriginCode: any(named: "enterpriseOriginCode"),
        requestTypeCode: any(named: "requestTypeCode"),
      ),
    ).thenAnswer((_) async => response);
  }
}

class SupabaseEnterpriseDatasourceSpy extends Mock
    implements ISupabaseEnterpriseDatasource {
  void mockGetEnterpriseByName(SupabaseEnterpriseModel? response) {
    when(
      () => this.getEnterpriseByName(any()),
    ).thenAnswer((_) async => response);
  }

  When _mockGetEnabledModulesByEnterpriseNameCall() {
    return when(() => this.getEnabledModulesByEnterpriseName(any()));
  }

  void mockGetEnabledModulesByEnterpriseName(
    List<EnabledModulesByCnpjModel> response,
  ) {
    _mockGetEnabledModulesByEnterpriseNameCall().thenAnswer(
      (_) async => response,
    );
  }

  void mockGetEnabledModulesByEnterpriseNameError() {
    _mockGetEnabledModulesByEnterpriseNameCall().thenThrow(Exception());
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
        existingEnterpriseCodesOnSupabase: any(
          named: "existingEnterpriseCodesOnSupabase",
        ),
        enterpriseOriginCode: any(named: "enterpriseOriginCode"),
        requestTypeCode: any(named: "requestTypeCode"),
        enterpriseIdInSupabase: any(named: "enterpriseIdInSupabase"),
      ),
    ).thenAnswer((_) async => response);
  }
}

class EnterpriseManagerDatasourceSpy extends Mock
    implements IEnterpriseManagerDatasource {
  EnterpriseManagerDatasourceSpy() {
    when(
      () => this.createEnterpriseWithSubEnterprises(
        enterpriseName: any(named: "enterpriseName"),
        remoteHttpUrl: any(named: "remoteHttpUrl"),
        remoteHttpsUrl: any(named: "remoteHttpsUrl"),
        localHttpUrl: any(named: "localHttpUrl"),
        localHttpsUrl: any(named: "localHttpsUrl"),
        subEnterprises: any(named: "subEnterprises"),
      ),
    ).thenAnswer((_) async => {});

    when(
      () => this.updateUrlAndPermissions(
        enterpriseId: any(named: 'enterpriseId'),
        permissions: any(named: 'permissions'),
        remoteHttpUrl: any(named: 'remoteHttpUrl'),
        remoteHttpsUrl: any(named: 'remoteHttpsUrl'),
        localHttpUrl: any(named: 'localHttpUrl'),
        localHttpsUrl: any(named: 'localHttpsUrl'),
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
      remoteHttpUrl: any(named: "remoteHttpUrl"),
      remoteHttpsUrl: any(named: "remoteHttpsUrl"),
      localHttpUrl: any(named: "localHttpUrl"),
      localHttpsUrl: any(named: "localHttpsUrl"),
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

class LocalUserSessionDatasourceSpy extends Mock
    implements ILocalUserSessionDatasource {
  LocalUserSessionDatasourceSpy() {
    when(() => this.logout()).thenAnswer((_) async => {});
    when(() => this.save(any())).thenAnswer((_) async {});
  }
  void mockGetSession(UserSessionModel? response) {
    when(() => this.get()).thenAnswer((_) async => response);
  }
}

class SupabaseUserSessionDatasourceSpy extends Mock
    implements ISupabaseUserSessionDatasource {
  SupabaseUserSessionDatasourceSpy() {
    when(
      () => this.handleUserSession(
        userName: any(named: 'userName'),
        deviceType: any(named: 'deviceType'),
        firebaseEnterpriseId: any(named: 'firebaseEnterpriseId'),
        fcmToken: any(named: 'fcmToken'),
        appVersion: any(named: 'appVersion'),
      ),
    ).thenAnswer((_) async => {});
    when(
      () => this.removeUserSession(
        userName: any(named: 'userName'),
        deviceType: any(named: 'deviceType'),
        enterpriseId: any(named: 'enterpriseId'),
      ),
    ).thenAnswer((_) async {});
  }
}

class SoapProductsDatasourceSpy extends Mock
    implements ISoapGetProductsJsonDatasource {
  void mockGetProductsJson(List<ProductModel> response) {
    when(
      () => this.get(
        workingUrl: any(named: 'workingUrl'),
        parametersPayload: any(named: 'parametersPayload'),
        isCompetingPrices: any(named: 'isCompetingPrices'),
      ),
    ).thenAnswer((_) async => response);
  }
}

class SoapProductsRepositorySpy extends Mock
    implements ISoapLoadProductsRepository {
  When _mockCall() => when(
    () => this.load(
      workingUrl: any(named: 'workingUrl'),
      searchType: any(named: 'searchType'),
      crossIdentity: any(named: 'crossIdentity'),
      enterpriseEntity: any(named: 'enterpriseEntity'),
      getProductsDefaultParams: any(named: 'getProductsDefaultParams'),
    ),
  );
  void mockLoad(List<ProductEntity> response) {
    _mockCall().thenAnswer((_) async => response);
  }
}

class LocalSessionRepositorySpy extends Mock implements IUserSessionRepository {
  void mockGetSession(UserSessionModel? response) {
    when(() => this.get()).thenAnswer((_) async => response);
  }

  void mockSaveSession(UserSessionModel session) {
    when(() => this.save(session)).thenAnswer((_) async => {});
  }
}

class AuthRepositorySpy extends Mock implements IAuthRepository {
  void mockLogin(UserEntity user) {
    when(
      () => this.login(
        enterpriseName: any(named: 'enterpriseName'),
        userName: any(named: 'userName'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => user);
  }
}

class FakeEnterprisesStateController extends EnterprisesStateController {
  final List<EnterpriseEntity> enterprisesToReturn;

  FakeEnterprisesStateController(this.enterprisesToReturn);

  // 2. Override the build method to return your fake data instantly
  @override
  Future<List<EnterpriseEntity>> build({
    int? enterpriseCode,
    Modules? module,
  }) async {
    return enterprisesToReturn;
  }
}

class FakeUserSession extends UserSession {
  final UserSessionModel? sessionToReturn;

  FakeUserSession(this.sessionToReturn);

  // 2. Override the build method to return your fake data instantly
  @override
  Future<UserSessionModel?> build() async {
    return sessionToReturn;
  }
}

class FakeValidatedUserSession extends ValidatedUserSession {
  final UserSessionModel? sessionToReturn;

  FakeValidatedUserSession(this.sessionToReturn);

  // 2. Override the build method to return your fake data instantly
  @override
  Future<UserSessionModel?> build() async {
    if (sessionToReturn == null) {
      throw AppException('Sessão inválida.');
    }

    return sessionToReturn;
  }
}

class FakeSelectedProductStateController
    extends SelectedProductStateController {
  final ProductEntity? productToReturn;

  FakeSelectedProductStateController(this.productToReturn);

  // 2. Override the build method to return your fake data instantly
  @override
  Future<ProductEntity?> build(int enterpriseCode, String plu) async {
    return productToReturn;
  }
}

class SoapAdjustSalePriceDatasourceSpy extends Mock
    implements ISoapAdjustSalePriceDatasource {
  SoapAdjustSalePriceDatasourceSpy() {
    when(
      () => this.confirm(
        workingUrl: any(named: "workingUrl"),
        crossIdentity: any(named: "crossIdentity"),
        enterpriseCode: any(named: "enterpriseCode"),
        productCode: any(named: "productCode"),
        productPackingCode: any(named: "productPackingCode"),
        saleType: any(named: "saleType"),
        replications: any(named: "replications"),
        offerParams: any(named: "offerParams"),
        retailParams: any(named: "retailParams"),
        now: any(named: "now"),
      ),
    ).thenAnswer((_) async => {});
  }
}

class SoapAdjustSalePriceRepositorySpy extends Mock
    implements ISoapAdjustSalePriceRepository {
  SoapAdjustSalePriceRepositorySpy() {
    _confirmCall().thenAnswer((_) async {});
  }

  void mockConfirmError() => _confirmCall().thenThrow(Exception());

  When _confirmCall() => when(
    () => this.confirm(
      workingUrl: any(named: "workingUrl"),
      crossIdentity: any(named: "crossIdentity"),
      enterpriseCode: any(named: "enterpriseCode"),
      productCode: any(named: "productCode"),
      productPackingCode: any(named: "productPackingCode"),
      saleType: any(named: "saleType"),
      replications: any(named: "replications"),
      offerParams: any(named: "offerParams"),
      retailParams: any(named: "retailParams"),
      now: any(named: "now"),
    ),
  );
}

class SoapGetPriceSchedulesDatasourceSpy extends Mock
    implements ISoapGetPriceSchedulesDatasource {
  When _mockGetPriceSchedulesCall() => when(
    () => this.getPriceSchedules(
      workingUrl: any(named: "workingUrl"),
      crossIdentity: any(named: "crossIdentity"),
      enterpriseCode: any(named: "enterpriseCode"),
      productCode: any(named: "productCode"),
      productPackingCode: any(named: "productPackingCode"),
    ),
  );

  void mockGetPriceSchedules(List<PriceScheduleModel> response) {
    _mockGetPriceSchedulesCall().thenAnswer((_) async => response);
  }

  void mockGetPriceSchedulesError() =>
      _mockGetPriceSchedulesCall().thenThrow(Exception());
}

class SoapGetPriceSchedulesRepositorySpy extends Mock
    implements ISoapGetPriceSchedulesRepository {
  When _mockGetPriceSchedulesCall() => when(
    () => this.getPriceSchedules(
      workingUrl: any(named: "workingUrl"),
      crossIdentity: any(named: "crossIdentity"),
      enterpriseCode: any(named: "enterpriseCode"),
      productCode: any(named: "productCode"),
      productPackingCode: any(named: "productPackingCode"),
    ),
  );

  void mockGetPriceSchedules(List<PriceScheduleEntity> response) {
    _mockGetPriceSchedulesCall().thenAnswer((_) async => response);
  }

  void mockGetPriceScheduleError() =>
      _mockGetPriceSchedulesCall().thenThrow(Exception());
}

class FakePriceSchedulesStateController extends PriceSchedulesStateController {
  final List<PriceScheduleEntity> priceSchedules;

  FakePriceSchedulesStateController(this.priceSchedules);

  @override
  FutureOr<List<PriceScheduleEntity>> build(
    int enterpriseCode,
    String productPlu,
  ) async {
    return priceSchedules;
  }
}

class FakeSelectedEnterpriseStateController
    extends SelectedEnterpriseStateController {
  final EnterpriseEntity? enterpriseToReturn;
  FakeSelectedEnterpriseStateController(this.enterpriseToReturn);

  @override
  EnterpriseEntity? build() {
    return enterpriseToReturn;
  }

  @override
  Future<void> selectEnterprise(EnterpriseEntity enterprise) async {
    state = enterprise;
  }
}

class SoapResourceDatasourceSpy extends Mock
    implements ISoapResourceDatasource {
  SoapResourceDatasourceSpy() {
    _mockCanAccessResourceCall().thenAnswer((_) async => true);
  }

  When _mockCanAccessResourceCall() => when(
    () => this.canAccessResource(
      resource: any(named: "resource"),
      workingUrl: any(named: "workingUrl"),
      crossIdentity: any(named: "crossIdentity"),
      routine: any(named: "routine"),
    ),
  );

  void mockCanAccessResourceError() =>
      _mockCanAccessResourceCall().thenThrow(Exception());

  void mockCanAccessResource(bool value) =>
      _mockCanAccessResourceCall().thenAnswer((_) async => value);
}

class SoapResourceRepositorySpy extends Mock
    implements ISoapResourceRepository {
  SoapResourceRepositorySpy() {
    _mockCanAccessResourceCall().thenAnswer((_) async => true);
  }

  When _mockCanAccessResourceCall() => when(
    () => this.canAccessResource(
      resource: any(named: "resource"),
      workingUrl: any(named: "workingUrl"),
      crossIdentity: any(named: "crossIdentity"),
      routine: any(named: "routine"),
    ),
  );

  void mockCanAccessResourceError() =>
      _mockCanAccessResourceCall().thenThrow(Exception());

  void mockCanAccessResource(bool value) =>
      _mockCanAccessResourceCall().thenAnswer((_) async => value);
}

class AppSettingsDatasourceSpy extends Mock implements IAppSettingsDatasource {
  AppSettingsDatasourceSpy() {
    when(() => this.changeSettings(any())).thenAnswer((_) async {});
  }

  void mockLoadDefault(AppSettingsModel value) =>
      when(() => this.loadSettings()).thenAnswer((_) async => value);
}

class AppSettingsRepositorySpy extends Mock implements IAppSettingsRepository {
  AppSettingsRepositorySpy() {
    _changeDefaultCall().thenAnswer((_) async {});
  }

  When _changeDefaultCall() => when(() => this.changeSettings(any()));
  void mockChangeDefaultError() => _changeDefaultCall().thenThrow(Exception());

  When _loadDefaultCall() => when(() => this.loadSettings());
  void mockLoadDefaultError() => _loadDefaultCall().thenThrow(Exception());
  void mockLoadDefault(AppSettingsEntity value) =>
      _loadDefaultCall().thenAnswer((_) async => value);
}

class FakeAppSettingsStateController extends AppSettingsStateController {
  final AppSettingsEntity appSettingsToReturn;

  FakeAppSettingsStateController(this.appSettingsToReturn);

  @override
  Future<AppSettingsEntity> build() async {
    return appSettingsToReturn;
  }
}

class SoapTransferJustificationDatasourceSpy extends Mock
    implements ISoapTransferJustificationDatasource {
  When _mockLoadCall() => when(
    () => this.load(
      workingUrl: any(named: 'workingUrl'),
      crossIdentity: any(named: 'crossIdentity'),
      type: any(named: 'type'),
    ),
  );

  void mockLoad(List<TransferJustificationModel> response) =>
      _mockLoadCall().thenAnswer((_) async => response);
}

class SoapStockTypeDatasourceSpy extends Mock
    implements ISoapStockTypeDatasource {
  void mockLoad(List<StockTypeModel> response) {
    when(
      () => this.load(
        workingUrl: any(named: 'workingUrl'),
        crossIdentity: any(named: 'crossIdentity'),
      ),
    ).thenAnswer((_) async => response);
  }
}

class SoapAdjustStockDatasourceSpy extends Mock
    implements ISoapAdjustStockDatasource {
  SoapAdjustStockDatasourceSpy() {
    when(
      () => this.confirm(
        workingUrl: any(named: 'workingUrl'),
        crossIdentity: any(named: 'crossIdentity'),
        items: any(named: 'items'),
      ),
    ).thenAnswer((_) async {});
  }
}

class SoapCustomerDatasourceSpy extends Mock
    implements ISoapCustomerDatasource {
  When _mockLoadCall() => when(
    () => this.loadCustomer(
      searchType: any(named: 'searchType'),
      searchValue: any(named: 'searchValue'),
      crossIdentity: any(named: 'crossIdentity'),
      enterpriseCode: any(named: 'enterpriseCode'),
      workingUrl: any(named: 'workingUrl'),
    ),
  );

  void mockLoad(List<SoapCustomerModel> response) =>
      _mockLoadCall().thenAnswer((_) async => response);

  void mockLoadError() => _mockLoadCall().thenThrow(Exception());
}

class SoapCustomerRepositorySpy extends Mock
    implements ISoapCustomerRepository {
  When _mockLoadCall() => when(
    () => this.loadCustomer(
      searchType: any(named: 'searchType'),
      searchValue: any(named: 'searchValue'),
      crossIdentity: any(named: 'crossIdentity'),
      enterpriseCode: any(named: 'enterpriseCode'),
      workingUrl: any(named: 'workingUrl'),
    ),
  );

  void mockLoad(List<CustomerEntity> response) =>
      _mockLoadCall().thenAnswer((_) async => response);

  void mockLoadError() => _mockLoadCall().thenThrow(Exception());
}

class LoadAddressByCepDatasourceSpy extends Mock
    implements ILoadAddressByCepDatasource {
  void mockLoad(SoapAddressModel? response) {
    _mockLoadCall().thenAnswer((_) async => response);
  }

  void mockLoadError() => _mockLoadCall().thenThrow(Exception());

  When _mockLoadCall() => when(() => this.get(any()));
}

class SoapLoadCovenantsDatasourceSpy extends Mock
    implements ISoapLoadCovenantsDatasource {
  When _mockLoadCall() => when(
    () => this.load(
      workingUrl: any(named: 'workingUrl'),
      crossIdentity: any(named: 'crossIdentity'),
      searchCovenantType: any(named: 'searchCovenantType'),
      searchValue: any(named: 'searchValue'),
    ),
  );

  void mockLoad(List<CovenantModel> response) {
    _mockLoadCall().thenAnswer((_) async => response);
  }
}

class SoapInsertUpdateCustomerDatasourceSpy extends Mock
    implements ISoapInsertUpdateCustomerDatasource {
  When _mockInsertUpdateCall() => when(
    () => this.insertOrUpdateCustomer(
      customer: any(named: 'customer'),
      workingUrl: any(named: 'workingUrl'),
      crossIdentity: any(named: 'crossIdentity'),
    ),
  );

  void mockInsertUpdate() => _mockInsertUpdateCall().thenAnswer((_) async {});
}

class SoapInsertUpdateCustomerRepositorySpy extends Mock
    implements ISoapInsertUpdateCustomerRepository {
  SoapInsertUpdateCustomerRepositorySpy() {
    when(
      () => this.insertOrUpdateCustomer(
        customer: any(named: 'customer'),
        workingUrl: any(named: 'workingUrl'),
        crossIdentity: any(named: 'crossIdentity'),
      ),
    ).thenAnswer((_) async {});
  }
}

class HttpClientSpy extends Mock implements HttpClient {
  void mockRequest(dynamic response) {
    _mockRequestCall().thenAnswer((_) async => response);
  }

  When _mockRequestCall() => when(
    () => this.request(
      url: any(named: 'url'),
      method: any(named: 'method'),
      addDefaultHeaders: any(named: 'addDefaultHeaders'),
      body: any(named: 'body'),
      headers: any(named: 'headers'),
      decodeBody: any(named: 'decodeBody'),
      cancelToken: any(named: 'cancelToken'),
    ),
  );
}

class SoapSendToPrintDatasourceSpy extends Mock
    implements ISoapSendToPrintDatasource {
  SoapSendToPrintDatasourceSpy() {
    when(
      () => this.send(
        workingUrl: any(named: 'workingUrl'),
        crossIdentity: any(named: 'crossIdentity'),
        enterpriseCode: any(named: 'enterpriseCode'),
        productPackingCode: any(named: 'productPackingCode'),
        newValue: any(named: 'newValue'),
      ),
    ).thenAnswer((_) async {});
  }
}

class SoapLoadExpeditionDocumentsDatasourceSpy extends Mock
    implements ISoapLoadExpeditionDocumentsDatasource {
  void mockLoad(List<ExpeditionDocumentModel> response) {
    _mockLoadCall().thenAnswer((_) async => response);
  }

  When _mockLoadCall() => when(
    () => this.load(
      workingUrl: any(named: 'workingUrl'),
      crossIdentity: any(named: 'crossIdentity'),
      enterpriseCode: any(named: 'enterpriseCode'),
    ),
  );
}

class SoapLoadPendingProductsDatasourceSpy extends Mock
    implements ISoapLoadPendingProductsDatasource {
  void mockLoad(List<ExpeditionProductModel> response) {
    _mockLoadCall().thenAnswer((_) async => response);
  }

  When _mockLoadCall() => when(
    () => this.load(
      workingUrl: any(named: 'workingUrl'),
      crossIdentity: any(named: 'crossIdentity'),
      expeditionControlCode: any(named: 'expeditionControlCode'),
    ),
  );
}

class SoapConfirmConferenceDatasourceSpy extends Mock
    implements ISoapConfirmConferenceDatasource {
  SoapConfirmConferenceDatasourceSpy() {
    when(
      () => this.confirm(
        workingUrl: any(named: 'workingUrl'),
        crossIdentity: any(named: 'crossIdentity'),
        expeditionControlCode: any(named: 'expeditionControlCode'),
        stepCode: any(named: 'stepCode'),
      ),
    ).thenAnswer((_) async {});
  }
}

class SoapLoadInventoryDatasourceSpy extends Mock
    implements ISoapLoadInventoryDatasource {
  void mockLoad(InventoryModel response) {
    _mockLoadCall().thenAnswer((_) async => response);
  }

  When _mockLoadCall() => when(
    () => this.load(
      workingUrl: any(named: 'workingUrl'),
      crossIdentity: any(named: 'crossIdentity'),
      enterpriseCode: any(named: 'enterpriseCode'),
    ),
  );
}

class SoapInventoryEntryQuantityDatasourceSpy extends Mock
    implements ISoapInventoryEntryQuantityDatasource {
  SoapInventoryEntryQuantityDatasourceSpy() {
    when(
      () => this.entry(
        workingUrl: any(named: 'workingUrl'),
        crossIdentity: any(named: 'crossIdentity'),
        codigoInternoInvCont: any(named: 'codigoInternoInvCont'),
        productPackingCode: any(named: 'productPackingCode'),
        quantity: any(named: 'quantity'),
        isSubtract: any(named: 'isSubtract'),
      ),
    ).thenAnswer((_) async {});
  }
}

class SoapInventoryAnnulDatasourceSpy extends Mock
    implements ISoapInventoryAnnulDatasource {
  SoapInventoryAnnulDatasourceSpy() {
    when(
      () => this.annul(
        workingUrl: any(named: 'workingUrl'),
        crossIdentity: any(named: 'crossIdentity'),
        codigoInternoInvCont: any(named: 'codigoInternoInvCont'),
        codigoInternoProEmb: any(named: 'codigoInternoProEmb'),
      ),
    ).thenAnswer((_) async {});
  }
}

class SoapLoadBuyersDatasourceSpy extends Mock
    implements ISoapLoadBuyersDatasource {
  void mockLoad(List<BuyerModel> response) {
    _mockLoadCall().thenAnswer((_) async => response);
  }

  When _mockLoadCall() => when(
    () => this.load(
      workingUrl: any(named: 'workingUrl'),
      crossIdentity: any(named: 'crossIdentity'),
    ),
  );
}

class SoapLoadRequestTypeDatasourceSpy extends Mock
    implements ISoapLoadRequestTypeDatasource {
  void mockLoad(List<RequestTypeModel> response) {
    when(
      () => this.load(
        workingUrl: any(named: 'workingUrl'),
        crossIdentity: any(named: 'crossIdentity'),
        inclusiveBuy: any(named: 'inclusiveBuy'),
        inclusiveTransfer: any(named: 'inclusiveTransfer'),
        inclusiveSale: any(named: 'inclusiveSale'),
        enterpriseCode: any(named: 'enterpriseCode'),
      ),
    ).thenAnswer((_) async => response);
  }
}

class SoapLoadSupplierDatasourceSpy extends Mock
    implements ISoapLoadSupplierDatasource {
  void mockLoad(List<SupplierModel> response) {
    _mockLoadCall().thenAnswer((_) async => response);
  }

  When _mockLoadCall() => when(
    () => this.load(
      workingUrl: any(named: 'workingUrl'),
      crossIdentity: any(named: 'crossIdentity'),
      searchType: any(named: 'searchType'),
      searchValue: any(named: 'searchValue'),
    ),
  );
}

class SoapLoadEnterpriseByFiltersDatasourceSpy extends Mock
    implements ISoapLoadEnterpriseByFiltersDatasource {
  void mockLoad(List<SoapEnterpriseByFiltersModel> response) {
    when(
      () => this.load(
        workingUrl: any(named: 'workingUrl'),
        crossIdentity: any(named: 'crossIdentity'),
        supplierCode: any(named: 'supplierCode'),
        requestTypeCode: any(named: 'requestTypeCode'),
      ),
    ).thenAnswer((_) async => response);
  }
}

class LocalPendingBuyRequestDatasourceSpy extends Mock
    implements ILocalPendingBuyRequestDatasource {
  LocalPendingBuyRequestDatasourceSpy() {
    when(() => this.update(any(), any())).thenAnswer((_) async {});
  }
  void mockLoad(PendingBuyRequestModel? response) {
    when(() => this.load(any())).thenAnswer((_) async => response);
  }
}

class SoapInsertBuyRequestDatasourceSpy extends Mock
    implements ISoapInsertBuyRequestDatasource {
  void mockInsert(String response) {
    _mockInsertCall().thenAnswer((_) async => response);
  }

  When _mockInsertCall() => when(
    () => this.insertBuyRequest(
      workingUrl: any(named: 'workingUrl'),
      crossIdentity: any(named: 'crossIdentity'),
      buyerCode: any(named: 'buyerCode'),
      requestTypeCode: any(named: 'requestTypeCode'),
      supplierCode: any(named: 'supplierCode'),
      observations: any(named: 'observations'),
      enterpriseCodes: any(named: 'enterpriseCodes'),
      products: any(named: 'products'),
    ),
  );
}

class SoapLoadDestinyEnterprisesDatasourceSpy extends Mock
    implements ISoapLoadDestinyEnterprisesDatasource {
  void mockLoad(List<SoapEnterpriseModel> response) {
    when(
      () => this.load(
        workingUrl: any(named: 'workingUrl'),
        crossIdentity: any(named: 'crossIdentity'),
        requestTypeCode: any(named: 'requestTypeCode'),
        enterpriseOriginCode: any(named: 'enterpriseOriginCode'),
      ),
    ).thenAnswer((_) async => response);
  }
}

class FakeSearchProductsStateController extends SearchProductsStateController {
  final List<ProductEntity> initialState;
  FakeSearchProductsStateController(this.initialState);

  // This public property will store the product we want to check.
  ProductEntity? updatedProduct;

  @override
  Future<List<ProductEntity>> build(SearchProductKey searchProductKey) async =>
      initialState;

  @override
  Future<void> updateProduct(ProductEntity product) async {
    // Instead of doing real work, it just saves the product to our property.
    updatedProduct = product;
  }
}

class FakeAppUsageStateController extends AppUsageStateController {
  UsageType? _lastUsageType;
  UsageType? get lastUsageType => _lastUsageType;

  @override
  FutureOr<List<AppUsageEntity>?> build() => null;

  @override
  Future<void> addUsage(UsageType usageType) async {
    _lastUsageType = usageType;
  }
}
