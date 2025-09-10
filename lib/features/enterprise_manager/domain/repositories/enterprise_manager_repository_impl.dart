import '../../../../core/data/datasource/datasource.dart';
import '../../data/datasource/datasource.dart';
import '../../data/models/models.dart';
import '../entities/entities.dart';
import 'repositories.dart';

class EnterpriseManagerRepositoryImpl implements IEnterpriseManagerRepository {
  final IEnterpriseManagerDataSource enterpriseManagerDataSource;
  final ISoapLoginDataSource soapLoginDataSource;
  final ISoapEnterpriseDataSource soapEnterpriseDataSource;

  EnterpriseManagerRepositoryImpl({
    required this.enterpriseManagerDataSource,
    required this.soapLoginDataSource,
    required this.soapEnterpriseDataSource,
  });

  @override
  Future<List<EnterprisePermissionEntity>> getAllEnterprisePermissions() async {
    final enterprises = await enterpriseManagerDataSource
        .getEnterprisePermissions();

    return enterprises.map((e) => e.toEntity()).toList();
  }

  @override
  Future<EnterprisePermissionEntity?> getEnterprisePermissionsById(
    int id,
  ) async {
    final enterprise = await enterpriseManagerDataSource
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
    final user = await soapLoginDataSource.login(
      baseUrl: baseUrl,
      user: userName,
      password: password,
    );
    // 2- load enterprises from bs
    final enterprises = await soapEnterpriseDataSource.getEnterprises(
      baseUrl: baseUrl,
      crossIdentity: user.CrossIdentity_Usuario ?? "",
    );
    // 3- try create enterprise in supabase
    await enterpriseManagerDataSource.createEnterpriseWithSubEnterprises(
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
    await enterpriseManagerDataSource.updateModulePermissions(
      enterpriseId: enterpriseId,
      permissions: permissions,
    );
  }
}
