import 'package:flutter/material.dart';

class DefaultCustomScrollView extends StatelessWidget {
  const DefaultCustomScrollView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <SliverList>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Container(),
            childCount: 1,
          ),
        ),
      ],
    );
  }
}
