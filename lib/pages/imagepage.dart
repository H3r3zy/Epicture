import 'package:cached_network_image/cached_network_image.dart';
import 'package:epicture_flutter/functions/mustBeConnected.dart';
import 'package:epicture_flutter/imgur.dart';
import 'package:epicture_flutter/widgets/CommentForm.dart';
import 'package:epicture_flutter/widgets/card/CardTags.dart';
import 'package:epicture_flutter/widgets/card/card.action.dart';
import 'package:epicture_flutter/widgets/comment.widget.dart';
import 'package:flutter/material.dart';

class ImagePageState extends State<ImagePage>
    with SingleTickerProviderStateMixin {
  final image;
  var _comments;
  bool comment = false;
  TabController controller;
  List<Widget> carousel = [];
  double maxRatio = 0.0;

  ImagePageState(this.image);

  handleArrow(int delta) {
    if (!controller.indexIsChanging)
      controller
          .animateTo((controller.index + delta).clamp(0, carousel.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(35, 35, 35, 1.0),
        appBar: new AppBar(title: Text(image["title"])),
        body: SingleChildScrollView(
          child: Column(
              children: [
            (carousel.length != 1)
                ? Container(
                    margin: const EdgeInsets.only(top: 16.0),
                    child: Row(children: <Widget>[
                      IconButton(
                          icon: const Icon(Icons.chevron_left),
                          color: Colors.white,
                          onPressed: () {
                            handleArrow(-1);
                          },
                          tooltip: 'Previous image'),
                      TabPageSelector(controller: controller),
                      IconButton(
                          icon: const Icon(Icons.chevron_right),
                          color: Colors.white,
                          onPressed: () {
                            handleArrow(1);
                          },
                          tooltip: 'Next image')
                    ], mainAxisAlignment: MainAxisAlignment.spaceBetween))
                : null,
            AspectRatio(
                aspectRatio: this.maxRatio,
                child: TabBarView(
                  controller: controller,
                  children: carousel,
                )),
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
            ))
          ].where((a) => a != null).toList()
                ..add((comment)
                    ? (CommentForm(
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
                      ))
                    : (Container()))
                ..addAll(List.generate(
                    (_comments != null) ? _comments.length : 0, (index) {
                  return Comment(comment: _comments[index]);
                }))
          )
        ));
  }

  @override
  void initState() {
    super.initState();
    Imgur.getComments(image["id"]).then((res) {
      setState(() {
        _comments = res;
      });
    });

    if (this.image["is_album"] == true) {
      for (var img in this.image["images"]) {
        carousel.add(AspectRatio(
            aspectRatio: img["width"] / img["height"],
            child: CachedNetworkImage(
              imageUrl: img["link"],
              placeholder: Center(child: CircularProgressIndicator()),
            )));
        if (this.maxRatio < img["width"] / img["height"])
          this.maxRatio = img["width"] / img["height"];
      }
    } else {
      carousel.add(AspectRatio(
          aspectRatio: image["width"] / image["height"],
          child: CachedNetworkImage(
            imageUrl: image["link"],
            placeholder: Center(child: CircularProgressIndicator()),
          )));
      this.maxRatio = image["width"] / image["height"];
    }
    controller = new TabController(length: carousel.length, vsync: this);
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
