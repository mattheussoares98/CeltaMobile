// lib/features/process_authorization/domain/entities/bsf_authorization_process_item_type.dart
enum BSFProcessAuthorizationItemType {
  normalAuthorization(1),
  authorizationDefinedForTheDefendantHandler(2);

  final int value;
  const BSFProcessAuthorizationItemType(this.value);

  factory BSFProcessAuthorizationItemType.fromValue(int? value) {
    return BSFProcessAuthorizationItemType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => BSFProcessAuthorizationItemType.normalAuthorization,
    );
  }
}
