import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Review Card'),
        ),
        body: ReviewCard(),
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '상상화재 유성역소방',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber),
                        SizedBox(width: 4),
                        Text('4.5', style: TextStyle(fontSize: 18)),
                        SizedBox(width: 4),
                        Text('AI 3.1', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage('your_image_url_here'),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('추천해요', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('예시 상황은 상상! 상상으로만 돌...'),
                      SizedBox(height: 4),
                      Text('블레이요', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('사람이 별로 없어서 조용합니다.'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton (
                  onPressed: () {
                    // Implement what happens when you press the button
                  },
                  child: Text('상점'),
                ),
                TextButton (
                  onPressed: () {
                    // Implement what happens when you press the button
                  },
                  child: Text('상제'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
