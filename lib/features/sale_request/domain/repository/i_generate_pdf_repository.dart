import 'dart:typed_data';
import '../entities/entities.dart';

abstract class IGeneratePdfRepository {
  Future<Uint8List> generate(LastSavedSaleRequestEntity saleRequest);
}
