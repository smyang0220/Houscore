import 'package:flutter/material.dart';
import 'package:houscore/common/const/color.dart';

class ResidenceNameInput extends StatefulWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  ResidenceNameInput({this.value, required this.onChanged});

  @override
  _ResidenceNameInputState createState() => _ResidenceNameInputState();
}

class _ResidenceNameInputState extends State<ResidenceNameInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.value != null) {
      _controller.text = widget.value!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '건물 이름',
            style: TextStyle(
              fontFamily: 'NotoSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            controller: _controller,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: INPUT_BORDER_COLOR,
              hintText: '건물 이름을 입력해주세요',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: INPUT_BORDER_COLOR),
                borderRadius: BorderRadius.circular(8.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: INPUT_BORDER_COLOR),
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: INPUT_BORDER_COLOR),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}