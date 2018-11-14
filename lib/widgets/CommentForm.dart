import 'package:epicture_flutter/imgur.dart';
import 'package:epicture_flutter/widgets/Avatar.dart';
import 'package:flutter/material.dart';
import 'package:epicture_flutter/globals.dart' as globals;

// Created by sahel the 07/11/18 at 18:09

class CommentFormState extends State<CommentForm> {
  final double marginLeft;
  final String parentId;
  final String imageId;
  final Function(dynamic comment) callback;

  CommentFormState(this.marginLeft, this.imageId, this.callback, {this.parentId});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:EdgeInsets.only(left: this.marginLeft),
      decoration: BoxDecoration(
          color: Color.fromRGBO(15, 15, 15, 0.5),
          border: Border(left: BorderSide(color: Colors.white), bottom: BorderSide(color: Color.fromRGBO(35, 35, 35, 1.0)))
      ),
      child: ListTile(
          leading: Avatar(username: globals.username, url: (globals.me == null) ? null : (globals.me["avatar"])?.toString()),
          title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(globals.username, style: TextStyle(color: Color.fromRGBO(220, 220, 220, 1.0), fontSize: 10)),
                    ]
                ),
                TextField(
                  onSubmitted: (text) async {

                    var res = await Imgur.sendComment(imageId: this.imageId, commentId: this.parentId, comment: text);
                    if (res["error"] != null) {
                      return this.callback(null);
                    }
                    var comment = await Imgur.getComment(commentId: res["id"].toString());

                    this.callback(comment);
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Comment",
                    hintStyle: TextStyle(color: Color.fromRGBO(85, 85, 85, 1.0)),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white
                        )
                    ),
                  ),
                  cursorColor: Color.fromRGBO(180, 180, 180, 1.0),
                ),
              ]

          )
      ),
    );
  }
}

class CommentForm extends StatefulWidget {
  final Function(dynamic comment) callback;
  final double marginLeft;
  final String parentId;
  final String imageId;

  CommentForm({Key key, this.callback, this.marginLeft, this.parentId, this.imageId}) : super(key: key);

  @override
  CommentFormState createState() => new CommentFormState(this.marginLeft, this.imageId, this.callback, parentId: this.parentId);
}