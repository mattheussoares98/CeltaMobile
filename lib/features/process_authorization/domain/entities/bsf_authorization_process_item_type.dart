// lib/features/process_authorization/domain/entities/bsf_authorization_process_item_type.dart
enum BSFAuthorizationProcessItemType {
  normalAuthorization(1),
  authorizationDefinedForTheDefendantHandler(2);

  final int value;
  const BSFAuthorizationProcessItemType(this.value);

  factory BSFAuthorizationProcessItemType.fromValue(int? value) {
    return BSFAuthorizationProcessItemType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => BSFAuthorizationProcessItemType.normalAuthorization,
    );
  }
}
