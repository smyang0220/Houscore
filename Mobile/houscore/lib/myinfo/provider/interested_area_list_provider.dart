// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:houscore/member/model/interested_area.dart';
// import '../../common/model/data_state_model.dart';
// import '../repository/member_repository.dart';
//
// final interestedAreaListProvider = StateNotifierProvider<InterestedAreaListNotifier, DataStateBase>((ref) {
//   final repository = ref.watch(memberRepositoryProvider);
//
//   final notifier = InterestedAreaListNotifier(repository: repository);
//   return notifier;
// });
//
// // StateNotifier 클래스
// class InterestedAreaListNotifier extends StateNotifier<DataStateBase> {
//   // 실제 데이터를 받아오는 retrofit 객체
//   // API 호출 및 JsonSerializable를 활용한 모델 연동까지 자동화 + 오류처리
//   final MemberRepository repository;
//
//   InterestedAreaListNotifier({required this.repository})
//       : super(DataStateLoading()) {
//     fetchInterestedAreaList();
//   }
// }
//
