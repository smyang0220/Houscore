import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houscore/common/layout/default_layout.dart';
import 'package:houscore/review/component/image_upload.dart';
import 'package:houscore/review/view/create_confirmed.dart';

class CreateReviewdetail extends StatefulWidget {
  @override
  _CreateReviewdetailState createState() => _CreateReviewdetailState();
}

class _CreateReviewdetailState extends State<CreateReviewdetail> {
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
      child: Scaffold(
        appBar: AppBar(title: Text('리뷰 작성 (2/2)')),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    ElevatedButton(onPressed: () {
                      Navigator.pop(context);
                    }, child: Text('이전으로')),
                    ElevatedButton(
                      onPressed:
                          _isButtonEnabled ? () => Navigator.push(context,
                              MaterialPageRoute(builder: (context) => CreateConfirmed())) : null,
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
      ),
    );
  }

  Widget buildTextFieldSection(TextEditingController controller, String title,
      Color? color, int minChars, bool isRequired) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color ?? Colors.black)),
        Stack(
          alignment: Alignment.topRight,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '작성하신 리뷰는 승인 단계를 거쳐 다른 사용자들을 위해 노출되며,\n'
                    '\n'
                    '무의미한 내용 및 문자반복, 다른 리뷰 붙여넣기 등 성의 없는 리뷰는 승인되지 않습니다.',
                counterText: "($minChars자 이상)",
                // helperText: "",
              ),
              minLines: 2,
              maxLines: 10,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              autocorrect: false,
            ),
            Visibility(
              visible: isRequired,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('필수',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
