import 'package:go_router/go_router.dart';

import 'package:celta_inventario/features/customer_register/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';

RouteBase customerRegisterRoute() => GoRoute(
  path: 'customer-register',
  name: Routes.customerRegister.name,
  builder: (context, state) {
    return const CustomerRegisterPage();
  },
);
