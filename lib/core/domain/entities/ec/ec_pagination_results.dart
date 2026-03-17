import 'package:equatable/equatable.dart';

class EcPaginationResults<T> extends Equatable {
  final int totalRecords;
  final int recordsByPage;
  final int actualPage;
  final List<T> collection;

  const EcPaginationResults({
    required this.totalRecords,
    required this.recordsByPage,
    required this.actualPage,
    required this.collection,
  });

  @override
  List<Object?> get props => [
    totalRecords,
    recordsByPage,
    actualPage,
    collection,
  ];

  factory EcPaginationResults.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonItem,
  ) {
    return EcPaginationResults<T>(
      totalRecords: json['totalRecords'],
      recordsByPage: json['recordsByPage'],
      actualPage: json['actualPage'],
      collection: (json['collection'] as List)
          .map((e) => fromJsonItem(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonItem) {
    return <String, dynamic>{
      'totalRecords': totalRecords,
      'recordsByPage': recordsByPage,
      'actualPage': actualPage,
      'collection': collection.map(toJsonItem).toList(),
    };
  }

  EcPaginationResults<R> map<R>(R Function(T item) mapper) {
    return EcPaginationResults<R>(
      totalRecords: totalRecords,
      recordsByPage: recordsByPage,
      actualPage: actualPage,
      collection: collection.map(mapper).toList(),
    );
  }
}
