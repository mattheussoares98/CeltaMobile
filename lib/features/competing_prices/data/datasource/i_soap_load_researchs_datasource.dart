import 'package:celta_inventario/features/competing_prices/data/models/models.dart';

abstract class ISoapLoadResearchsDatasource {
  Future<List<ResearchModel>> load({
    required String crossIdentity,
    required String workingUrl,
    required int enterpriseCode,
    String? searchValue,
  });
}
