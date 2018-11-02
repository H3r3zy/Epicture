import 'package:flutter/material.dart';
import 'package:epicture_flutter/functions/mustBeConnected.dart';
import 'package:share/share.dart';

class CardActionState extends State<CardAction> {
  final object;

  CardActionState(this.object);

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(
          children: [
            Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.all(0.0),
                    icon: Icon(Icons.arrow_upward),
                    color: Colors.white,
                    iconSize: 18.0,
                    onPressed: () {mustBeConnected(context);},
                  ),
                  Text(object["ups"].toString(), style: TextStyle(color: Colors.white, fontSize: 11.0)),
                ]
            ),
            Row(
              children: [
                IconButton(
                  padding: EdgeInsets.all(0.0),
                  icon: Icon(Icons.arrow_downward),
                  color: Colors.white,
                  iconSize: 18.0,
                  onPressed: () {mustBeConnected(context);},
                ),
                Text(object["downs"].toString(), style: TextStyle(color: Colors.white, fontSize: 11.0)),
              ],
            ),
            Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.all(0.0),
                    icon: (object["favorite"] != null  && object["favorite"] == true) ? Icon(Icons.favorite, color: Colors.redAccent) : Icon(Icons.favorite_border),
                    color: Colors.white,
                    iconSize: 18.0,
                    onPressed: () {mustBeConnected(context);},
                  ),
                  Text(object["favorite_count"].toString(), style: TextStyle(color: Colors.white, fontSize: 11.0)),
                ]
            ),
            Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.all(0.0),
                    icon: Icon(Icons.share),
                    color: Colors.white,
                    iconSize: 18.0,
                    onPressed: () {
                      Share.share("Look at this: '" + object["title"] + "' " + this.object["uri"]);
                    },
                  ),
                  Text("SHARE", style: TextStyle(color: Colors.white, fontSize: 11.0))
                ]
            )

          ],

        )
      ],

      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    );
  }
}

class CardAction extends StatefulWidget {
  final object;

  CardAction({Key key, this.object}) : super(key: key);

  @override
  CardActionState createState() => new CardActionState(object);
}

