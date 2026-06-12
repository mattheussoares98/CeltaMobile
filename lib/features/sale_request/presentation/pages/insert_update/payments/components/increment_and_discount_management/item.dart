import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/utils/extensions/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Item extends ConsumerStatefulWidget {
  final BSFValueTypeEntity? valueType;
  final bool allowUpdate;
  final String title;
  final void Function(BSFValueTypeEntity value) onUpdate;
  final VoidCallback onRemove;
  final String notAllowedMessage;
  const Item({
    super.key,
    required this.valueType,
    required this.allowUpdate,
    required this.title,
    required this.onUpdate,
    required this.onRemove,
    required this.notAllowedMessage,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ItemState();
}

class _ItemState extends ConsumerState<Item> {
  @override
  Widget build(BuildContext context) {
    final value = widget.valueType?.value ?? 0;

    if (value == 0 && !widget.allowUpdate) {
      return const SizedBox.shrink();
    }

    final subtitle = value > 0
        ? '${widget.valueType?.value?.toString().toBrazilianNumber()} ${widget.valueType?.type?.symbol ?? ''}'
        : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!widget.allowUpdate && value > 0)
              Text(
                widget.notAllowedMessage,
                style: context.theme.textTheme.titleMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Colors.red,
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: TitleAndSubTitle(
                    title: widget.title,
                    subTitle: subtitle,
                    removeColon: subtitle == null,
                  ),
                ),
                if (widget.allowUpdate)
                  IconButton(
                    onPressed: () {},
                    icon: value > 0
                        ? const PlatformIcon(
                            cupertinoIcon: CupertinoIcons.pencil,
                            materialIcon: Icons.edit,
                          )
                        : const PlatformIcon(
                            cupertinoIcon: CupertinoIcons.plus,
                            materialIcon: Icons.add,
                          ),
                  ),
                if (value > 0)
                  IconButton(
                    onPressed: widget.onRemove,
                    icon: const PlatformIcon(
                      cupertinoIcon: CupertinoIcons.delete,
                      materialIcon: Icons.delete,
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
