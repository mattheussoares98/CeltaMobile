import 'package:celta_inventario/constants/app_sizes.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../controllers/controllers.dart';

class PriceField extends ConsumerStatefulWidget {
  final bool allowPriceChange;

  const PriceField({super.key, required this.allowPriceChange});

  @override
  ConsumerState<PriceField> createState() => _PriceFieldState();
}

class _PriceFieldState extends ConsumerState<PriceField>
    with SingleTickerProviderStateMixin {
  final _valueController = TextEditingController();
  final _focusNode = FocusNode();
  late final AnimationController _animationController;
  late final Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _colorAnimation =
        ColorTween(
          begin: Colors.transparent,
          end: Colors.blue.withValues(alpha: 0.4),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final product = ref.read(currentProductItemProvider);
        _valueController.text = (product.value ?? 0)
            .toString()
            .toBrazilianNumber(2);
      }
    });
  }

  @override
  void dispose() {
    _valueController.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = ref.watch(currentProductItemProvider);
    final uiProvider = insertProductUIControllerProvider(product);

    ref.listen(uiProvider.select((s) => s.price), (p, n) {
      if (!_focusNode.hasPrimaryFocus) {
        final nextPriceStr = n.toString().toBrazilianNumber(2);
        if (_valueController.text != nextPriceStr) {
          _valueController.text = nextPriceStr;
          _animationController.forward().then(
            (_) => _animationController.reverse(),
          );
        }
      }
    });

    final uiState = ref.watch(uiProvider);
    final currentProduct = uiState.applyTo(product);
    final practicedPriceType = currentProduct.practicedPriceType;

    final priceTypeName = switch (practicedPriceType) {
      PracticedPriceType.retail => 'VAREJO',
      PracticedPriceType.whole => 'ATACADO',
      PracticedPriceType.manual => 'MANUAL',
      _ => 'N/D',
    };

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              color: _colorAnimation.value,
              borderRadius: BorderRadius.circular(Sizes.p8),
            ),
            child: child,
          );
        },
        child: DefaultTextFormField(
          controller: _valueController,
          focusNode: _focusNode,
          labelText: 'Preço R\$ ($priceTypeName)'.hardcoded,
          enabled: widget.allowPriceChange,
          onChanged: (value) {
            ref.read(uiProvider.notifier).updatePrice(value.toDouble() ?? 0);
          },
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          validator: FormValidators.compose([
            NonEmptyValidator(),
            NumberValidator(allowDecimal: true, maxDecimalHouses: 3),
          ]),
        ),
      ),
    );
  }
}
