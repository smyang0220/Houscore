import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/review/repository/review_repository.dart';
import '../model/review_model.dart';

class RecentReviewButton extends ConsumerStatefulWidget {
  const RecentReviewButton({super.key});

  @override
  ConsumerState<RecentReviewButton> createState() => _RecentReviewButtonState();
}

class _RecentReviewButtonState extends ConsumerState<RecentReviewButton> {
  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    return Column(
      children: [
        InkWell(
          onTap: () async {
            ReviewModel response;
            final repository = ref.watch(ReviewRepositoryProvider);
            response = await repository.recentReviews();
            // print('********* ReviewDetailButton clicked ************');
            // print(response.address);
          },
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              side: BorderSide(
                color: Colors.black,
                width: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: Text('건물정보'),
          ),
        ),
      ],
    );
  }
}
