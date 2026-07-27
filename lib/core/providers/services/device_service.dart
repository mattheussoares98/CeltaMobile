// lib/core/providers/services/device_service.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:celta_inventario/core/infraestructure/services/services.dart';

part 'device_service.g.dart';

@Riverpod(keepAlive: true)
IDeviceService deviceService(Ref ref) {
  return DeviceService();
}
