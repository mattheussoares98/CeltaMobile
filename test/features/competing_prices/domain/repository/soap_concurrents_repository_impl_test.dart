import 'package:celta_intelligence/features/competing_prices/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/competing_prices/data/models/models.dart';
import 'package:celta_intelligence/features/competing_prices/domain/entities/entities.dart';
import 'package:celta_intelligence/features/competing_prices/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class SoapLoadConcurrentsDatasourceSpy extends Mock
    implements ISoapConcurrentsDatasource {
  SoapLoadConcurrentsDatasourceSpy() {
    when(
      () => this.insertUpdate(
        crossIdentity: any(named: 'crossIdentity'),
        urlInUse: any(named: 'urlInUse'),
        concurrent: any(named: 'concurrent'),
      ),
    ).thenAnswer((_) async {});
  }
  void mockLoad(List<ConcurrentModel> response) {
    when(
      () => this.load(
        crossIdentity: any(named: 'crossIdentity'),
        urlInUse: any(named: 'urlInUse'),
        searchType: any(named: 'searchType'),
        searchValue: any(named: 'searchValue'),
      ),
    ).thenAnswer((_) async => response);
  }
}

void main() {
  late ISoapConcurrentsRepository sut;

  late SoapLoadConcurrentsDatasourceSpy datasource;

  late String urlInUse;
  late String crossIdentity;
  late List<ConcurrentEntity> concurrentsEntities;

  void initSut() {
    sut = SoapConcurrentsRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = SoapLoadConcurrentsDatasourceSpy();
  }

  void mockSuccess() {
    datasource.mockLoad(
      concurrentsEntities.map((e) => ConcurrentModel.fromEntity(e)).toList(),
    );
  }

  void initEntities() {
    crossIdentity = faker.guid.guid();
    urlInUse = faker.internet.httpUrl();
    concurrentsEntities = [
      EntityFactory.makeConcurrentEntity(),
      EntityFactory.makeConcurrentEntity(),
      EntityFactory.makeConcurrentEntity(),
    ];
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    for (var value in SearchConcurrentType.values) {
      registerFallbackValue(value);
    }
    registerFallbackValue(
      ConcurrentModel.fromEntity(EntityFactory.makeConcurrentEntity()),
    );
  });

  group('Load', () {
    test(
      'should behave correctly on success and pass string in searchValue',
      () async {
        final searchValue = faker.lorem.word();

        final response = await sut.load(
          crossIdentity: crossIdentity,
          urlInUse: urlInUse,
          searchValue: searchValue,
        );

        expect(response, concurrentsEntities);

        verify(
          () => datasource.load(
            crossIdentity: crossIdentity,
            urlInUse: urlInUse,
            searchType: SearchConcurrentType.approximateName,
            searchValue: searchValue,
          ),
        ).called(1);

        verifyNoMoreInteractions(datasource);
      },
    );
    test(
      'should behave correctly on success and pass int in searchValue',
      () async {
        final searchValue = faker.randomGenerator.integer(100).toString();

        final response = await sut.load(
          crossIdentity: crossIdentity,
          urlInUse: urlInUse,
          searchValue: searchValue,
        );

        expect(response, concurrentsEntities);

        verify(
          () => datasource.load(
            crossIdentity: crossIdentity,
            urlInUse: urlInUse,
            searchType: SearchConcurrentType.exactCode,
            searchValue: searchValue,
          ),
        ).called(1);

        verifyNoMoreInteractions(datasource);
      },
    );
  });

  group('Insert/update', () {
    test('Should call datasource with correct values', () async {
      await sut.insertUpdate(
        crossIdentity: crossIdentity,
        urlInUse: urlInUse,
        concurrentCode: concurrentsEntities.first.ConcurrentCode,
        concurrentName: concurrentsEntities.first.Name!,
        observation: concurrentsEntities.first.Observation!,
        address: concurrentsEntities.first.Address,
      );

      verify(
        () => datasource.insertUpdate(
          crossIdentity: crossIdentity,
          urlInUse: urlInUse,
          concurrent: ConcurrentModel.fromEntity(concurrentsEntities.first),
        ),
      );
    });
    test(
      'Should call datasource with correct values when doesnt pass the concurrent code',
      () async {
        await sut.insertUpdate(
          crossIdentity: crossIdentity,
          urlInUse: urlInUse,
          concurrentCode: null,
          concurrentName: concurrentsEntities.first.Name!,
          observation: concurrentsEntities.first.Observation!,
          address: concurrentsEntities.first.Address,
        );

        verify(
          () => datasource.insertUpdate(
            crossIdentity: crossIdentity,
            urlInUse: urlInUse,
            concurrent: ConcurrentModel.fromEntity(
              concurrentsEntities.first.copyWith(ConcurrentCode: 0),
            ),
          ),
        );
      },
    );
  });
}
