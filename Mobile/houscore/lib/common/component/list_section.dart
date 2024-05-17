import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/common/const/color.dart';

import '../const/design.dart';
import '../model/hasName.dart';
import '../model/model_with_id.dart';

abstract class IModelWithNameAndId extends IModelWithId implements HasName {
  IModelWithNameAndId({required super.id});
}

class ListSection<T extends IModelWithNameAndId>
    extends ConsumerStatefulWidget {
  final String title;
  final List<T>? list;
  final void Function(T)? onItemTap; // 아이템 탭 이벤트 핸들러
  final VoidCallback? onAddTap; // 아이템 추가 시 핸들러
  final Future<void> Function(T) onDelete; // 아이템 삭제 시 핸들러

  const ListSection({
    super.key,
    required this.title,
    this.list,
    this.onItemTap,
    this.onAddTap,
    required this.onDelete,
  });

  @override
  _ListSectionState<T> createState() => _ListSectionState<T>();
}

class _ListSectionState<T extends IModelWithNameAndId>
    extends ConsumerState<ListSection<T>> {
  bool showAll = false;

  Future<void> _showDeleteDialog(T item) async {
    bool? confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("삭제 확인"),
          content: Text("${item.name}을 삭제하시겠습니까?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("취소"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("삭제"),
            ),
          ],
        );
      },
    );
    if (confirmed == true) {
      await widget.onDelete(item);

      setState(() {
        // Remove the item from the list
        widget.list!.remove(item);
        // Update showAll state if necessary
        if (widget.list!.length <= 3) {
          showAll = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final int listLength = widget.list?.length ?? 0;
    final itemsToShow = showAll
        ? widget.list
        : widget.list?.sublist(0, listLength < 3 ? listLength : 3);
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
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,),
            ),
          ),
          if (itemsToShow != null && itemsToShow.isNotEmpty)
            ...itemsToShow.map((T item) => ListTile(
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 0,
              dense: true,
              title: Text(
                item.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey[900],
                ),
              ),
              onTap: () => widget.onItemTap?.call(item),
              trailing: IconButton(
                icon: Icon(Icons.delete, size: 20,),
                color: Colors.red,
                onPressed: () => _showDeleteDialog(item),
              ),
            )).toList(),
          SizedBox(height: VERTICAL_GAP,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: widget.onAddTap,
                child: Text('추가하기'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(PRIMARY_COLOR),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                ),
              ),
            ],
          ),
          if (widget.list != null && listLength > 3 && !showAll)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => setState(() {
                    showAll = false;
                  }),
                  child: Text('접기'),
                ),
              ],
            ),
          // Divider(
          //   thickness: 2,
          //   endIndent: 8,
          //   indent: 8,
          // ),
        ],
      ),
    );
  }
}
