import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SearchTextAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(35);

  final VoidCallback toggleSearchUI;
  final VoidCallback performSearch;
  final TextEditingController searchTextController;
  final PdfTextSearchResult searchResult;
  const SearchTextAppBar({
    super.key,
    required this.toggleSearchUI,
    required this.performSearch,
    required this.searchTextController,
    required this.searchResult,
  });

  @override
  State<SearchTextAppBar> createState() => _SearchTextAppBarState();
}

class _SearchTextAppBarState extends State<SearchTextAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: widget.toggleSearchUI,
      ),
      title: TextField(
        controller: widget.searchTextController,
        autofocus: true,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: 'Pesquisar...',
          hintStyle: TextStyle(color: Colors.white60),
          border: InputBorder.none,
        ),
        onSubmitted: (_) => widget.performSearch(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: widget.performSearch,
          tooltip: 'Pesquisar',
        ),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_up),
          onPressed: () {
            if (widget.searchResult.totalInstanceCount > 0) {
              widget.searchResult.previousInstance();
            }
          },
          tooltip: 'Anterior',
        ),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () {
            if (widget.searchResult.totalInstanceCount > 0) {
              widget.searchResult.nextInstance();
            }
          },
          tooltip: 'Próximo',
        ),
      ],
    );
  }
}
