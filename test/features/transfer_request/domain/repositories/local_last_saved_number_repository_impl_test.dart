import 'package:celta_inventario/features/transfer_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/transfer_request/domain/repositories/repositories.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// 1. Create a Mock for the datasource dependency
class MockLocalLastSavedNumberDatasource extends Mock
    implements ILocalLastSavedNumberDatasource {}

void main() {
  late ILocalLastSavedNumberRepository sut;
  late MockLocalLastSavedNumberDatasource mockDatasource;
  late String lastSavedNumber;

  setUpAll(() {});

  setUp(() {
    mockDatasource = MockLocalLastSavedNumberDatasource();
    sut = LocalLastSavedNumberRepositoryImpl(mockDatasource);
    lastSavedNumber = faker.randomGenerator.integer(100).toString();
  });

  group('load', () {
    test('should load correct value when is not null', () async {
      // ARRANGE
      when(
        () => mockDatasource.load(),
      ).thenAnswer((_) async => lastSavedNumber);

      // ACT
      final result = await sut.load();

      // ASSERT
      expect(result, lastSavedNumber);
      verify(() => mockDatasource.load()).called(1);
    });

    test('should load correct value when is null', () async {
      // ARRANGE
      when(() => mockDatasource.load()).thenAnswer((_) async => null);

      // ACT
      final result = await sut.load();

      // ASSERT
      expect(result, isNull);
      verify(() => mockDatasource.load()).called(1);
    });
  });

  group('save', () {
    test('should map entity to model and call datasource.addItem', () async {
      // ARRANGE
      when(() => mockDatasource.save(any())).thenAnswer((_) async {});

      // ACT
      await sut.save(lastSavedNumber);

      // ASSERT
      verify(() => mockDatasource.save(lastSavedNumber)).called(1);
    });
  });
}
