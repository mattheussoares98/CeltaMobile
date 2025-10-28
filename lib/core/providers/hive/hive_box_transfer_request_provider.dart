import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../infraestructure/infrastructure.dart';

part 'hive_box_transfer_request_provider.g.dart';

@Riverpod(keepAlive: true)
Box hiveBoxTransferRequest(Ref ref) {
  return Hive.box(DatabaseConstants.transferRequestCart.name);
}
