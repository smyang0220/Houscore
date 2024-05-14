import 'package:flutter/material.dart';
import 'package:houscore/common/const/color.dart';

final List<String> categories = ['교통', '건물', '내부', '인프라', '치안'];
final Map<String, int> ratings = {
  '교통': 3,
  '건물': 4,
  '내부': 5,
  '인프라': 2,
  '치안': 3,
};

class ReviewRating extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: categories.map((category) => ListTile(
        title: Container(
          child: Center(
            child: Text(category, textAlign: TextAlign.center),
          ),
        ),
        trailing: StaticRatingWidget(
          rating: ratings[category] ?? 0,
        ),
      )).toList(),
    );
  }
}

class StaticRatingWidget extends StatelessWidget {
  final int rating;

  StaticRatingWidget({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) => Icon(
          index < rating ? Icons.star_rounded : Icons.star_rounded,
          color: index < rating ? Colors.amber : INPUT_BORDER_COLOR,
          size: 20,
        )),
        SizedBox(width: 3),
        Text('($rating)', style: TextStyle(fontSize: 16))
      ],
    );
  }
}
