import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/customer_register/data/datasource/datasource.dart';
import 'package:celta_inventario/features/customer_register/domain/entities/entities.dart';
import 'package:celta_inventario/features/customer_register/domain/repositories/repositories.dart';

class EcGlobalParametersRepositoryImpl
    implements IEcGlobalParametersRepository {
  final IEcGlobalParametersDatasource datasource;

  const EcGlobalParametersRepositoryImpl(this.datasource);

  @override
  Future<BSFGlobalParametersEntity> getGlobalParameters(
    EcRequestParams params,
  ) async => (await datasource.getGlobalParameters(params)).toEntity();
}
