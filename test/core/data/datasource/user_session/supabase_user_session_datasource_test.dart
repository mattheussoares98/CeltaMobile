import 'package:celta_inventario/core/data/datasource/user_session/user_session.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISupabaseUserSessionDatasource sut;

  late SupabaseClientSpy supabaseClient;

  late String userName;
  late DeviceType deviceType;
  late int firebaseEnterpriseId;
  late String? fcmToken;

  void initEntities() {
    userName = faker.internet.userName();
    deviceType = DeviceType
        .values[faker.randomGenerator.integer(DeviceType.values.length)];
    firebaseEnterpriseId = faker.randomGenerator.integer(100);
    fcmToken = faker.guid.guid();
  }

  void initSut() {
    sut = SupabaseUserSessionDatasource(supabaseClient);
  }

  void initInjections() {
    supabaseClient = SupabaseClientSpy();
  }

  void mockSuccess() {}

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    for (var value in DeviceType.values) {
      registerFallbackValue(value);
    }
  });

  group('Handle login', () {
    test('should behave correctly on success', () async {
      await sut.handleUserSession(
        userName: userName,
        deviceType: deviceType,
        firebaseEnterpriseId: firebaseEnterpriseId,
        fcmToken: fcmToken,
      );

      expect(supabaseClient.lastRpcFunction, 'handle_user_session');
      expect(supabaseClient.lastRpcParams, {
        'p_user_name': userName,
        'p_device_type': deviceType.name.toLowerCase(),
        'p_enterprise_id': firebaseEnterpriseId,
        'p_fcm_token': fcmToken,
      });
    });
    test('should rethrow the error', () async {
      final error = Exception(faker.lorem.sentence());
      supabaseClient.mockFromError(error);

      final result = sut.handleUserSession(
        userName: userName,
        deviceType: deviceType,
        firebaseEnterpriseId: firebaseEnterpriseId,
        fcmToken: fcmToken,
      );

      expect(result, throwsA(error));
    });
  });
  group('Handle remove', () {
    test('should behave correctly on success', () async {
      await sut.removeUserSession(
        userName: userName,
        deviceType: deviceType,
        enterpriseId: firebaseEnterpriseId,
      );

      expect(supabaseClient.lastRpcFunction, 'delete_user_session');
      expect(supabaseClient.lastRpcParams, {
        'p_user_name': userName,
        'p_device_type': deviceType.name.toLowerCase(),
        'p_enterprise_id': firebaseEnterpriseId,
      });
    });
    test('should rethrow the error', () async {
      final error = Exception(faker.lorem.sentence());
      supabaseClient.mockFromError(error);

      final result = sut.removeUserSession(
        userName: userName,
        deviceType: deviceType,
        enterpriseId: firebaseEnterpriseId,
      );

      expect(result, throwsA(error));
    });
  });
}
