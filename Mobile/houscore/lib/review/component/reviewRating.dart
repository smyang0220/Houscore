import 'package:flutter/material.dart';

final List<String> categories = ['교통', '건물', '내부', '인프라', '치안'];

class RatingsPage extends StatelessWidget {
  final Function(String, int) onRatingUpdated;

  RatingsPage({required this.onRatingUpdated});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: categories.map((category) => ListTile(
        title: Text(category),
        trailing: RatingWidget(
          onRatingChanged: (rating) => onRatingUpdated(category, rating),
        ),
      )).toList(),
    );
  }
}

class RatingWidget extends StatefulWidget {
  final Function(int) onRatingChanged;

  RatingWidget({required this.onRatingChanged});

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  int _currentRating = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) => IconButton(
          icon: Icon(
            index < _currentRating ? Icons.star : Icons.star_border,
            color: index < _currentRating ? Colors.amber : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _currentRating = index + 1;
            });
            widget.onRatingChanged(_currentRating);
          },
          iconSize: 35,
        )),
        SizedBox(width: 5),
        Text('$_currentRating / 5', style: TextStyle(fontSize: 20))
      ],
    );
  }
}
