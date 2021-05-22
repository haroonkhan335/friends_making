import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:friends_making/src/home/controllers/feedController.dart';
import 'package:friends_making/src/home/widgets/allPosts.dart';
import 'package:get/get.dart';

class Feed extends StatelessWidget {
  final feedController = Get.put(FeedController());
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: GetBuilder<FeedController>(
      builder: (_) => Column(
        children: [
          Container(
            height: height * 0.3,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                )
              ],
            ),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  Text('Body'),
                  feedController.isEditing
                      ? TextFormField(
                          maxLines: 5,
                          controller: feedController.bodyPostController,
                          decoration: InputDecoration(border: OutlineInputBorder()),
                        )
                      : Container(
                          width: width,
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5,
                              )
                            ],
                          ),
                          child: RichText(text: TextSpan(text: '', children: feedController.body)),
                        ),
                  SizedBox(height: 15),
                  feedController.isEditing
                      ? ElevatedButton(
                          onPressed: () {
                            feedController.finishWritingPost();
                          },
                          child: Text('Finish'),
                        )
                      : Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                feedController.toggleEditing();
                              },
                              child: Text('Edit'),
                            ),
                            SizedBox(width: 25),
                            ElevatedButton(
                              onPressed: () {
                                feedController.post();
                              },
                              child: Text('Post'),
                            )
                          ],
                        )
                ],
              ),
            ),
          ),
          AllPosts(),
        ],
      ),
    ));
  }
}
