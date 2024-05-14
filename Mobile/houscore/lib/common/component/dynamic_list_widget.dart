// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:houscore/common/const/color.dart';
// import 'package:houscore/common/provider/item_list_provider.dart';
//
// // StateNotifierProvider는 외부에서 주입
// class DynamicListWidget<T> extends ConsumerWidget {
//   final String title; // 제목
//   final int initialItemCount; // 처음 노출되는 갯수
//   final VoidCallback onAddPressed; // 추가하기 콜백함수
//   final String showMoreText;
//   final String showLessText;
//   final Widget showMoreIcon;
//   final Widget showLessIcon;
//   // final StateNotifierProvider<ItemListNotifier, List<String>> itemListProvider;
//   final StateNotifierProvider<ItemListNotifier<T>, List<T>> itemListProvider;
//
//   final StateProvider<bool> expandedStateProvider = StateProvider<bool>((ref) => false);
//
//   DynamicListWidget({
//     required this.title,
//     required this.initialItemCount,
//     required this.onAddPressed,
//     required this.showMoreText,
//     required this.showLessText,
//     required this.showMoreIcon,
//     required this.showLessIcon,
//     required this.itemListProvider,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // 리스트 아이템
//     List<T> items = ref.watch(itemListProvider);
//     // 리스트 더보기 / 접기 변수
//     bool isExpanded = ref.watch(expandedStateProvider);
//     // 추가하기 최대 갯수에 따른 버튼 활성화 여부
//     bool addButtonDisabled = items.length > 20;
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//         SizedBox(height: 8),
//         ElevatedButton(
//         onPressed: addButtonDisabled ? null : onAddPressed,
//           child: Text('추가하기', style: TextStyle(color: addButtonDisabled ? Colors.black : Colors.white)),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: PRIMARY_COLOR,
//             disabledBackgroundColor: Colors.grey, // 버튼 비활성화 시 배경색
//           ),
//         ),
//         ...items.take(isExpanded ? items.length : initialItemCount).map((item) => ListTile(title: Text(item.toString()))).toList(),
//         if (items.length > initialItemCount) TextButton(
//           onPressed: () {
//             ref.read(expandedStateProvider.notifier).state = !isExpanded;
//             if (!isExpanded && items.length == initialItemCount) {
//             }
//           },
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(isExpanded ? showLessText : showMoreText),
//               SizedBox(width: 8),
//               isExpanded ? showLessIcon : showMoreIcon,
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
