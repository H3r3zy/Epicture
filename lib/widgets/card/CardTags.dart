import 'package:epicture_flutter/pages/tag.page.dart';
import 'package:epicture_flutter/widgets/card/CardTag.dart';
import 'package:flutter/material.dart';
import 'package:color/color.dart' as AdvencedColor;

// Created by sahel the 01/11/18 at 13:42

class CardTagsState extends State<CardTags> {
  final object;

  CardTagsState(this.object);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
      height: this.object["tags"] == null || this.object["tags"].length == 0 ? 0.0 : 30.0,
      child: ListView.builder(
        itemCount: (this.object["tags"] != null ? this.object["tags"].length : 0),
        itemBuilder: (context, index) {
          var color = AdvencedColor.RgbColor(255, 255, 255);

          if (object["tags"][index]["accent"] != null)
            color = AdvencedColor.HexColor(object["tags"][index]["accent"]).toRgbColor();
          object["tags"][index]["background"] = "https://i.imgur.com/" + object["tags"][index]["background_hash"] + ".jpg";
          object["tags"][index]["color"] = color;

          return CardTag(object: this.object["tags"][index]);
        },
        scrollDirection: Axis.horizontal,
      )
    );
  }
}

class CardTags extends StatefulWidget {
  final object;

  CardTags({Key key, this.object}): super(key: key);

  @override
  CardTagsState createState() => new CardTagsState(this.object);
}