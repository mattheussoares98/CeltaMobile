import 'package:celta_inventario/core/infraestructure/services/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_service.g.dart';

@Riverpod(keepAlive: true)
INotificationsService notificationsService(Ref ref) =>
    NotificationsService.instance;
