import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:flutter/material.dart';

class PageActionSelectorModel {
  final String title;
  final String subtitle;
  final PlatformIcon platformIcon;
  final Color color;
  final Routes route;

  PageActionSelectorModel({
    required this.title,
    required this.subtitle,
    required this.platformIcon,
    required this.color,
    required this.route,
  });
}
