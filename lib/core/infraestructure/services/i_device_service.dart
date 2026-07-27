// lib/core/infraestructure/services/i_device_service.dart
abstract class IDeviceService {
  Future<String> getAppVersion();
  Future<String> getInternalCode();
}

