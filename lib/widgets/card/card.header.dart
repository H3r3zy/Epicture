import 'package:cached_network_image/cached_network_image.dart';
import 'package:epicture_flutter/widgets/Avatar.dart';
import 'package:flutter/material.dart';

class CardHeaderState extends State<CardHeader> {
  var object;

  CardHeaderState(this.object);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Avatar(username: object["account_url"]),
      title: Container(
        alignment: Alignment.centerLeft,
        child: Text(this.object["title"], style: TextStyle(color: Colors.white)),
      ),
      subtitle:
      Text(this.object["account_url"], style: TextStyle(color: Color.fromRGBO(130, 130, 130, 1.0))),
    );
  }
}

class CardHeader extends StatefulWidget {
  final object;

  CardHeader({Key key, this.object});

  @override
  CardHeaderState createState() => new CardHeaderState(object);
}