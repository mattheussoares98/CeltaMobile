import 'package:go_router/go_router.dart';

import '../../features/customer_register/presentation/pages/pages.dart';
import '../routing.dart';

RouteBase customerRegisterRoute() => GoRoute(
  path: 'customer-register',
  name: Routes.customerRegister.name,
  builder: (context, state) {
    return CustomerRegisterPage();
  },
);
