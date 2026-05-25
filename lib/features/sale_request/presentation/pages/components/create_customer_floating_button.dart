import 'package:celta_inventario/commom_widgets/platform_icon.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/customer_register/presentation/controllers/controllers.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateCustomerFloatingButton extends ConsumerWidget {
  final int enterpriseCode;
  const CreateCustomerFloatingButton({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(pageIndexStateControllerProvider);
    if (currentIndex != 1) {
      return const SizedBox.shrink();
    }

    return FloatingActionButton(
      child: const PlatformIcon(
        cupertinoIcon: CupertinoIcons.person_add,
        materialIcon: Icons.person_add_alt_1_outlined,
      ),
      onPressed: () {
        ref
            .read(tryAccessModuleControllerProvider.notifier)
            .tryAccess(
              context: context,
              module: Modules.customerRegister,
              route: Routes.customerRegister,
              enterpriseCode: enterpriseCode,
            );
      },
    );
  }
}
