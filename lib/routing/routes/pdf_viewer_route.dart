import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../core/presentation/pages/pages.dart';
import '../routing.dart';

RouteBase pdfViewerRoute() => GoRoute(
  path: 'pdf-viewer',
  name: Routes.pdfViewer.name,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>;
    final fileName = extra['fileName'] as String;
    final bytes = extra['bytes'] as Uint8List;

    return PdfViewerPage(fileName: fileName, bytes: bytes);
  },
);
