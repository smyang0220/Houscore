import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/common/layout/default_layout.dart';
import 'package:houscore/common/utils/data_utils.dart';
import 'package:houscore/review/view/delete_confirmed.dart';
import 'package:blurry/blurry.dart';
import 'package:houscore/review/view/update_review.dart';
import '../model/my_review_model.dart';
import '../model/review_to_update_model.dart';
import '../repository/review_repository.dart';

class MyReviewList extends ConsumerStatefulWidget {
  const MyReviewList({Key? key}) : super(key: key);

  @override
  ConsumerState<MyReviewList> createState() => _MyReviewListState();
}

class _MyReviewListState extends ConsumerState<MyReviewList> {
  final List<MyReviewModel> reviewsToShow = [];

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  void _fetchReviews() async {
    final repository = ref.read(reviewRepositoryProvider);
    List<MyReviewModel> data = await repository.readMyReviews();
    updateList(data);
  }

  void updateList(List<MyReviewModel> newReviews) {
    setState(() {
      reviewsToShow.clear();
      reviewsToShow.addAll(newReviews);
    });
  }

  void deleteReview(int id) async {
    final repository = ref.read(reviewRepositoryProvider);
    await repository.deleteReview(id: id);
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DeleteConfirmed()),
    );
    _fetchReviews();
  }

  void updateReview(ReviewToUpdateModel review) async {
    print(review.toJson());

    ReviewToUpdateModel reviewToUpdate = ReviewToUpdateModel(
      id: review.id,
      address: review.address,
      residenceType: review.residenceType,
      residenceFloor: review.residenceFloor,
      starRating: review.starRating,
      pros: review.pros,
      cons: review.cons,
      maintenanceCost: review.maintenanceCost,
      images: review.images,
      residenceYear: review.residenceYear,
      imageChange: 'n',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateReview(reviewToUpdate: reviewToUpdate),
      ),
    );

    _fetchReviews();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        '내가 쓴 리뷰',
                        style: TextStyle(
                          fontFamily: 'NotoSans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (reviewsToShow.isEmpty)
                Container(
                    child: Text(
                  '아직 작성된 리뷰가 없어요.',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ))
              else
                ...reviewsToShow
                    .map(
                      (review) => MyReviewCard(
                        review: review,
                        deleteReview: deleteReview,
                        updateReview: updateReview,
                      ),
                    )
                    .toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class MyReviewCard extends StatelessWidget {
  final MyReviewModel review;
  final Function(int) deleteReview;
  final Function(ReviewToUpdateModel) updateReview;

  const MyReviewCard({
    Key? key,
    required this.review,
    required this.deleteReview,
    required this.updateReview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    review.address,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 10),
                _buildRatingSection(review.starRatingAverage),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                review.images != null && review.images!.isNotEmpty
                    ? Image.network(
                  review.images!,
                  width: MediaQuery.of(context).size.width * 0.2,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'asset/img/logo/main_logo.png',
                      width: MediaQuery.of(context).size.width * 0.2,
                    );
                  },
                )
                    : Image.asset(
                        'asset/img/logo/main_logo.png',
                        width: MediaQuery.of(context).size.width * 0.2,
                      ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '추천해요 : ',
                              style:
                                  TextStyle(fontSize: 13, color: Colors.blue),
                            ),
                            TextSpan(
                              text: review.pros,
                              style:
                                  TextStyle(fontSize: 13, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '별로예요 : ',
                              style: TextStyle(fontSize: 13, color: Colors.red),
                            ),
                            TextSpan(
                              text: review.cons,
                              style:
                                  TextStyle(fontSize: 13, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Divider(),
            Row(
              children: [
                Container(
                  child: Expanded(
                    flex: 1,
                    child: TextButton(
                      onPressed: () {
                        ReviewToUpdateModel reviewToUpdate =
                            ReviewToUpdateModel(
                                id: review.id,
                                address: review.address,
                                residenceType: DataUtils.typeDescription(review.residenceType),
                                residenceFloor: DataUtils.floorDescription(review.residenceFloor),
                                starRating: review.starRating,
                                pros: review.pros,
                                cons: review.cons,
                                maintenanceCost: review.maintenanceCost,
                                images: review.images,
                                residenceYear: review.year,
                                imageChange: 'n',
                            );
                        print('리뷰 이미지');
                        print(review.images);
                        updateReview(reviewToUpdate);
                      },
                      child: Text('수정'),
                    ),
                  ),
                ),
                Container(
                  child: Expanded(
                    flex: 1,
                    child: TextButton(
                      onPressed: () {
                        Blurry.info(
                          title: review.address.length > 20 ? '${review.address.substring(0, 14)}...' : review.address,
                          cancelButtonText: '취소',
                          description: '리뷰를 삭제하시겠습니까?',
                          confirmButtonText: '삭제',
                          onConfirmButtonPressed: () {
                            deleteReview(review.id);
                          },
                        ).show(context);
                      },
                      child: Text('삭제'),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection(double userRating) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15,
        ),
        Text(
          userRating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 4),
      ],
    );
  }
}
