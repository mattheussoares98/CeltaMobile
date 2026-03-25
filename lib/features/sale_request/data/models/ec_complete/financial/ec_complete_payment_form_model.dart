import 'package:equatable/equatable.dart';

class EcCompletePaymentFormModel extends Equatable {
  final int? type;
  final String? reducedName;
  final String? name;

  const EcCompletePaymentFormModel({
    required this.type,
    required this.reducedName,
    required this.name,
  });

  factory EcCompletePaymentFormModel.fromJson(Map<String, dynamic> json) =>
      EcCompletePaymentFormModel(
        type: json['Type'],
        reducedName: json['ReducedName'],
        name: json['Name'],
      );

  Map<String, dynamic> toJson() => {
    'Type': type,
    'ReducedName': reducedName,
    'Name': name,
  };

  @override
  List<Object?> get props => [type, name];
}
