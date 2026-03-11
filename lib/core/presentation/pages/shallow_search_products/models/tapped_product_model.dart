import 'models.dart';

class TappedProductModel {
  final int? codigoInternoProEmb;
  final String? textField;
  final ClosePageAction closedShallowPageType;

  TappedProductModel({
    required this.codigoInternoProEmb,
    required this.textField,
    required this.closedShallowPageType,
  });
}
