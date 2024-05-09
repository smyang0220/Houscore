import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houscore/common/const/color.dart';
import 'package:houscore/common/layout/default_layout.dart';
import 'package:houscore/review/component/image_upload.dart';
import 'package:houscore/review/view/create_confirmed.dart';

class CreateReviewDetail extends StatefulWidget {
  @override
  _CreateReviewDetailState createState() => _CreateReviewDetailState();
}

      class _CreateReviewDetailState extends State<CreateReviewDetail> {
      final TextEditingController _recommendController = TextEditingController();
      final TextEditingController _dislikeController = TextEditingController();
      final TextEditingController _maintenanceController = TextEditingController();

      bool _isRecommendRequired = true;
      bool _isDislikeRequired = true;
      bool _isMaintenanceRequired = true;
      bool _isButtonEnabled = false;

      void _updateButtonState() {
      setState(() {
      _isRecommendRequired = _recommendController.text.length < 100;
      _isDislikeRequired = _dislikeController.text.length < 100;
      _isMaintenanceRequired = _maintenanceController.text.length < 10;

      _isButtonEnabled = _recommendController.text.length >= 100 &&
      _dislikeController.text.length >= 100 &&
          _maintenanceController.text.length >= 10;
    });
  }

  @override
  void initState() {
    super.initState();
    _recommendController.addListener(_updateButtonState);
    _dislikeController.addListener(_updateButtonState);
    _maintenanceController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _recommendController.dispose();
    _dislikeController.dispose();
    _maintenanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                  child:
                    Text(
                      '리뷰 작성하기 (2/2)',
                      style: TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
              ),
              buildTextFieldSection(_recommendController, '추천해요!', Colors.blue,
                  100, _isRecommendRequired),
              SizedBox(height: 5),
              buildTextFieldSection(_dislikeController, '별로예요!', Colors.red,
                  100, _isDislikeRequired),
              SizedBox(height: 5),
              buildTextFieldSection(_maintenanceController, '관리비', null, 10,
                  _isMaintenanceRequired),
              SizedBox(height: 5),
              ImageUpload(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('이전으로')),
                  ElevatedButton(
                    onPressed: _isButtonEnabled
                        ? () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateConfirmed()))
                        : null,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled))
                            return Colors.grey;
                          return Colors.blue; // Default enabled color
                        },
                      ),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: Text('완료'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextFieldSection(TextEditingController controller, String title,
      Color? color, int minChars, bool isRequired) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: color ?? Colors.black),
            ),
            Text('$minChars자 이상'),
          ],
        ),
        SizedBox(height: 10),
        Stack(
          alignment: Alignment.topRight,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: INPUT_BORDER_COLOR,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: INPUT_BORDER_COLOR), // 테두리 색상
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: INPUT_BORDER_COLOR), // 테두리 색상을 유지
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: INPUT_BORDER_COLOR), // 포커스 받았을 때의 색상
                  borderRadius: BorderRadius.circular(8.0),
                ),
                hintText: '작성하신 리뷰는 승인 단계를 거쳐 다른 사용자들을 위해 노출되며,\n'
                    '\n'
                    '무의미한 내용 및 문자반복, 다른 리뷰 붙여넣기 등 성의 없는 리뷰는 승인되지 않습니다.',
                counterStyle: TextStyle(color: isRequired? Colors.red : Colors.black),
              ),
              minLines: 2,
              maxLines: 10,
              maxLength: 500,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              autocorrect: false,
            ),
          ],
        ),
      ],
    );
  }
}
