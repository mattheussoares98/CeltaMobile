import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../controllers/controller.dart';
import 'components/components.dart';

class InsertUpdatePage extends ConsumerStatefulWidget {
  final int code;
  final int enterpriseCode;
  const InsertUpdatePage({
    super.key,
    required this.code,
    required this.enterpriseCode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InsertUpdatePageState();
}

class _InsertUpdatePageState extends ConsumerState<InsertUpdatePage> {
  final observationController = TextEditingController();
  final searchValueController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final value = await ref.read(
          completeBuyQuotationsStateControllerProvider(
            widget.enterpriseCode,
            widget.code.toString(),
          ).future,
        );
        if (value.Observations != null && value.Observations!.isNotEmpty) {
          observationController.text = value.Observations!;
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    observationController.dispose();
    searchValueController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.code == 0 ? 'Inserindo'.hardcoded : 'Alterando'.hardcoded,
        ),
      ),
      body: AsyncValueWidget(
        value: ref.watch(
          completeBuyQuotationsStateControllerProvider(
            widget.enterpriseCode,
            widget.code.toString(),
          ),
        ),
        tryAgain: () => ref.invalidate(
          completeBuyQuotationsStateControllerProvider(
            widget.enterpriseCode,
            widget.code.toString(),
          ),
        ),
        data: (buyQuotation) {
          return Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: CustomScrollView(
              slivers: [
                Code(buyQuotation: buyQuotation),
                CreationDate(buyQuotation: buyQuotation),
                LimitDate(
                  buyQuotation: buyQuotation,
                  enterpriseCode: widget.enterpriseCode,
                ),
                gapSliverH8,
                BuyersDropdown(
                  buyQuotation: buyQuotation,
                  enterpriseCode: widget.enterpriseCode,
                ),
                gapSliverH8,
                ObservationField(observationController: observationController),
                const SliverToBoxAdapter(child: Divider()),
                Enterprises(
                  enterpriseCode: widget.enterpriseCode,
                  buyQuotation: buyQuotation,
                ),
                const SliverToBoxAdapter(child: Divider()),
                SearchProductField(
                  enterpriseCode: widget.enterpriseCode,
                  searchValueController: searchValueController,
                  buyQuotation: buyQuotation,
                ),
                gapSliverH8,
                ProductsItems(buyQuotation: buyQuotation),
              ],
            ),
          );
        },
      ),
    );
  }
}
