import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:confirmation_success/confirmation_success.dart';
import 'package:houscore/common/view/root_tab.dart';
import 'package:houscore/review/view/my_review_list.dart';

class DeleteConfirmed extends StatefulWidget {
  @override
  State<DeleteConfirmed> createState() => _DeleteConfirmedState();
}

class _DeleteConfirmedState extends State<DeleteConfirmed> {
  StreamSubscription<void>? _sub;
  bool isSuccess = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _navigateAfter() async {
    if (mounted) {
      await Future.delayed(const Duration(seconds: 15), navigateToHome);
    }
  }

  Future<bool> navigateToHome() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConfirmationSuccess(
                    reactColor: Colors.red,
                    bubbleColors: [Colors.red],
                    numofBubbles: 35,
                    maxBubbleRadius: 8,
                    child: const Icon(
                      Icons.check,
                      size: 180,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(height: 40),
                          Text(
                            "리뷰 삭제가 성공적으로 완료되었습니다!\n",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => RootTab()),
                      );
                    },
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
                    child: Text('홈'),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      side: BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: Text('확인'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
