import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/common/const/color.dart';
import 'package:houscore/common/layout/default_layout.dart';
import 'package:houscore/review/view/create_confirmed.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../residence/utils/place_utils.dart';
import '../model/review_model.dart';
import '../model/star_rating_model.dart';
import '../repository/review_repository.dart';
import 'create_review.dart';

class CreateReviewDetail extends ConsumerStatefulWidget {
  final ReviewData reviewData;

  CreateReviewDetail({required this.reviewData});

  @override
  ConsumerState createState() => _CreateReviewDetailState();
}

class _CreateReviewDetailState extends ConsumerState<CreateReviewDetail> {
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

  //TODO 뒤로가기하면 사진 없어지도록 처리
  //TODO 사진 필수 처리
  @override
  void dispose() {
    _recommendController.dispose();
    _dislikeController.dispose();
    _maintenanceController.dispose();
    super.dispose();
  }

  void submitReview() async {
    List<int> imageBytes = await images[0]!.readAsBytes();
    String base64String = base64Encode(imageBytes);

    String convertedAddress = PlaceUtils.mapAddressForAPI(widget.reviewData.selectedAddress!);
    ReviewModel reviewModel = ReviewModel(
      address: convertedAddress,
      lat: widget.reviewData.lat!,
      lng: widget.reviewData.lng!,
      residenceType: widget.reviewData.typeValue!,
      residenceFloor: widget.reviewData.floorValue!,
      starRating: StarRating(
        traffic: widget.reviewData.ratings['교통']!.toDouble(),
        building: widget.reviewData.ratings['건물']!.toDouble(),
        inside: widget.reviewData.ratings['내부']!.toDouble(),
        infra: widget.reviewData.ratings['인프라']!.toDouble(),
        security: widget.reviewData.ratings['치안']!.toDouble(),
      ),
      pros: _recommendController.text,
      cons: _dislikeController.text,
      maintenanceCost: _maintenanceController.text,
      images: base64String,
      residenceYear: widget.reviewData.yearValue!,
    );

    try {
      final repository = ref.read(reviewRepositoryProvider);
      print(reviewModel);
      final resp = await repository.createOneReview(
          reviewModel: reviewModel
      );

      Navigator.push(
          context, MaterialPageRoute(builder: (_) => CreateConfirmed(reviewAddress: reviewModel.address,)));
    } catch (e) {
      print(reviewModel.toJson());
      print("Error submitting review: $e");
    }
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
                child: Text(
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
                        ? () async {
                      submitReview();
                    }
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
                  borderSide:
                  BorderSide(color: INPUT_BORDER_COLOR), // 테두리 색상을 유지
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: INPUT_BORDER_COLOR), // 포커스 받았을 때의 색상
                  borderRadius: BorderRadius.circular(8.0),
                ),
                hintText: '작성하신 리뷰는 사용자들을 위해 노출되며,\n'
                    '\n'
                    '무의미한 내용 및 문자반복, 다른 리뷰 붙여넣기 등 성의 없는 리뷰는 지양해주세요.',
                counterStyle:
                TextStyle(color: isRequired ? Colors.red : Colors.black),
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

/*
  이미지 업로드
 */

class ImageUpload extends StatefulWidget {
  @override
  State<ImageUpload> createState() => ImageUploadState();
}

final picker = ImagePicker();
XFile? pickedImage; // 카메라로 촬영한 이미지를 저장할 변수
List<XFile?> multiImage = []; // 갤러리에서 여러장의 사진을 선택해서 저장할 변수
List<XFile?> images = []; // 가져온 사진들을 보여주기 위한 변수

class ImageUploadState extends State<ImageUpload> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Text(
              '사진 첨부',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(
              width: 10,
            ),
            Text('최대 1장'),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Visibility(
          visible: images.length < 1,
          //하나만 업로드 가능
          child: Row(
            children: [
              //카메라로 촬영하기
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(1),
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: IconButton(
                  onPressed: () async {
                    pickedImage =
                    await picker.pickImage(source: ImageSource.camera);
                    //카메라로 촬영하지 않고 뒤로가기 버튼을 누를 경우, null값이 저장되므로 if문을 통해 null이 아닐 경우에만 images변수로 저장하도록 합니다
                    if (pickedImage != null) {
                      setState(
                            () {
                          images.add((pickedImage));
                        },
                      );
                    }
                  },
                  icon: Icon(
                    Icons.add_a_photo,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
              ),
              //갤러리에서 가져오기
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(1),
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: IconButton(
                  onPressed: () async {
                    multiImage = await picker.pickMultiImage();
                    setState(
                          () {
                        //갤러리에서 가지고 온 사진들은 리스트 변수에 저장되므로 addAll()을 사용해서 images와 multiImage 리스트를 합쳐줍니다.
                        images.addAll(multiImage);
                      },
                    );
                  },
                  icon: Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: GridView.builder(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            itemCount:
            images.length, //보여줄 item 개수. images 리스트 변수에 담겨있는 사진 수 만큼.
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, //1 개의 행에 보여줄 사진 개수
              childAspectRatio: 1 / 1, //사진 의 가로 세로의 비율
              mainAxisSpacing: 10, //수평 Padding
              crossAxisSpacing: 10, //수직 Padding
            ),
            itemBuilder: (BuildContext context, int index) {
              // 사진 오른 쪽 위 삭제 버튼을 표시하기 위해 Stack을 사용함
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        fit: BoxFit.cover, //사진을 크기를 상자 크기에 맞게 조절
                        image: FileImage(
                          File(images[index]!
                              .path // images 리스트 변수 안에 있는 사진들을 순서대로 표시함
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    //삭제 버튼
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      icon: Icon(Icons.close, color: Colors.white, size: 15),
                      onPressed: () {
                        //버튼을 누르면 해당 이미지가 삭제됨
                        setState(
                              () {
                            images.remove(images[index]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
