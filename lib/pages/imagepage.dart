import 'package:cached_network_image/cached_network_image.dart';
import 'package:epicture_flutter/functions/mustBeConnected.dart';
import 'package:epicture_flutter/imgur.dart';
import 'package:epicture_flutter/widgets/CommentForm.dart';
import 'package:epicture_flutter/widgets/card/CardTags.dart';
import 'package:epicture_flutter/widgets/card/card.action.dart';
import 'package:epicture_flutter/widgets/comment.widget.dart';
import 'package:flutter/material.dart';

class ImagePageState extends State<ImagePage> {
  final image;
  var _comments;
  bool comment = false;

  ImagePageState(this.image);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 35, 35, 1.0),
      appBar: new AppBar(
        title: Text(image["title"])
      ),
      body: SingleChildScrollView(
        child:  Column(
            children: [
              Center(
                  child: CachedNetworkImage(
                      imageUrl: image["uri"],
                      placeholder: new CircularProgressIndicator()
                  )
              ),
              CardAction(object: this.image),
              CardTags(object: this.image),
              Divider(color: Colors.white),
              Center(
                child: FlatButton(
                  child: Text("Add Comment", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    mustBeConnected(context, () {
                      setState(() {
                        comment = true;
                      });
                    });
                  },
                )
              )
            ]..add((comment) ? (
            CommentForm(
              marginLeft: 0.0,
              imageId: image["id"],
              callback: (cmt) {
                setState(() {
                  this.comment = false;
                  if (_comments == null) {
                    this._comments = [cmt];
                  } else {
                    this._comments.insert(0, cmt);
                  }
                });
              },
            )
            ) : (Container()))
              ..addAll(
                List.generate((_comments != null) ? _comments.length : 0, (index) {
                  return Comment(comment: _comments[index]);
                })
            )
        ),
      )
    );
  }

  @override
  void initState() {
    super.initState();
    Imgur.getComments(image["id"]).then((res) {
      setState(() {
        _comments = res;
      });
    });
  }
}

class ImagePage extends StatefulWidget {
  final image;

  ImagePage(this.image);

  @override
  ImagePageState createState() {
    return new ImagePageState(image);
  }
}