import 'package:celta_inventario/features/competing_prices/domain/entities/entities.dart';

abstract class ISoapLoadResearchsRepository {
  Future<List<ResearchEntity>> load({
    required String crossIdentity,
    required String workingUrl,
    required int enterpriseCode,
    String? searchValue,
  });
}
