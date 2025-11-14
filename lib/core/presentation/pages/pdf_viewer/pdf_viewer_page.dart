import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'pdf_viewer.dart';

class PdfViewerPage extends StatefulWidget {
  final String fileName;
  final Uint8List bytes;
  const PdfViewerPage({super.key, required this.fileName, required this.bytes});

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late final PdfViewerController _pdfController;
  final _searchTextController = TextEditingController();
  PdfTextSearchResult _searchResult = PdfTextSearchResult();
  bool _isSearchVisible = false;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );

    super.initState();

    _pdfController = PdfViewerController();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _searchTextController.dispose();
    _pdfController.dispose();

    _searchResult.removeListener(_searchResultListener);
    super.dispose();
  }

  void _toggleSearchUI() {
    setState(() {
      if (_isSearchVisible) {
        _searchResult.clear();
        _searchTextController.clear();
      }
      _isSearchVisible = !_isSearchVisible;
    });
  }

  void _searchResultListener() {
    if (_searchResult.hasResult) {
      setState(() {});
    }
  }

  Future<void> _performSearch() async {
    final String searchText = _searchTextController.text;

    if (searchText.isEmpty) {
      setState(() {
        _searchResult.clear();
      });
      return;
    }

    _searchResult = _pdfController.searchText(searchText);

    _searchResult.addListener(_searchResultListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSearchVisible
          ? SearchTextAppBar(
                  toggleSearchUI: _toggleSearchUI,
                  performSearch: _performSearch,
                  searchTextController: _searchTextController,
                  searchResult: _searchResult,
                )
                as PreferredSizeWidget
          : AppBarWithTitle(
              bytes: widget.bytes,
              fileName: widget.fileName,
              toggleSearchUI: _toggleSearchUI,
            ),
      body: SfPdfViewer.memory(
        enableDoubleTapZooming: true,
        enableTextSelection: true,
        enableDocumentLinkAnnotation: true,
        enableHyperlinkNavigation: true,
        interactionMode: PdfInteractionMode.selection,
        canShowScrollStatus: true,
        canShowScrollHead: true,
        widget.bytes,
        canShowTextSelectionMenu: true,
        controller: _pdfController,
        currentSearchTextHighlightColor: Colors.amber[700]!.withAlpha(200),
      ),
    );
  }
}
