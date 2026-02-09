import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../providers/url_launch/url_launch.dart';

part 'url_launch_controller.g.dart';

@riverpod
class UrlLaunchController extends _$UrlLaunchController {
  @override
  FutureOr<void> build() {}

  Future<void> launch(String url) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(urlLaunchDatasourceProvider).launch(url);
    });
  }
}
