import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Review Cards UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ReviewListScreen(),
    );
  }
}

class ReviewListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내가 쓴 리뷰'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          ReviewCard(
            title: '무지개 빌',
            address: '서울 강서구 공항동 36-40',
            rating: 4.0,
            aiScore: 2.8,
            imageAsset: 'asset/img/building/building1.jpg',
            reviewSummary: '사람이 별로 없어서 조용합니다. 배달음식을 위한 오트바이도 없어요.',
          ),
          ReviewCard(
            title: '삼성화재 유성역소방',
            address: '대전 유성구 동서대로 8-39',
            rating: 4.5,
            aiScore: 3.1,
            imageAsset: 'asset/img/building/building2.jpg',
            reviewSummary: '역시 삼성은 삼성! 소문으로만 듣다가 입주했는데, 방 컨디션은 물론 제공되는 식사도 대박 맛있어요!',
          ),
        ],
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String title;
  final String address;
  final double rating;
  final double aiScore;
  final String imageAsset;
  final String reviewSummary;

  const ReviewCard({
    Key? key,
    required this.title,
    required this.address,
    required this.rating,
    required this.aiScore,
    required this.imageAsset,
    required this.reviewSummary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: Text(title),
              subtitle: Text(address),
              trailing: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      Text('$rating'),
                      SizedBox(width: 4),
                      Text('AI $aiScore'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(imageAsset, width: 100, height: 100, fit: BoxFit.cover),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    reviewSummary,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            ButtonBar(
              alignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                  },
                  child: Text('수정'),
                ),
                TextButton(
                  onPressed: () {
                  },
                  child: Text('삭제'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
