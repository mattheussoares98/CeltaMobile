import 'package:celta_inventario/core/data/datasource/enterprise/enterprise.dart';
import 'package:celta_inventario/core/data/datasource/login/login.dart';
import 'package:celta_inventario/features/enterprise_manager/data/datasource/datasource.dart';
import 'package:celta_inventario/features/enterprise_manager/data/models/models.dart';
import 'package:celta_inventario/features/enterprise_manager/domain/entities/entities.dart';
import 'package:celta_inventario/features/enterprise_manager/domain/repositories/repositories.dart';

class EnterpriseManagerRepositoryImpl implements IEnterpriseManagerRepository {
  final IEnterpriseManagerDatasource enterpriseManagerDatasource;
  final ISoapLoginDatasource soapLoginDatasource;
  final ISoapEnterpriseDatasource soapEnterpriseDatasource;
  final ISoapUrlValidationDatasource soapUrlValidationDatasource;

  EnterpriseManagerRepositoryImpl({
    required this.enterpriseManagerDatasource,
    required this.soapLoginDatasource,
    required this.soapEnterpriseDatasource,
    required this.soapUrlValidationDatasource,
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
    required String remoteHttpUrl,
    required String? remoteHttpsUrl,
    required String? localHttpUrl,
    required String? localHttpsUrl,
    required String userName,
    required String password,
  }) async {
    //1- check which url is working
    final workingUrl = await soapUrlValidationDatasource.findWorkingUrl([
      remoteHttpUrl,
      ?remoteHttpsUrl,
      ?localHttpUrl,
      ?localHttpsUrl,
    ]);

    // 2- try make login in bs
    final user = await soapLoginDatasource.login(
      workingUrl: workingUrl,
      user: userName,
      password: password,
    );
    // 3- load enterprises from bs
    final enterprises = await soapEnterpriseDatasource.getEnterprises(
      workingUrl: workingUrl,
      crossIdentity: user.CrossIdentity_Usuario ?? "",
    );
    // 4- try create enterprise in supabase
    await enterpriseManagerDatasource.createEnterpriseWithSubEnterprises(
      enterpriseName: enterpriseName,
      localHttpUrl: localHttpUrl,
      localHttpsUrl: localHttpsUrl,
      remoteHttpUrl: remoteHttpUrl,
      remoteHttpsUrl: remoteHttpsUrl,
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
    required String remoteHttpUrl,
    required String? remoteHttpsUrl,
    required String? localHttpUrl,
    required String? localHttpsUrl,
    required List<UpdateModulePermissionModel> permissions,
  }) async {
    await enterpriseManagerDatasource.updateUrlAndPermissions(
      enterpriseId: enterpriseId,
      remoteHttpUrl: remoteHttpUrl,
      remoteHttpsUrl: remoteHttpsUrl,
      localHttpUrl: localHttpUrl,
      localHttpsUrl: localHttpsUrl,
      permissions: permissions,
    );
  }
}
