import 'package:equatable/equatable.dart';

class UserSessionModel extends Equatable {
  //TODO add legacy and personalizedCode search modes
  final String? baseUrl;
  const UserSessionModel({required this.baseUrl});

  Map<String, dynamic> toJson() => {'baseUrl': baseUrl};

  factory UserSessionModel.fromJson(Map<String, dynamic> json) =>
      UserSessionModel(baseUrl: json['baseUrl']);

  @override
  List<Object?> get props => [baseUrl];
}
