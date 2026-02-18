import 'package:celta_inventario/core/data/datasource/url_launch/url_launch.dart';
import 'package:celta_inventario/core/presentation/controllers/url_launch/url_launch_controller.dart';
import 'package:celta_inventario/core/providers/url_launch/url_launch.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// 1. Create a Mock for the repository dependency
class MockUrlLaunchDatasource extends Mock implements IUrlLaunchDatasource {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockUrlLaunchDatasource mockDatasource;
  late String fakeUrl;

  setUp(() {
    mockDatasource = MockUrlLaunchDatasource();
    fakeUrl = faker.internet.httpsUrl();
  });

  setUpAll(() {});

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        urlLaunchDatasourceProvider.overrideWithValue(mockDatasource),
      ],
    );
  }

  group('Launch url', () {
    test(
      'Should call datasource with correct value and emit correct values',
      () async {
        // ARRANGE
        when(() => mockDatasource.launch(fakeUrl)).thenAnswer((_) async {});

        final container = makeProviderContainer();
        addTearDown(container.dispose);

        final states = <AsyncValue<void>>[];
        container.listen(
          urlLaunchControllerProvider,
          (_, next) => states.add(next),
        );

        await container
            .read(urlLaunchControllerProvider.notifier)
            .launch(fakeUrl);

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        verify(() => mockDatasource.launch(fakeUrl)).called(1);
      },
    );
  });
}
