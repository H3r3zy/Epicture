import 'package:epicture_flutter/globals.dart' as globals;
import 'package:epicture_flutter/imgur.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:epicture_flutter/pages/Share.dart';

class ImageSettingsState extends State<ImageSettings> {
	final _formKey = GlobalKey<FormState>();
	var image;
	var _modal = false;
	TextEditingController titleController = TextEditingController();
	TextEditingController descriptionController = TextEditingController();

	void submit() async {
		if (this._formKey.currentState.validate()) {
			_formKey.currentState.save(); // Save our form now.
			_modal = true;
			var res = await Imgur.updateImageParams(this.image["id"], image["title"], image["description"]);
			_modal = false;
			Navigator.pop(context);
			setState(() {});
		}
	}

	ImageSettingsState(this.image);

	@override
	void initState() {
		super.initState();

		titleController.text = this.image["title"];
		descriptionController.text = this.image["description"];
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Color.fromRGBO(35, 35, 35, 1.0),
			appBar: new AppBar(
				title: Text("Settings: " + (image["title"] ?? "Unknown")),
			),
			body: ModalProgressHUD(
				child: Form(
					key: _formKey,
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
												_modal = true;
												var res = await Imgur.destroyImageOfUser(globals.username, this.image["id"]);
												_modal = false;
												if (res == true)
													Navigator.pop(context, "destroy");
												setState(() {});
											},
											child: new Text(
												"Delete this image",
												style: new TextStyle(
													fontSize: 25.0,
													color: Colors.white,
												),
											),
										),
									),
									((image["in_gallery"] != null && image["in_gallery"] == false) ?
									new SizedBox(
										width: double.infinity,
										// height: double.infinity,
										child: new RaisedButton(
											padding: const EdgeInsets.all(8.0),
											textColor: Colors.black,
											color: Colors.white,
											onPressed: () async {
												var res = await Navigator.push(
													context,
													MaterialPageRoute(
														builder: (context) => new ShareToCommunity(this.image)
													)
												);
												if (res != null)
													Navigator.pop(context);
											},
											child: new Text(
												"Share with the community",
												style: new TextStyle(
													fontSize: 25.0,
													color: Colors.black,
												),
											),
										),
									) : new SizedBox(
										width: double.infinity,
										// height: double.infinity,
										child: new RaisedButton(
											padding: const EdgeInsets.all(8.0),
											textColor: Colors.black,
											color: Colors.white,
											onPressed: () async {
												_modal = true;
												var res = await Imgur.removeFromTheGallery(this.image["id"]);
												print(res);
												_modal = false;
												if (res == true)
													Navigator.pop(context, "destroy");
												setState(() {});
											},
											child: new Text(
												"Remove from the gallery",
												style: new TextStyle(
													fontSize: 25.0,
													color: Colors.black,
												),
											),
										),
									)),
									Container(
										margin: const EdgeInsets.only(top: 50),
										child: TextFormField(
											controller: titleController,
											decoration: InputDecoration(
												hintText: 'Enter your album\'s title',
												fillColor: Colors.white,
												filled: true,
												border: OutlineInputBorder(
													borderRadius: BorderRadius.circular(5.0),
												),

											),
											validator: (value) {
												if (value.isEmpty) {
													return 'Enter a title to your album';
												}
											},
											onSaved: (String value) {
												this.image["title"] = value;
											}
										),
									), Container(
										margin: const EdgeInsets.only(top
											: 10),
										child: TextFormField(
											controller:
											descriptionController,
											decoration: InputDecoration(
												hintText: 'Enter your album\'s descriptions',
												fillColor: Colors.white,
												filled:
												true,
												border: OutlineInputBorder(
													borderRadius: BorderRadius.
													circular(5.0),
												),
											),
											validator: (value) {},
											onSaved: (String value) {
												this.image["description"] = value;
											},
										),
									),
									Container
										(
										margin:
										const EdgeInsets.only (top: 10),
										child: RaisedButton(
											color: Colors.lightBlueAccent,
											onPressed: () {
												// Validate will return true if the form is valid, or false if
												// the form is invalid.
												this.submit();
											},
											child: Text("Update"),
										),
									),
								],
							),
						],
					),
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
