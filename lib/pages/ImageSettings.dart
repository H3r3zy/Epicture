import 'package:epicture_flutter/globals.dart' as globals;
import 'package:epicture_flutter/imgur.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ImageSettingsState extends State<ImageSettings> {
	var image;
	var _modal = false;

	ImageSettingsState(this.image);

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Color.fromRGBO(35, 35, 35, 1.0),
			appBar: new AppBar(
				title: Text("Settings: " + image["title"] ?? "Unknown"),
			),
			body: ModalProgressHUD(
				child: new ListView(
					padding: new EdgeInsets.all(10.0),
					children: <Widget>[
						Column(
							children: <Widget>[
								new SizedBox(
									width: double.infinity,
									// height: double.infinity,
									child: new RaisedButton(
										padding: const EdgeInsets.all(8.0),
										textColor: Colors.white,
										color: Colors.redAccent,
										onPressed: () async {
											var res = await Imgur.destroyImageOfUser(globals.username, this.image["id"]);
											if (res == true)
												Navigator.pop(context, "destroy");
										},
										child: new Text(
											"Delete this image",
											style: new TextStyle(
												fontSize: 25.0,
												color: Colors.white,
											),
										),
									),
								)

							],
						),
					],
				),
				inAsyncCall: _modal),
		);
	}
}

class ImageSettings extends StatefulWidget {
	final image;

	ImageSettings(this.image);

	@override
	ImageSettingsState createState() {
		return new ImageSettingsState(image);
	}
}
