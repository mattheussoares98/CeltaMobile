import 'package:celta_inventario/features/process_authorization/presentation/pages/goods_receiving_validate_doc_xml/goods_receiving_validate_doc_xml.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase processAuthorizationGoodsReceivingValidateDocXmlRoute() => GoRoute(
  path: ':processCode/gr-validate-xml',
  name: Routes.processAuthorizationGoodsReceivingValidateDocumentXml.name,
  builder: (context, state) {
    return GoodsReceivingValidateDocXmlPage(
      processCode: int.parse(state.pathParameters['processCode']!),
    );
  },
);
