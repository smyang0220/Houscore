// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../common/model/data_state_model.dart';
// import '../../member/repository/member_repository.dart';
//
// final myInfoProvider = StateNotifierProvider<MyinfoNotifier, DataStateBase>((ref) {
//   final repository = ref.watch(memberRepositoryProvider);
//
//   final notifier = MyinfoNotifier(repository: repository);
//   return notifier;
// });
//
// // StateNotifier 클래스
// class MyinfoNotifier
//     extends StateNotifier<DataStateBase> {
//   // 실제 데이터를 받아오는 retrofit 객체
//   // API 호출 및 JsonSerializable를 활용한 모델 연동까지 자동화 + 오류처리
//   final MemberRepository repository;
//
//   MyinfoNotifier({required this.repository})
//       : super(DataStateLoading()) {
//     fetchMemberInfo();
//   }
//
//   Future<void> fetchMemberInfo() async {
//     try {
//       // 통신 결과
//       final response = await repository.getMemberInfo();
//       print(' ---------------------------------- response ${response} ----------------------------------');
//       state = DataState(data: response);
//     }
//     catch (e) {
//       state = DataStateModel.error(e.toString());
//     }
//
//     // 가상 데이터
//     // try {
//     //   final response = MemberInfo(
//     //       email: "asd123@example.com",
//     //       profileImage: "",
//     //       name: "김싸피"
//     //   );
//     //   state = DataState(response);
//     // } catch (e) {
//     //   state = DataStateModel.error(e.toString());
//     // }
//
//   }
// }
//
