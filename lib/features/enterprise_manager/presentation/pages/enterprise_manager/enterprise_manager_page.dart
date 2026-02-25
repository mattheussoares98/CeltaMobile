import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/presentation/controllers/app_usage/app_usage.dart';
import '../../../../../routing/routing.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

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

  static final now = DateTime.now();
  static final start = DateTime(now.year, now.month, 1);
  static final end = DateTime(now.year, now.month + 1, 0);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        loadReports();
      }
    });
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
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar módulos'.hardcoded),
        actions: const [LogoutButton()],
      ),
      floatingActionButton: Consumer(
        builder: (_, ref, _) {
          final pageIndex = ref.watch(pageIndexStateControllerProvider);
          if (pageIndex != 0) {
            return const SizedBox.shrink();
          }
          return FloatingActionButton(
            onPressed: () {
              context.pushNamed(Routes.createEnterprise.name);
            },
            child: Icon(isIOS ? CupertinoIcons.add : Icons.add),
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
                icon: Icon(isIOS ? CupertinoIcons.list_bullet : Icons.list),
              ),
              BottomNavigationBarItem(
                label: 'Uso'.hardcoded,
                icon: Icon(isIOS ? CupertinoIcons.chart_bar : Icons.bar_chart),
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
              AsyncValueWidget(
                value: ref.watch(enterpriseManagerControllerProvider),
                tryAgain: () =>
                    ref.invalidate(enterpriseManagerControllerProvider),
                data: (enterprises) {
                  if (enterprises.isEmpty) {
                    return Center(
                      child: Text('Nenhuma empresa encontrada.'.hardcoded),
                    );
                  }
                  return EnterpriseItems(
                    enterprises: enterprises,
                    filterEnterpriseNameController:
                        filterEnterpriseNameController,
                  );
                },
              ),
              //TODO create separated file and organize better
              Consumer(
                builder: (_, ref, _) {
                  return AsyncValueWidget(
                    value: ref.watch(appUsageStateControllerProvider),
                    tryAgain: () => ref
                        .read(appUsageStateControllerProvider.notifier)
                        .loadRemoteUsageReport(start: start, end: end),
                    data: (usageReports) {
                      if (usageReports?.isEmpty ?? true) {
                        return Center(
                          child: Column(
                            children: [
                              Text('Nenhum uso encontrado'.hardcoded),
                              ElevatedButton(
                                onPressed: loadReports,
                                child: Text('Carregar novamente'.hardcoded),
                              ),
                            ],
                          ),
                        );
                      }

                      final usageByEnterprise = groupBy(
                        usageReports!,
                        (e) => e.enterpriseName ?? 'No group',
                      );

                      final groupEntries = usageByEnterprise.entries.toList()
                        ..sort((a, b) => a.key.compareTo(b.key));

                      return ResponsiveListFlow(
                        itemCount: groupEntries.length,
                        itemBuilder: (_, enterpriseIndex) {
                          final enterpriseName =
                              groupEntries[enterpriseIndex].key;
                          final reports = groupEntries[enterpriseIndex].value;

                          return Card(
                            child: Column(
                              children: [
                                Text(enterpriseName),
                                ...reports.map((e) {
                                  return Text(
                                    '${e.usageType.name}-${e.requestCount}',
                                  );
                                }),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
