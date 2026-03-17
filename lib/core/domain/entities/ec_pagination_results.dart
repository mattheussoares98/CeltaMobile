class EcPaginationResults<T> {
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

  factory EcPaginationResults.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonItem,
  ) {
    return EcPaginationResults<T>(
      totalRecords: int.parse(json['TotalRecords'].toString()),
      recordsByPage: int.parse(json['RecordsByPage'].toString()),
      actualPage: int.parse(json['ActualPage'].toString()),
      collection: (json['Collection'] as List)
          .map((e) => fromJsonItem(e))
          .toList(),
    );
  }
}
