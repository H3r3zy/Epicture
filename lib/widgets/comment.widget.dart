import 'package:cached_network_image/cached_network_image.dart';
import 'package:epicture_flutter/functions/mustBeConnected.dart';
import 'package:epicture_flutter/imgur.dart';
import 'package:epicture_flutter/widgets/Avatar.dart';
import 'package:epicture_flutter/widgets/CommentForm.dart';
import 'package:flutter/material.dart';
import 'package:epicture_flutter/globals.dart' as globals;

class CommentState extends State<Comment> {
	var _comment;
	double marginLeft = 0.0;
	bool seeReply = false;
	int replyCount = 0;
	bool sendVote = false;
	bool edit = false; // TODO gestion du edit
	bool reply = false;

	CommentState(this._comment, this.marginLeft);

	setVote(vote) async {
		if (sendVote)
			return;
		sendVote = true;
		var lastVote = _comment["vote"];
		if (lastVote != null && lastVote == vote)
			vote = "veto";

		var code = await Imgur.commentVote(_comment["id"].toString(), vote);

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
				_comment[lastVote + "s"]--;
			}
			if (vote == "up")
				_comment["ups"]++;
			if (vote == "down")
				_comment["downs"]++;
			_comment["vote"] = (vote == "veto") ? null : vote;
		});
		sendVote = false;
	}

	@override
	Widget build(BuildContext context) {
		if (this._comment == null)
			return Container();
		return Column(
			children: [
				Container(
					margin: EdgeInsets.only(left: this.marginLeft),
					decoration: BoxDecoration(
						color: Color.fromRGBO(15, 15, 15, 0.5),
						border: Border(left: BorderSide(color: Colors.white), bottom: BorderSide(color: Color.fromRGBO(35, 35, 35, 1.0)))
					),
					child: GestureDetector(
						onTap: () {
							setState(() {
								seeReply = !seeReply;
							});
						},
						child: ListTile(
							leading: Avatar(username: _comment["author"], url: this._comment["avatar"]?.toString()),
							title: Column(
								mainAxisAlignment: MainAxisAlignment.start,
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Row(
										mainAxisAlignment: MainAxisAlignment.spaceBetween,
										children: [
											Text(_comment["author"], style: TextStyle(color: Color.fromRGBO(220, 220, 220, 1.0), fontSize: 10)),
											(replyCount != 0)
												? ((!seeReply)
												? Text(replyCount.toString() + ((replyCount == 1) ? " reply" : " replies"), style: TextStyle(color: Colors.white, fontSize: 10))
												: Text("x", style: TextStyle(color: Colors.white, fontSize: 10)))
												: null,
											(this._comment["author"] == globals.username) ?
											(FlatButton(child: Text("delete", style: TextStyle(color: Colors.redAccent, fontSize: 10)),
												onPressed: () async {
													await Imgur.delComment(commentId: this._comment["id"].toString());
													setState(() {
														this._comment["comment"] = "[DELETED]";
													});
												},)) :
											(null)
										].where((a) => a != null).toList()
									),
									Text(_comment["comment"], style: TextStyle(color: Color.fromRGBO(170, 170, 170, 1.0))),
									ButtonTheme.bar(
										minWidth: 0.0,
										child: ButtonBar(
											alignment: MainAxisAlignment.end,
											children: [
												FlatButton(
													padding: EdgeInsets.all(0.0),
													child: Text("reply", style: TextStyle(fontSize: 12)),
													textColor: Colors.white,
													onPressed: () {
														mustBeConnected(context, () {
															setState(() {
																reply = !reply;
															});
														});
													},
												),
												FlatButton.icon(
													padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
													icon: Icon(Icons.arrow_upward, size: 12),
													label: Text(_comment["ups"].toString(), style: TextStyle(fontSize: 12)),
													onPressed: () {
														mustBeConnected(context, () {
															setVote("up");
														});
													},
													textColor: _comment["vote"] != null && _comment["vote"] == "up" ? Colors.green : Colors.white,
												),
												FlatButton.icon(
													padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
													icon: Icon(Icons.arrow_downward, size: 12),
													label: Text(_comment["downs"].toString(), style: TextStyle(fontSize: 12)),
													onPressed: () {
														mustBeConnected(context, () {
															setVote("down");
														});
													},
													textColor: _comment["vote"] != null && _comment["vote"] == "down" ? Colors.red : Colors.white,
												),
											]
										),
									)

								]
							)
						)
					),
				)
			]
				..add(
					(reply) ?
					(CommentForm(
						marginLeft: this.marginLeft + 7.0,
						parentId: _comment["id"].toString(),
						imageId: _comment["image_id"],
						callback: (comment) {
							setState(() {
								reply = false;
								if (this._comment["children"] == null) {
									this._comment["children"] = [comment];
								} else {
									this._comment["children"].insert(0, comment);
								}
								replyCount++;
								seeReply = true;
							});
						}
					)) :
					(Container())
				)
				..addAll(
					List.generate((seeReply) ? replyCount : 0, (index) {
						return Comment(comment: this._comment["children"][index], marginLeft: this.marginLeft + 7.0);
					})
				)
		);
	}

	@override
	void initState() {
		super.initState();
		if (this._comment == null)
			return;
		if (this._comment["avatar"] == null) {
			Imgur.getAvatarAccount(this._comment["author"] ?? this._comment["account_url"]).then((res) {
				if (!this.mounted)
					return;
				setState(() {
					this._comment["avatar"] = res["avatar"];
				});
			});
		}

		this.replyCount = (_comment["children"] != null && _comment["children"].length != 0)
			? _comment["children"].length : 0;
	}
}

class Comment extends StatefulWidget {
	final comment;
	final marginLeft;

	Comment({Key key, this.comment, this.marginLeft = 0.0});

	@override
	CommentState createState() => new CommentState(this.comment, this.marginLeft);
}