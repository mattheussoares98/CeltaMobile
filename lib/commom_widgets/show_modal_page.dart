import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/constants.dart';

Future<void> showModalPage(Widget body, BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allows the modal to be full-screen
    backgroundColor: Colors.transparent,
    isDismissible: true,
    enableDrag: true,
    useSafeArea: true,
    builder: (context) {
      return Stack(
        children: [
          Positioned.fill(child: GestureDetector(onTap: context.pop)),
          DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.95,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (_, controller) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    //dragglable indicator
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: Sizes.p12),
                        height: 5,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        body: body,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      );
    },
  );
}
