

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:friends_making/src/auth/models/userModel.dart';
import 'package:friends_making/src/chats/groupChats/controllers/groupChatsController.dart';
import 'package:get/get.dart';

class FilterChipWidgett extends StatefulWidget {



  
  final Friend friendChip;

  FilterChipWidgett({Key key, this.friendChip}) : super(key: key);


  @override
  _FilterChipWidgettState createState() => _FilterChipWidgettState();
}

class _FilterChipWidgettState extends State<FilterChipWidgett> {

    final controller = Get.find<GroupChatsController>();
var _isSelected = false;

@override
  void initState() {
    controller.selectedFriendsChip.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      avatar: CachedNetworkImage(
      imageUrl: widget.friendChip.image,
      imageBuilder: (context, image) => CircleAvatar(
      backgroundImage: image,
      radius: 40,
      ),
       errorWidget: (context, errorMessage, data) => CircleAvatar(
      child: Icon(Icons.account_circle_outlined),
      ),
      ),
      label: Text(widget.friendChip.name), 
      labelStyle: TextStyle(color: Colors.blue, fontSize: 16.0, fontWeight: FontWeight.bold),
      selected: _isSelected,
      backgroundColor: Colors.white,
      onSelected: (isSelected){
        setState(() {
          _isSelected = isSelected;
          controller.selectedFriendsChip.clear();
         
          controller.selectedFriendsChip.contains(widget.friendChip)?
          controller.selectedFriendsChip.remove(widget.friendChip):
          controller.selectedFriendsChip.add(widget.friendChip);

          controller.update();
          log(controller.selectedFriendsChip.toString());
          
        });

      },
      selectedColor: Colors.amber,
      );
  }
}