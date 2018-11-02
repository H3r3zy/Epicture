import 'package:epicture_flutter/imgur.dart';
import 'package:epicture_flutter/pages/imagepage.dart';
import 'package:epicture_flutter/widgets/card/CardTags.dart';
import 'package:epicture_flutter/widgets/card/card.action.dart';
import 'package:epicture_flutter/widgets/card/card.header.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CardImgurState extends State<CardImgur> {
  var object;

  CardImgurState(this.object);

  @override
  Widget build(BuildContext context) {
    var uri = (object["is_album"] == false) ?
        object["link"] :
        object["images"][0]["link"];

    if (object["images"] != null && object["images"][0]["type"] == "video/mp4") {
      return new Container(color: Colors.white);
    }
    if (uri.toString().indexOf("mp4") != -1)
      return new Container(color: Colors.white);
    object["uri"] = uri;

    return Card(
      child: Column(
          children: [
            CardHeader(object: this.object),
            Container(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: GestureDetector(
                  child: Center(
                      child: new CachedNetworkImage(
                          imageUrl: uri,
                          placeholder: new SizedBox(width: 32.0, height: 32.0, child: new CircularProgressIndicator())
                      )
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => new ImagePage(this.object)
                    ));
                  },
                )
            ),
            CardTags(object: this.object),
            CardAction(object: this.object)
          ]
      ),
      color: Color.fromRGBO(35, 35, 35, 1.0),
    );
  }

  @override
  void initState() {
    super.initState();
    Imgur.getAvatarAccount(object["account_url"]).then((res) {
      if (!this.mounted)
        return;
      setState(() {
        this.object["avatar"] = res["avatar"];
      });
    });
  }
}

class CardImgur extends StatefulWidget {
  final object;

  CardImgur(this.object);

  @override
  CardImgurState createState() {
    return new CardImgurState(this.object);
  }
}