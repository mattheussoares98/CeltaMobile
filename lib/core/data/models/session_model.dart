import 'package:equatable/equatable.dart';

class SessionModel extends Equatable {
  //TODO add legacy and personalizedCode search modes
  final String? baseUrl;
  const SessionModel({required this.baseUrl});

  Map<String, dynamic> toJson() => {'baseUrl': baseUrl};

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      SessionModel(baseUrl: json['baseUrl']);

  @override
  List<Object?> get props => [baseUrl];
}
