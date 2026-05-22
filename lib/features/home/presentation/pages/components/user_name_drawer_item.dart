import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/home/presentation/pages/components/components.dart';

class UserNameDrawerItem extends ConsumerWidget {
  const UserNameDrawerItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(
      userSessionProvider.select((s) => s.value?.user.name ?? ''),
    );

    return DrawerItem(
      message: userName,
      platformIcon: const PlatformIcon(
        materialIcon: Icons.person,
        cupertinoIcon: CupertinoIcons.person,
      ),
      onTap: null,
    );
  }
}
