import 'package:celta_inventario/features/reports/data/datasource/datasource.dart';
import 'package:celta_inventario/features/reports/data/models/models.dart';
import 'package:celta_inventario/features/reports/domain/entities/entities.dart';
import 'package:celta_inventario/features/reports/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class SoapLoadReportsDatasourceSpy extends Mock
    implements ISoapLoadReportsDatasource {
  void mockLoad(List<ReportScheduleModel> response) => when(
    () => this.load(
      workingUrl: any(named: 'workingUrl'),
      crossIdentity: any(named: 'crossIdentity'),
    ),
  ).thenAnswer((_) async => response);
}

void main() {
  late ISoapLoadReportsRepository sut;
  late SoapLoadReportsDatasourceSpy mockDatasource;

  late List<ReportScheduleEntity> reportsEntities;

  late String workingUrl;
  late String crossIdentity;

  setUp(() {
    mockDatasource = SoapLoadReportsDatasourceSpy();
    sut = SoapLoadReportsRepositoryImpl(mockDatasource);

    reportsEntities = [
      EntityFactory.makeReportScheduleEntity(),
      EntityFactory.makeReportScheduleEntity(),
      EntityFactory.makeReportScheduleEntity(),
    ];

    workingUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();

    mockDatasource.mockLoad(
      reportsEntities.map((e) => ReportScheduleModel.fromEntity(e)).toList(),
    );
  });

  test('should behave correctly on success', () async {
    final response = await sut.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
    );

    expect(response, reportsEntities);

    verify(
      () => mockDatasource.load(
        workingUrl: workingUrl,
        crossIdentity: crossIdentity,
      ),
    ).called(1);
  });
}
