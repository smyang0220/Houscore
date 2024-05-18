import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/common/const/color.dart';
import 'package:houscore/common/layout/default_layout.dart';
import 'package:houscore/review/view/update_confirmed.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../model/review_to_update_model.dart';
import '../repository/review_repository.dart';

class UpdateReviewDetail extends ConsumerStatefulWidget {
  final ReviewToUpdateModel reviewToUpdate;

  UpdateReviewDetail({required this.reviewToUpdate});

  @override
  ConsumerState createState() => _UpdateReviewDetailState();
}

class _UpdateReviewDetailState extends ConsumerState<UpdateReviewDetail> {
  final TextEditingController _recommendController = TextEditingController();
  final TextEditingController _dislikeController = TextEditingController();
  final TextEditingController _maintenanceController = TextEditingController();

  bool _isRecommendRequired = true;
  bool _isDislikeRequired = true;
  bool _isMaintenanceRequired = true;
  bool _isButtonEnabled = false;

  String? image;
  String imageChange = ''; // 추가된 부분

  @override
  void initState() {
    super.initState();
    _recommendController.text = widget.reviewToUpdate.pros ?? '';
    _dislikeController.text = widget.reviewToUpdate.cons ?? '';
    _maintenanceController.text = widget.reviewToUpdate.maintenanceCost ?? '';
    image = widget.reviewToUpdate.images!;
    _updateButtonState();
  }

  void _updateButtonState() {
    setState(() {
      _isRecommendRequired = _recommendController.text.length < 100;
      _isDislikeRequired = _dislikeController.text.length < 100;
      _isMaintenanceRequired = _maintenanceController.text.length < 10;

      _isButtonEnabled = _recommendController.text.length >= 100 &&
          _dislikeController.text.length >= 100 &&
          _maintenanceController.text.length >= 10 &&
          image!.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _recommendController.dispose();
    _dislikeController.dispose();
    _maintenanceController.dispose();
    super.dispose();
  }

  void _updateImage(String? newImage) {
    setState(() {
      image = newImage;
    });
  }

  void _updateImageChange(String status) {
    setState(() {
      imageChange = status;
    });
  }

  void updateReview() async {
    String convertedImage = '';

    String base64String ='';
    if(imageChange == 'y') {

    List<int> imageBytes = await images[0]!.readAsBytes();
    String base64String = base64Encode(imageBytes);
    convertedImage = base64String;
    } else {
      widget.reviewToUpdate.images!;
    }

    ReviewToUpdateModel reviewModel = ReviewToUpdateModel(
      id: widget.reviewToUpdate.id,
      address: widget.reviewToUpdate.address,
      residenceType: widget.reviewToUpdate.residenceType,
      residenceFloor: widget.reviewToUpdate.residenceFloor,
      starRating: widget.reviewToUpdate.starRating,
      pros: _recommendController.text,
      cons: _dislikeController.text,
      maintenanceCost: _maintenanceController.text,
      images: convertedImage,
      residenceYear: widget.reviewToUpdate.residenceYear,
      imageChange: imageChange, // 추가된 부분
    );

    try {
      final repository = ref.read(reviewRepositoryProvider);
      await repository.updateReview(reviewModel: reviewModel);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UpdateConfirmed(
            reviewAddress: reviewModel.address,
          ),
        ),
      );
    } catch (e) {
      print("Error submitting review: $e");
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => UpdateConfirmed(
      //       reviewAddress: reviewModel.address,
      //     ),
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    '리뷰 수정하기 (2/2)',
                    style: TextStyle(
                      fontFamily: 'NotoSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                buildTextFieldSection(
                  _recommendController,
                  '추천해요!',
                  Colors.blue,
                  100,
                  _isRecommendRequired,
                ),
                SizedBox(height: 5),
                buildTextFieldSection(
                  _dislikeController,
                  '별로예요!',
                  Colors.red,
                  100,
                  _isDislikeRequired,
                ),
                SizedBox(height: 5),
                buildTextFieldSection(
                  _maintenanceController,
                  '관리비',
                  null,
                  10,
                  _isMaintenanceRequired,
                ),
                SizedBox(height: 5),
                ImageUpload(
                  onImageChanged: _updateImage,
                  onImageDeleted: _updateImageChange, // 추가된 부분
                  initialImage: image,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('이전으로'),
                    ),
                    ElevatedButton(
                      onPressed: _isButtonEnabled
                          ? () async {
                        updateReview();
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
                color: color ?? Colors.black,
              ),
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
              onChanged: (text) => _updateButtonState(), // 추가된 부분
              decoration: InputDecoration(
                filled: true,
                fillColor: INPUT_BORDER_COLOR,
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
  final Function onImageChanged;
  final Function(String) onImageDeleted; // 추가된 부분
  final String? initialImage;

  ImageUpload({required this.onImageChanged, required this.onImageDeleted, this.initialImage});

  @override
  State<ImageUpload> createState() => ImageUploadState();
}

final picker = ImagePicker();
XFile? pickedImage;
List<XFile?> multiImage = [];
List<XFile?> images = [];

class ImageUploadState extends State<ImageUpload> {
  @override
  void initState() {
    super.initState();
    images.clear();
    if (widget.initialImage != null) {
      images.add(XFile(widget.initialImage!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5),
        Row(
          children: [
            Text(
              '사진 첨부',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 10),
            Text('최대 1장'),
          ],
        ),
        SizedBox(height: 5),
        Visibility(
          visible: images.length < 1,
          child: Row(
            children: [
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
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () async {
                    pickedImage =
                    await picker.pickImage(source: ImageSource.camera);
                    if (pickedImage != null) {
                      setState(() {
                        images.add((pickedImage));
                      });
                      widget.onImageChanged();
                    }
                  },
                  icon: Icon(
                    Icons.add_a_photo,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
              ),
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
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () async {
                    multiImage = await picker.pickMultiImage();
                    setState(() {
                      images.addAll(multiImage);
                    });
                    widget.onImageChanged();
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
            itemCount: images.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1 / 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: images[0] == widget.initialImage!
                            ? FileImage(File(images[0]!.path)) as ImageProvider
                            : NetworkImage(widget.initialImage!),
                      ),
                    ),
                  ),
                  //이미지 삭제 버튼
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      icon: Icon(Icons.close, color: Colors.white, size: 15),
                      onPressed: () {
                        setState(() {
                          images.remove(images[index]);
                        });
                        widget.onImageChanged();
                        widget.onImageDeleted('y'); // 이미지 삭제 시 호출
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
