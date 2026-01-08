import '../../../../core/domain/entities/entities.dart';
import '../../domain/entities/entities.dart';

abstract class ISoapConcurrentsRepository {
  Future<List<ConcurrentEntity>> load({
    required String crossIdentity,
    required String urlInUse,
    String? searchValue,
  });

  Future<void> insertUpdate({
    required String crossIdentity,
    required String urlInUse,
    required int? concurrentCode,
    required String concurrentName,
    required String observation,
    required AddressEntity? address,
  });
}
