import 'package:celta_inventario/core/data/datasource/enterprise/enterprise.dart';
import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/errors/errors.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSoapRequest extends Mock implements SoapRequest {}

void main() {
  late MockSoapRequest mockSoapRequest;
  late ISoapUrlValidationDatasource sut;
  final faker = Faker();

  setUp(() {
    mockSoapRequest = MockSoapRequest();
    sut = SoapUrlValidationDatasource(mockSoapRequest);
  });

  group('SoapUrlValidationDatasource - findWorkingUrl', () {
    test(
      'should return the first working URL when multiple are provided',
      () async {
        // Generate a list of random URLs
        final workingUrl = faker.internet.httpsUrl();
        final brokenUrl = faker.internet.httpsUrl();
        final urls = [brokenUrl, workingUrl];

        // Stub the broken URL to throw a generic exception (unreachable)
        when(
          () => mockSoapRequest.post(
            url: workingUrl,
            parameters: any(named: 'parameters'),
            typeOfResponse: any(named: 'typeOfResponse'),
            soapAction: any(named: 'soapAction'),
            serviceASMX: any(named: 'serviceASMX'),
            typeOfResult: any(named: 'typeOfResult'),
          ),
        ).thenThrow(HttpError(faker.lorem.sentence()));

        // Stub the working URL to return a successful response string
        when(
          () => mockSoapRequest.post(
            url: brokenUrl,
            parameters: any(named: 'parameters'),
            typeOfResponse: any(named: 'typeOfResponse'),
            soapAction: any(named: 'soapAction'),
            serviceASMX: any(named: 'serviceASMX'),
            typeOfResult: any(named: 'typeOfResult'),
          ),
        ).thenAnswer((_) async => '{}');

        final result = await sut.findWorkingUrl(urls);

        // Verify the working URL is returned and the calls were made
        expect(result, workingUrl);
        verify(
          () => mockSoapRequest.post(
            url: workingUrl,
            parameters: any(named: 'parameters'),
            typeOfResponse: any(named: 'typeOfResponse'),
            soapAction: any(named: 'soapAction'),
            serviceASMX: any(named: 'serviceASMX'),
            typeOfResult: any(named: 'typeOfResult'),
          ),
        ).called(1);
      },
    );

    test(
      'should return the URL if an HttpError occurs (signals server is reachable)',
      () async {
        final urlWithForbidden = faker.internet.httpsUrl();

        // Simulating a 403 or similar error which implies the server answered the request
        when(
          () => mockSoapRequest.post(
            url: urlWithForbidden,
            parameters: any(named: 'parameters'),
            typeOfResponse: any(named: 'typeOfResponse'),
            soapAction: any(named: 'soapAction'),
            serviceASMX: any(named: 'serviceASMX'),
            typeOfResult: any(named: 'typeOfResult'),
          ),
        ).thenThrow(HttpError(faker.lorem.sentence()));

        final result = await sut.findWorkingUrl([urlWithForbidden]);

        expect(result, urlWithForbidden);
      },
    );

    test('should throw if all URLs throw non-HttpError exceptions', () async {
      final urls = [faker.internet.httpsUrl(), faker.internet.httpsUrl()];

      // Simulating socket exceptions or timeouts for all candidates
      when(
        () => mockSoapRequest.post(
          url: any(named: 'url'),
          parameters: any(named: 'parameters'),
          typeOfResponse: any(named: 'typeOfResponse'),
          soapAction: any(named: 'soapAction'),
          serviceASMX: any(named: 'serviceASMX'),
          typeOfResult: any(named: 'typeOfResult'),
        ),
      ).thenThrow(Exception('Timeout'));

      final result = sut.findWorkingUrl(urls);

      expect(result, throwsA(isA<AppException>()));
    });

    test('should throw if the input list is empty', () async {
      final result = sut.findWorkingUrl([]);

      expect(result, throwsA(isA<AppException>()));
      verifyNever(
        () => mockSoapRequest.post(
          url: any(named: 'url'),
          parameters: any(named: 'parameters'),
          typeOfResponse: any(named: 'typeOfResponse'),
          soapAction: any(named: 'soapAction'),
          serviceASMX: any(named: 'serviceASMX'),
          typeOfResult: any(named: 'typeOfResult'),
        ),
      );
    });

    test('should filter out empty or null strings from the URL list', () async {
      final validUrl = faker.internet.httpsUrl();
      final urls = ['', '   ', validUrl];

      when(
        () => mockSoapRequest.post(
          url: validUrl,
          parameters: any(named: 'parameters'),
          typeOfResponse: any(named: 'typeOfResponse'),
          soapAction: any(named: 'soapAction'),
          serviceASMX: any(named: 'serviceASMX'),
          typeOfResult: any(named: 'typeOfResult'),
        ),
      ).thenThrow(HttpError(faker.lorem.sentence()));

      final result = await sut.findWorkingUrl(urls);

      expect(result, validUrl);
      // Ensure only the valid URL triggered a network request
      verify(
        () => mockSoapRequest.post(
          url: validUrl,
          parameters: any(named: 'parameters'),
          typeOfResponse: any(named: 'typeOfResponse'),
          soapAction: any(named: 'soapAction'),
          serviceASMX: any(named: 'serviceASMX'),
          typeOfResult: any(named: 'typeOfResult'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockSoapRequest);
    });
  });
}
