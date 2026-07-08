abstract class INotificationsService {
  Future<void> initialize();
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
    int? id,
  });
}
