import 'package:equatable/equatable.dart';

class SessionModel extends Equatable {
  final String? baseUrl;
  const SessionModel({this.baseUrl});

  Map<String, dynamic> toJson() => {'baseUrl': baseUrl};

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      SessionModel(baseUrl: json['baseUrl']);

  @override
  List<Object?> get props => [baseUrl];
}
