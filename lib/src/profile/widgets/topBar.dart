import 'package:flutter/material.dart';
import 'package:get/get.dart';


class topBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(

      child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                IconButton(
                  onPressed: () {
                      Get.bottomSheet(
                            Container(
                              height: 100,
                              color: Colors.white,
                              child: Column(children: [
                                TextButton(
                                  onPressed: () {},
                                  child: Text('Block'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.defaultDialog(
                                      title: 'Report User',
                                      titleStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                      content: Column(
                                        children: [
                                          TextButton(
                                            onPressed: () {},
                                            child: Text('Inappropriate Posts'),
                                          ),
                                          TextButton(
                                            onPressed: () {},
                                            child: Text('Abusive behaviour'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Text('Report'),
                                ),
                              ]),
                            ),
                          );
                  },
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),
      
    );
  }
}