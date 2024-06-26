import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/common/const/color.dart';
import 'package:houscore/common/layout/default_layout.dart';
import 'package:houscore/review/view/create_confirmed.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../residence/model/location_model.dart';
import '../../residence/repository/naver_map_repository.dart';
import '../model/review_model.dart';
import '../repository/review_repository.dart';
import 'create_review.dart';

class CreateReviewDetail extends ConsumerStatefulWidget {
  final ReviewData reviewData;
  //이전 페이지에서 받아온 데이터

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

    // ReviewModel reviewModel = ReviewModel(
    //   address: widget.reviewData.selectedAddress!,
    //   lat: widget.reviewData.lat!,
    //   lng: widget.reviewData.lng!,
    //   residenceType: widget.reviewData.typeValue!,
    //   residenceFloor: widget.reviewData.floorValue!,
    //   starRating: StarRating(
    //     traffic: widget.reviewData.ratings['교통']!.toDouble(),
    //     building: widget.reviewData.ratings['건물']!.toDouble(),
    //     inside: widget.reviewData.ratings['내부']!.toDouble(),
    //     infra: widget.reviewData.ratings['인프라']!.toDouble(),
    //     security: widget.reviewData.ratings['치안']!.toDouble(),
    //   ),
    //   pros: _recommendController.text,
    //   cons: _dislikeController.text,
    //   maintenanceCost: _maintenanceController.text,
    //   images: base64String,
    //   residenceYear: widget.reviewData.yearValue!,
    // );

    ReviewModel reviewModel = ReviewModel(
      address: '서울 강남구 개포동 12',
      lat: 37.4935,
      lng: 127.0654,
      residenceType: '아파트',
      residenceFloor: '1층',
      starRating: StarRating(
        traffic: 1.0,
        building: 2.0,
        inside: 3.0,
        infra: 4.0,
        security: 5.0,
      ),
      pros: '넘 깨끗해요',
      cons: '부엌이 좁아요',
      maintenanceCost: '한 달에 10만원',
    images: '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',
    residenceYear: '2024년',
    );

    try {
    final repository = ref.read(ReviewRepositoryProvider);
    await repository.createOneReview(
          imageName: '11',
          //TODO addressModel.Engjibun으로 변경
          reviewModel: reviewModel);
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => CreateConfirmed()));
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
            Text('최대 10장'),
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
