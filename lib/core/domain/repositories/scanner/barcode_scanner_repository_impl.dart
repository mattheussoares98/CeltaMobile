import '../../../data/datasource/scanner/scanner.dart';
import 'scanner.dart';

class BarcodeScannerRepositoryImpl implements IBarcodeScannerRepository {
  final IBarcodeScannerDatasource datasource;

  BarcodeScannerRepositoryImpl(this.datasource);

  @override
  Future<String?> scan() async {
    return await datasource.scan();
  }
}
