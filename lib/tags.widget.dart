import 'package:flutter/material.dart';
import 'package:color/color.dart' as AdvencedColor;
import 'dart:ui';
import 'package:epicture_flutter/pages/tag.page.dart';


class TagsImgur {
  var object;

  TagsImgur(this.object);

  view(context) {
    var color = AdvencedColor.RgbColor(255, 255, 255);

    if (object["accent"] != null)
      color = AdvencedColor.HexColor(object["accent"]).toRgbColor();

    return GestureDetector(
        child: Card(
            child:Container(
                padding: EdgeInsets.all(5.0),
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(object["background"])
                    ),
                    color: Color.fromRGBO(color.r, color.g, color.b, 1.0)
                ),
                child:  Center(
                    child: new Text(
                        object["display_name"],
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                            shadows: [
                              Shadow(
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 1.0,
                                  color: Colors.black87
                              ),
                            ]
                        )
                    )
                )
            )
        ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new TagPage(this.object["name"])
            )
        );
      },
    );
  }
}