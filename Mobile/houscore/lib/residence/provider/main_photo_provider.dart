import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/common/model/data_list_state_model.dart';
import 'package:houscore/residence/model/residence_main_photo_model.dart';
import 'package:houscore/residence/repository/main_photo_repository.dart';

import '../../common/provider/data_list_provider.dart';

final mainPhotoProvider = StateNotifierProvider<
    MainPhotoStateNotifier, DataListStateBase>((ref) {
  final repo = ref.watch(mainPhotoRepositoryProvider);

  return MainPhotoStateNotifier(repository: repo,);
});

class MainPhotoStateNotifier
    extends DataListProvider<ResidenceMainPhotoModel, MainPhotoRepository> {
  MainPhotoStateNotifier({
    required super.repository,
  });
}