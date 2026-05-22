import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';

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
        icon: const PlatformIcon(
          cupertinoIcon: CupertinoIcons.xmark,
          materialIcon: Icons.close,
        ),
        onPressed: widget.toggleSearchUI,
      ),
      title: TextField(
        controller: widget.searchTextController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Pesquisar...'.hardcoded,
          border: InputBorder.none,
        ),
        onSubmitted: (_) => widget.performSearch(),
      ),
      actions: [
        IconButton(
          icon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.search,
            materialIcon: Icons.search,
          ),
          onPressed: widget.performSearch,
          tooltip: 'Pesquisar'.hardcoded,
        ),
        IconButton(
          icon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.arrow_up,
            materialIcon: Icons.keyboard_arrow_up,
          ),
          onPressed: () {
            if (widget.searchResult.totalInstanceCount > 0) {
              widget.searchResult.previousInstance();
            }
          },
          tooltip: 'Anterior'.hardcoded,
        ),
        IconButton(
          icon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.arrow_down,
            materialIcon: Icons.keyboard_arrow_down,
          ),
          onPressed: () {
            if (widget.searchResult.totalInstanceCount > 0) {
              widget.searchResult.nextInstance();
            }
          },
          tooltip: 'Próximo'.hardcoded,
        ),
      ],
    );
  }
}
