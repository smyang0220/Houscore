import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/review/repository/review_repository.dart';

import '../model/review_model.dart';

class ReviewDetailButton extends ConsumerStatefulWidget {
  const ReviewDetailButton({super.key});

  @override
  ConsumerState<ReviewDetailButton> createState() => _ReviewDetailButtonState();
}

class _ReviewDetailButtonState extends ConsumerState<ReviewDetailButton> {
  @override
  Widget build(BuildContext context) {

    final dio = Dio();

    print('ReviewDetailButton');
    return Column(
      children: [
        InkWell(
          onTap: () async {
            ReviewModel response;
            final repository = ref.watch(ReviewRepositoryProvider);
            response = await repository.reviewDetail(id: 1);
          },
          child: Card(
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            elevation: 2,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(7),
              ), // BoxDecoration
              child:
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('리뷰 조회 테스트')
              ]), // Row
            ), //
          ),
        ),
      ],
    );
  }
}

