import 'package:cached_network_image/cached_network_image.dart';
import 'package:epicture_flutter/pages/tag.page.dart';
import 'package:flutter/material.dart';

// Created by sahel the 01/11/18 at 16:48

class CardTag extends StatelessWidget {
  final object;

  CardTag({Key key, this.object}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Color.fromRGBO(this.object["color"].r, this.object["color"].g, this.object["color"].b, 1.0),
            borderRadius: BorderRadius.circular(12.0),
            /// It may lag the listView
            /*image: new DecorationImage(
              fit: BoxFit.fill,
              image: CachedNetworkImageProvider(this.object["background"])
            ),*/
          ),
          child:  Center(
              child: Row(
                  children: [
                    Text(
                        this.object["display_name"],
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0,
                            shadows: [
                              Shadow(
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 1.0,
                                  color: Colors.black87
                              ),
                            ]
                        )
                    ),
                  ]
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