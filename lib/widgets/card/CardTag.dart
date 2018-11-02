import 'package:epicture_flutter/pages/tag.page.dart';
import 'package:flutter/material.dart';

// Created by sahel the 01/11/18 at 16:48

class CardTagState extends State<CardTag> {
  final object;

  CardTagState(this.object);

  // TODO chips
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child:Container(
          margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
          padding: EdgeInsets.all(5.0),
          decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: new DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(this.object["background"])
              ),
              color: Color.fromRGBO(this.object["color"].r, this.object["color"].g, this.object["color"].b, 1.0)
          ),
          child:  Center(
              child: new Text(
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
    );;
  }
}

class CardTag extends StatefulWidget {
  final object;

  CardTag({Key key, this.object}) : super(key: key);

  @override
  CardTagState createState() => new CardTagState(this.object);
}