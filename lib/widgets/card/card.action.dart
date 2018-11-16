import 'package:epicture_flutter/imgur.dart';
import 'package:flutter/material.dart';
import 'package:epicture_flutter/functions/mustBeConnected.dart';
import 'package:share/share.dart';

class CardActionState extends State<CardAction> {
	final object;
	bool sendVote = false;
	bool sendFav = false;

	CardActionState(this.object);

	setVote(vote) async {
		if (sendVote)
			return;
		sendVote = true;
		var lastVote = object["vote"];
		if (lastVote != null && lastVote == vote)
			vote = "veto";

		var code = await Imgur.vote(object["id"], vote);

		if (code != 200) {
			showDialog(context: context, builder: (context) {
				return AlertDialog(
					content: Text("An error occurred", style: TextStyle(color: Colors.black))
				);
			});
			sendVote = false;
			return;
		}
		setState(() {
			if (lastVote != null) {
				object[lastVote + "s"]--;
			}
			if (vote == "up")
				object["ups"]++;
			if (vote == "down")
				object["downs"]++;
			object["vote"] = (vote == "veto") ? null : vote;
		});
		sendVote = false;
	}

	@override
	Widget build(BuildContext context) {
		return Table(
			children: [
				TableRow(
					children: [
						Row(
							children: [
								FlatButton.icon(
									onPressed: () {
										mustBeConnected(context, () async {
											setVote("up");
										});
									},
									icon: Icon(Icons.arrow_upward, size: 18.0),
									label: Text((object["ups"] == null) ? "0" : object["ups"].toString(), style: TextStyle(fontSize: 11.0)),
									textColor: (object["vote"] != null && object["vote"] == "up") ? Colors.green : Colors.white,
									color: Colors.transparent
								),
							]
						),
						Row(
							children: [
								FlatButton.icon(
									onPressed: () {
										mustBeConnected(context, () {
											setVote("down");
										});
									},
									icon: Icon(Icons.arrow_downward, size: 18.0),
									label: Text((object["downs"] == null) ? "0" : object["downs"].toString(), style: TextStyle(fontSize: 11.0)),
									textColor: (object["vote"] != null && object["vote"] == "down") ? Colors.red : Colors.white,
									color: Colors.transparent
								)
							],
						),
						Row(
							children: [
								FlatButton.icon(
									onPressed: () {
										mustBeConnected(context, () async {
											if (sendFav)
												return;
											sendFav = true;
											var res = await (object["is_album"] ?
											Imgur.albumFav(object["id"]) :
											Imgur.imageFav(object["id"]));

											setState(() {
												if (res == "favorited") {
													object["favorite"] = true;
													object["favorite_count"]++;
												} else if (res == "unfavorited") {
													object["favorite"] = false;
													object["favorite_count"]--;
												}
											});
											sendFav = false;
										});
									},
									icon: Icon((object["favorite"] != null && object["favorite"] == true) ? Icons.favorite : Icons.favorite_border, size: 18.0,),
									label: Text(object["favorite_count"].toString(), style: TextStyle(fontSize: 11.0)),
									color: Colors.transparent,
									textColor: (object["favorite"] != null && object["favorite"] == true) ? Colors.red : Colors.white,
								)
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

