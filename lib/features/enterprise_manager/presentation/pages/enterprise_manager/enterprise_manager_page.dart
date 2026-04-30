import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/presentation/controllers/app_usage/app_usage.dart';
import '../../../../../routing/routing.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';
import 'enterprises/enterprises.dart';
import 'reports/reports.dart';

class EnterpriseManagerPage extends ConsumerStatefulWidget {
  const EnterpriseManagerPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EnterpriseManagerPageState();
}

class _EnterpriseManagerPageState extends ConsumerState<EnterpriseManagerPage> {
  final enterpriseNameController = TextEditingController();
  final remoteHttpUrlController = TextEditingController();
  final remoteHttpsUrlController = TextEditingController();
  final localHttpUrlController = TextEditingController();
  final localHttpsUrlController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final filterEnterpriseNameController = TextEditingController();
  final urlFocusNode = FocusNode();
  final userNameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  late final ScrollController _reportsScrollController;
  final ValueNotifier<bool> _showScrollToTop = ValueNotifier(false);

  static final now = DateTime.now();
  static final start = DateTime(now.year, now.month, 1);
  static final end = DateTime(now.year, now.month + 1, 0);

  @override
  void initState() {
    super.initState();

    _reportsScrollController = ScrollController();
    _reportsScrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        loadReports();
      }
    });
  }

  void _scrollListener() {
    // PERFORMANCE: Only update the notifier when the threshold is crossed
    // to minimize listener notifications.
    if (_reportsScrollController.offset > 900 && !_showScrollToTop.value) {
      _showScrollToTop.value = true;
    } else if (_reportsScrollController.offset <= 900 &&
        _showScrollToTop.value) {
      _showScrollToTop.value = false;
    }
  }

  void loadReports() {
    ref
        .read(appUsageStateControllerProvider.notifier)
        .loadRemoteUsageReport(start: start, end: end);
  }

  @override
  void dispose() {
    super.dispose();

    enterpriseNameController.dispose();
    remoteHttpUrlController.dispose();
    remoteHttpsUrlController.dispose();
    localHttpUrlController.dispose();
    localHttpsUrlController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    filterEnterpriseNameController.dispose();
    urlFocusNode.dispose();
    userNameFocusNode.dispose();
    passwordFocusNode.dispose();

    _reportsScrollController.removeListener(_scrollListener);
    _reportsScrollController.dispose();
    _showScrollToTop.dispose();
  }

  Future<void> onSubmit() async {
    await ref
        .read(createEnterpriseControllerProvider.notifier)
        .createEnterprise(
          remoteHttpUrl: remoteHttpUrlController.text,
          remoteHttpsUrl: remoteHttpsUrlController.text,
          localHttpUrl: localHttpUrlController.text,
          localHttpsUrl: localHttpsUrlController.text,
          enterpriseName: enterpriseNameController.text,
          password: passwordController.text,
          userName: userNameController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar módulos'.hardcoded),
        actions: const [LogoutButton()],
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _showScrollToTop,
        builder: (context, showUp, child) {
          return Consumer(
            builder: (_, ref, _) {
              final pageIndex = ref.watch(pageIndexStateControllerProvider);

              if (pageIndex == 0) {
                return FloatingActionButton(
                  key: const ValueKey('add_enterprise_fab'),
                  onPressed: () =>
                      context.pushNamed(Routes.createEnterprise.name),
                  child: const PlatformIcon(
                    cupertinoIcon: CupertinoIcons.add,
                    materialIcon: Icons.add,
                  ),
                );
              }

              // Show 'Scroll to Top' button if threshold is met on Reports tab
              if (pageIndex == 1 && showUp) {
                return FloatingActionButton(
                  key: const ValueKey('scroll_to_top_fab'),
                  onPressed: () {
                    _reportsScrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const PlatformIcon(
                    cupertinoIcon: CupertinoIcons.arrow_up,
                    materialIcon: Icons.arrow_upward,
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          );
        },
      ),
      bottomNavigationBar: Consumer(
        builder: (_, ref, _) {
          return BottomNavigationBar(
            onTap: ref
                .read(pageIndexStateControllerProvider.notifier)
                .updateIndex,
            currentIndex: ref.watch(pageIndexStateControllerProvider),
            items: [
              BottomNavigationBarItem(
                label: 'Empresas'.hardcoded,
                icon: const PlatformIcon(
                  cupertinoIcon: CupertinoIcons.list_bullet,
                  materialIcon: Icons.list,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Uso'.hardcoded,
                icon: const PlatformIcon(
                  cupertinoIcon: CupertinoIcons.chart_bar,
                  materialIcon: Icons.bar_chart,
                ),
              ),
            ],
          );
        },
      ),
      body: Consumer(
        builder: (_, ref, _) {
          return IndexedStack(
            index: ref.watch(pageIndexStateControllerProvider),
            children: [
              EnterprisesPage(
                filterEnterpriseNameController: filterEnterpriseNameController,
              ),
              ReportsPage(scrollController: _reportsScrollController),
            ],
          );
        },
      ),
    );
  }
}
