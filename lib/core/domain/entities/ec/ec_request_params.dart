import 'package:equatable/equatable.dart';

class EcRequestParams extends Equatable {
  final String workingUrl;
  final String user;
  final String accessKey;
  final int? actualPage;
  final int? recordsByPage;

  const EcRequestParams({
    required this.workingUrl,
    required this.user,
    required this.accessKey,
    this.actualPage = 1,
    this.recordsByPage = 50,
  });

  @override
  List<Object?> get props => [
    workingUrl,
    user,
    accessKey,
    actualPage,
    recordsByPage,
  ];

  Map<String, dynamic> toMap() {
    return {'actualPage': actualPage, 'recordsByPage': recordsByPage};
  }

  /// Helper for Header generation
  Map<String, String> toHeaders() {
    return {'user': user, 'accessKey': accessKey};
  }
}
