import 'package:epicture_flutter/globals.dart' as globals;
import 'package:epicture_flutter/imgur.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class DataShareToCommunity {
	String title;
	String topic;
	String tags;

	DataShareToCommunity(this.title, this.topic, this.tags);
}

class ShareToCommunityState extends State<ShareToCommunity> {
	final _formKey = GlobalKey<FormState>();
	bool error = false;
	String errorMsg = "An error occured";
	var image;
	var _modal = false;
	var _data = DataShareToCommunity("", "", "");

	ShareToCommunityState(this.image);

	void submit() async {
		if (this._formKey.currentState.validate()) {
			_formKey.currentState.save(); // Save our form now.
			_modal = true;
			var res;

			if (image["is_album"] == null || image["is_album"] != true)
				res = await Imgur.shareImageWithTheCommunity(image["id"], _data.title, _data.topic, _data.tags);
			else
				res = await Imgur.shareAlbumWithTheCommunity(image["id"], _data.title, _data.topic, _data.tags);
			print(res);
			if (res != null && res == true)
				Navigator.pop(context, "leave");
			else if (res != null && res["error"] != null) {
				error = true;
				errorMsg = res["error"];
			}
			_modal = false;
			setState(() {});
		}
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Color.fromRGBO(35, 35, 35, 1.0),
			appBar: new AppBar(
				title: Text("Share: " + (image["title"] ?? "Unknown")),
			),
			body: ModalProgressHUD(
				child: Container(
					padding: new EdgeInsets.all(20.0),
					child: Form(
						key: _formKey,
						child: new ListView(
							padding: new EdgeInsets.all(10.0),
							children: <Widget>[
								Container(
									padding: const EdgeInsets.only(top: 10),
									child: TextFormField(
										decoration: InputDecoration(
											hintText: 'Enter your image\'s title',
											fillColor: Colors.white,
											filled: true,
											border: OutlineInputBorder(
												borderRadius: BorderRadius.circular(5.0),
											),
										),
										validator: (value) {
											if (value.isEmpty) {
												return 'Enter a title to your image';
											}
										},
										onSaved: (String value) {
											this._data.title = value;
										}
									),
								),
								Container(
									padding: const EdgeInsets.only(top: 10),
									child: TextFormField(
										decoration: InputDecoration(
											hintText: 'Enter your image\'s topic',
											fillColor: Colors.white,
											filled: true,
											border: OutlineInputBorder(
												borderRadius: BorderRadius.circular(5.0),
											),
										),
										validator: (value) {},
										onSaved: (String value) {
											this._data.topic = value;
										}
									),
								),
								Container(
									padding: const EdgeInsets.only(top: 10),
									child: TextFormField(
										decoration: InputDecoration(
											hintText: 'Enter your image\'s tags (Ex: "Funny,amazing,test")',
											fillColor: Colors.white,
											filled: true,
											border: OutlineInputBorder(
												borderRadius: BorderRadius.circular(5.0),
											),
										),
										validator: (value) {},
										onSaved: (String value) {
											this._data.tags = value;
										}
									),
								),
								Container(
									padding: const EdgeInsets.only(top: 10),
									child: new RaisedButton(
										padding: const EdgeInsets.all(8.0),
										textColor: Colors.black,
										color: Colors.lightBlueAccent,
										onPressed: () {
											this.submit();
										},
										child: new Text(
											"Post IT",
											style: new TextStyle(
												fontSize: 15.0,
												color: Colors.black,
											),
										),
									),
								),
								Container(
									padding: const EdgeInsets.only(top: 20),
									child: Text(
										(error == true) ? errorMsg : "",
										style: new TextStyle(
											fontSize: 18.0,
											color: Colors.red,
										),
									)
								)
							],
						),
					),
				),
				inAsyncCall: _modal),
		);
	}
}

class ShareToCommunity extends StatefulWidget {
	final image;

	ShareToCommunity(this.image);

	@override
	ShareToCommunityState createState() {
		return new ShareToCommunityState(image);
	}
}
