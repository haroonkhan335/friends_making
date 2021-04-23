import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

class Chats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            child: Text('Call'),
            onPressed: () async {
              final HttpsCallableResult stringFromCF = await FirebaseFunctions
                  .instance
                  .httpsCallable('helloWorldAnother')
                  .call();

              log('STRING FROM CF = ${stringFromCF.data}');
            }),
      ),
    );
  }
}



/// Followers: ['alsdjfklsj', 'skalfjklsdf'];
/// 
/// 
/// firebase.database.ref('skldjfsl').delete({followers: ['alskdjla', asd;kfaj, alksdfjsl]})