import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/hasName.dart';
import '../model/model_with_id.dart';

abstract class IModelWithNameAndId extends IModelWithId implements HasName {
  IModelWithNameAndId({required super.id});
}

class ListSection<T extends IModelWithNameAndId> extends ConsumerStatefulWidget {
  final String title;
  final List<T>? list;
  final void Function(T)? onItemTap; // 아이템 탭 이벤트 핸들러

  const ListSection({
    super.key,
    required this.title,
    this.list,
    this.onItemTap,
  });

  @override
  _ListSectionState<T> createState() => _ListSectionState<T>();
}

class _ListSectionState<T extends IModelWithNameAndId> extends ConsumerState<ListSection<T>> {
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    final int listLength = widget.list?.length ?? 0;
    final itemsToShow = showAll ? widget.list : widget.list?.sublist(0, listLength < 3 ? listLength : 3);
    final remainingCount = listLength - 3;

    return Container(
      padding: EdgeInsets.all(8),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              widget.title,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          if (itemsToShow != null && itemsToShow.isNotEmpty)
            ...itemsToShow.map((T item) => Row(
              children: [
                InkWell(
                  onTap: () => widget.onItemTap?.call(item),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Text(
                      item.name,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Divider(thickness: 2, indent: 10),
              ],
            )).toList(),
          if (widget.list != null && listLength > 3 && !showAll)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => setState(() {
                    showAll = true;
                  }),
                  child: Text('외 ${remainingCount}개 더 보기'),
                ),
              ],
            ),
          if (showAll)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => setState(() {
                    showAll = false;
                  }),
                  child: Text('접기'),
                ),
              ],
            ),
          Divider(thickness: 1, endIndent: 8, indent: 8,),
        ],
      ),
    );
  }
}

