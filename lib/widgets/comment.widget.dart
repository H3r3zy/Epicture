import 'package:cached_network_image/cached_network_image.dart';
import 'package:epicture_flutter/functions/mustBeConnected.dart';
import 'package:epicture_flutter/imgur.dart';
import 'package:epicture_flutter/widgets/Avatar.dart';
import 'package:flutter/material.dart';

class CommentState extends State<Comment> {
  var _comment;
  double marginLeft = 0.0;
  String _avatar;
  bool seeReply = false;
  int replyCount = 0;

  CommentState(this._comment, this.marginLeft);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Container(
            margin:EdgeInsets.only(left: this.marginLeft),
            decoration: BoxDecoration(
              color: Color.fromRGBO(15, 15, 15, 0.5),
              border: Border(left: BorderSide(color: Colors.white), bottom: BorderSide(color: Color.fromRGBO(35, 35, 35, 1.0)))
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  seeReply = !seeReply;
                });
              },
                child: ListTile(
                    leading: Avatar(username: _comment["author"]),
                    title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_comment["author"], style: TextStyle(color: Color.fromRGBO(220, 220, 220, 1.0), fontSize: 10)),
                                (replyCount != 0)
                                    ? ((!seeReply)
                                      ? Text(replyCount.toString() + ((replyCount == 1) ? " reply" : " replies"), style: TextStyle(color: Colors.white, fontSize: 10))
                                      : Text("x", style: TextStyle(color: Colors.white, fontSize: 10)))
                                    : Text("")
                              ]
                          ),
                          Text(_comment["comment"], style: TextStyle(color: Color.fromRGBO(170, 170, 170, 1.0))),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FlatButton.icon(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  icon: Icon(Icons.arrow_upward, color: Colors.white, size: 12),
                                  label: Text(_comment["ups"].toString(), style: TextStyle(color: Colors.white, fontSize: 12)),
                                  onPressed: () {
                                    //TODO
                                    mustBeConnected(context);
                                  },
                                ),
                                FlatButton.icon(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  icon: Icon(Icons.arrow_downward, color: Colors.white, size: 12),
                                  label: Text(_comment["downs"].toString(), style: TextStyle(color: Colors.white, fontSize: 12)),
                                  onPressed: () {
                                    //TODO
                                    mustBeConnected(context);
                                  },
                                ),
                              ]
                          ),
                        ]
                    )
                )
            ),
          )
        ]..addAll(
          List.generate((seeReply) ? replyCount : 0, (index) {
            return Comment(comment: this._comment["children"][index], marginLeft: this.marginLeft + 7.0);
          })
        )
    );
  }

  @override
  void initState() {
    super.initState();

    this.replyCount = (_comment["children"] != null && _comment["children"].length != 0)
        ? _comment["children"].length : 0;
  }
}

class Comment extends StatefulWidget {
  final comment;
  final marginLeft;
  Comment({Key key, this.comment, this.marginLeft = 0.0});

  @override
  CommentState createState() => new CommentState(this.comment, this.marginLeft);
}