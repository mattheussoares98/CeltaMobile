//TODO create this test
// import 'package:celta_inventario/features/enterprise_manager/presentation/controllers/controllers.dart';
// import 'package:celta_inventario/features/enterprise_manager/providers.dart';
// import 'package:faker/faker.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import '../../../../mocks/mocks.dart';

// void main() {
//   late EnterpriseManagerRepositorySpy mockEnterpriseManagerRepository;

//   setUp(() {
//     mockEnterpriseManagerRepository = EnterpriseManagerRepositorySpy();
//   });

//   ProviderContainer makeProviderContainer() {
//     final container = ProviderContainer(
//       overrides: [
//         enterpriseManagerRepositoryProvider.overrideWithValue(
//           mockEnterpriseManagerRepository,
//         ),
//       ],
//     );
//     addTearDown(container.dispose);
//     return container;
//   }

//   group('Permission details', () {
//     test('should emit [loading, data(null)] on success', () async {
//       final container = makeProviderContainer();

//       await container.read(permissionDetailsControllerProvider);

//       final states = <AsyncValue<void>>[];
//       container.listen(
//         permissionDetailsControllerProvider,
//         (_, next) => states.add(next),
//       );

//       final response = await container
//           .read(permissionDetailsControllerProvider.notifier)
//           .login(email, password);

//       expect(response, authResponse);
//       expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
//       verify(
//         () => mockEnterpriseManagerRepository.login(email, password),
//       ).called(1);
//     });
//     test('should emit [loading, error] on fails', () async {
//       final container = makeProviderContainer();

//       await container.read(permissionDetailsControllerProvider.future);

//       final states = <AsyncValue<void>>[];
//       container.listen(
//         permissionDetailsControllerProvider,
//         (_, next) => states.add(next),
//       );

//       mockEnterpriseManagerRepository.mockLoginError();

//       final value = await container
//           .read(permissionDetailsControllerProvider.notifier)
//           .login(email, password);

//       expect(value, isNull);
//       expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
//       verify(
//         () => mockEnterpriseManagerRepository.login(email, password),
//       ).called(1);
//     });
//   });
// }
