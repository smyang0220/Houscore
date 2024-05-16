import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/common/layout/default_layout.dart';
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
    print('Fetching reviews...');
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DeleteConfirmed()),
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
                    Text(
                      '내가 쓴 리뷰',
                      style: TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              if (reviewsToShow.isEmpty)
                Container(child: Text('아직 작성된 리뷰가 없어요.'))
              else
                ...reviewsToShow
                    .map(
                      (review) => MyReviewCard(
                    review: review,
                    deleteReview: deleteReview,
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

  const MyReviewCard({
    Key? key,
    required this.review,
    required this.deleteReview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(16.0),
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
                Container(
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
                )
                    : Image.asset(
                  'asset/img/logo/main_logo.png',
                  width: MediaQuery.of(context).size.width * 0.2,
                ),
                SizedBox(width: 15),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '추천해요 : ',
                              style: TextStyle(fontSize: 13, color: Colors.blue),
                            ),
                            TextSpan(
                              text: review.pros,
                              style: TextStyle(fontSize: 13, color: Colors.black),
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
                              style: TextStyle(fontSize: 13, color: Colors.black),
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
                          residenceYear: review.year,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateReview(reviewToUpdate: reviewToUpdate),
                          ),
                        );
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
                          title: review.address,
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
    return Row(
      children: [
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 20.0,
        ),
        Text(
          userRating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 4.0),
      ],
    );
  }
}
