import '../../../../core/data/datasource/enterprise/enterprise.dart';
import '../../../../core/data/datasource/login/login.dart';
import '../../data/datasource/datasource.dart';
import '../../data/models/models.dart';
import '../entities/entities.dart';
import 'repositories.dart';

class EnterpriseManagerRepositoryImpl implements IEnterpriseManagerRepository {
  final IEnterpriseManagerDatasource enterpriseManagerDatasource;
  final ISoapLoginDatasource soapLoginDatasource;
  final ISoapEnterpriseDatasource soapEnterpriseDatasource;

  EnterpriseManagerRepositoryImpl({
    required this.enterpriseManagerDatasource,
    required this.soapLoginDatasource,
    required this.soapEnterpriseDatasource,
  });

  @override
  Future<List<EnterprisePermissionEntity>> getAllEnterprisePermissions() async {
    final enterprises = await enterpriseManagerDatasource
        .getEnterprisePermissions();

    return enterprises.map((e) => e.toEntity()).toList();
  }

  @override
  Future<EnterprisePermissionEntity?> getEnterprisePermissionsById(
    int id,
  ) async {
    final enterprise = await enterpriseManagerDatasource
        .getEnterprisePermissionsById(id);

    return enterprise?.toEntity();
  }

  @override
  Future<void> createEnterprise({
    required String enterpriseName,
    required String baseUrl,
    required String userName,
    required String password,
  }) async {
    // 1- try make login in bs
    final user = await soapLoginDatasource.login(
      baseUrl: baseUrl,
      user: userName,
      password: password,
    );
    // 2- load enterprises from bs
    final enterprises = await soapEnterpriseDatasource.getEnterprises(
      baseUrl: baseUrl,
      crossIdentity: user.CrossIdentity_Usuario ?? "",
    );
    // 3- try create enterprise in supabase
    await enterpriseManagerDatasource.createEnterpriseWithSubEnterprises(
      enterpriseName: enterpriseName,
      baseUrl: baseUrl,
      subEnterprises: enterprises
          .map(
            (e) => SubEnterpriseModel(
              cnpj: e.CnpjNumber!,
              name: e.Name!,
              personalizedCode: e.PersonalizedCode!,
              id: e.Code!,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<void> updateModulePermissions({
    required int enterpriseId,
    required List<UpdateModulePermissionModel> permissions,
  }) async {
    await enterpriseManagerDatasource.updateModulePermissions(
      enterpriseId: enterpriseId,
      permissions: permissions,
    );
  }

  @override
  Future<List<EnabledModulesByCnpjEntity>> getEnabledModulesByEnterpriseName(
    String enterpriseName,
  ) async {
    final enterprises = await enterpriseManagerDatasource
        .getEnabledModulesByEnterpriseName(enterpriseName);

    return enterprises.map((e) => e.toEntity()).toList();
  }
}
