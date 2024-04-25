import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houscore/review/ImageUpload.dart';
import 'ImageUpload.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    // home: createReview2ndPage(),
    home: ImageUpload(),

  ));
}

class createReview2ndPage extends StatefulWidget {
  @override
  _createReview2ndPageState createState() => _createReview2ndPageState();
}

class _createReview2ndPageState extends State<createReview2ndPage> {
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text('리뷰 작성 (2/2)')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextFieldSection(_recommendController, '추천해요!', Colors.blue,
                  100, _isRecommendRequired),
              SizedBox(height: 20),
              buildTextFieldSection(_dislikeController, '별로에요!', Colors.red,
                  100, _isDislikeRequired),
              SizedBox(height: 20),
              buildTextFieldSection(_maintenanceController, '관리비', null, 10,
                  _isMaintenanceRequired),
              SizedBox(height: 30),
              Container(),
              //TODO 여기에 imguploader 들어가야 함
              ElevatedButton(
                onPressed:
                    _isButtonEnabled ? () => print('제출 버튼이 눌렸습니다.') : null,
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
                helperText: "",
              ),
              minLines: 4,
              maxLines: 100,
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
