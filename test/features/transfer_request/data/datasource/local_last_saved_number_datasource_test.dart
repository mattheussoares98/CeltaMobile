import 'package:celta_inventario/features/transfer_request/data/datasource/datasource.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ILocalLastSavedNumberDatasource sut;
  late MockBox mockBox;
  late String lastSavedNumber;

  const key = 'transferRequestLastSavedNumber';

  setUp(() {
    mockBox = MockBox();
    sut = LocalLastSavedNumberDatasource(mockBox);

    lastSavedNumber = faker.randomGenerator.integer(100).toString();
  });

  group('load', () {
    test('should return correct value when is not null', () async {
      // ARRANGE
      when(
        () => mockBox.get(key, defaultValue: any(named: 'defaultValue')),
      ).thenReturn(lastSavedNumber);

      // ACT
      final result = await sut.load();

      // ASSERT
      expect(result, lastSavedNumber);
    });
    test('should return correct value when is null', () async {
      // ARRANGE
      when(
        () => mockBox.get(key, defaultValue: any(named: 'defaultValue')),
      ).thenReturn(null);

      // ACT
      final result = await sut.load();

      // ASSERT
      expect(result, isNull);
    });
  });

  group('save', () {
    test('should call box.put with correct value', () async {
      // ARRANGE
      when(
        () => mockBox.get(key, defaultValue: any(named: 'defaultValue')),
      ).thenReturn({});
      when(() => mockBox.put(any(), any())).thenAnswer((_) async {});

      // ACT
      await sut.save(lastSavedNumber);

      verify(() => mockBox.put(key, lastSavedNumber)).called(1);
    });
  });
}
