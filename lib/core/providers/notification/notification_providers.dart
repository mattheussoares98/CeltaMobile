import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/data/datasource/notification/notification.dart';

part 'notification_providers.g.dart';

@riverpod
INotificationDatasource notificationDatasource(Ref ref) {
  return NotificationDatasource();
}
