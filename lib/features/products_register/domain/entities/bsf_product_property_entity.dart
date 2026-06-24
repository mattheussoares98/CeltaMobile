// ignore_for_file: public_member_api_docs

/// A single searchable property of a [BsfProductDetailEntity].
///
/// The [labelPt] is the Portuguese label the user types to find this field.
/// The [displayValue] is the formatted string shown on screen.
class BsfProductPropertyEntity {
  final String labelPt;
  final String displayValue;

  const BsfProductPropertyEntity({
    required this.labelPt,
    required this.displayValue,
  });
}
