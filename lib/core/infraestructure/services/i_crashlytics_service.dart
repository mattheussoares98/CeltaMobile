import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class ICrashlyticsService {
  Future<void> setCustomKeys(List<CrashlyticsCustomKeyEntity> customKeys);
}
