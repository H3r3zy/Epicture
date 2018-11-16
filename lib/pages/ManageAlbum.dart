import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:epicture_flutter/imgur.dart';
import 'package:epicture_flutter/globals.dart' as globals;

class albumData {
	bool done = false;
	String title;
	String privacy;
	String description;

	albumData(this.title, this.privacy, this.description);
}

class ManageAlbumPage extends StatefulWidget {
	String id;

	ManageAlbumPage(this.id);

	@override
	State<StatefulWidget> createState() {
		return ManageAlbumPageState(this.id);
	}
}

class ManageAlbumPageState extends State<ManageAlbumPage> {
	final _formKey = GlobalKey<FormState>();
	final String id;
	bool _modal = false;
	var data = new albumData("", "secret", "");

	TextEditingController titleController = TextEditingController();
	TextEditingController descriptionController = TextEditingController();

	ManageAlbumPageState(this.id);

	getData() async {
		_modal = true;
		var res = await Imgur.getAlbumData(this.id, globals.username);
		if (res["success"] != true) {
			_modal = false;
			return;
		}
		data.title = res["data"]["title"];
		data.description = res["data"]["description"];
		data.privacy = res["data"]["privacy"];
		titleController.text = data.title;
		descriptionController.text = data.description;
		_modal = false;
		setState(() {});
	}

	void submit() async {
		if (this._formKey.currentState.validate()) {
			_formKey.currentState.save(); // Save our form now.
			_modal = true;
			print(data);
			var res;
			if (this.id != "")
				res = await Imgur.updateAlbumParams(this.id, data.title, data.description, data.privacy);
			else
				res = await Imgur.createAlbum(data.title, data.description, data.privacy);
			_modal = false;
			Navigator.pop(context);
			setState(() {});
		}
	}

	@override
	void initState() {
		super.initState();

		titleController.text = data.title;
		descriptionController.text = data.description;
		if (this.id != null && data.done == false)
			getData();
		data.done = true;
	}

	@override
	Widget build(BuildContext context) {
		return new Scaffold(
			appBar: new AppBar(
				title: new Text('Albums'),
			),

			body: ModalProgressHUD(
				child: Form(
					key: _formKey,
					child: new ListView(
						padding: EdgeInsets.all(20.0),
						children: [
							(this.id == "") ? Container() :
							new SizedBox(
								width: double.infinity,
								// height: double.infinity,
								child: new RaisedButton(
									padding: const EdgeInsets.all(8.0),
									textColor: Colors.white,
									color: Colors.redAccent,
									onPressed: () async {
										_modal = true;
										await Imgur.deleteAlbum(this.id);
										_modal = false;
										Navigator.pop(context);
										setState(() {});
									},
									child: new Text(
										"Delete this album",
										style: new TextStyle(
											fontSize: 25.0,
											color: Colors.white,
										),
									),
								),
							),
							Container(
								margin: const EdgeInsets.only(top: 10),
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
										this.data.title = value;
									}
								),
							),
							Container(
								margin: const EdgeInsets.only(top: 10),
								child: TextFormField(
									controller: descriptionController,
									decoration: InputDecoration(
										hintText: 'Enter your album\'s descriptions',
										fillColor: Colors.white,
										filled: true,
										border: OutlineInputBorder(
											borderRadius: BorderRadius.circular(5.0),
										),
									),
									validator: (value) {},
									onSaved: (String value) {
										this.data.description = value;
									},
								),
							),
							Container(
								margin: const EdgeInsets.only(top: 10),
								child: Row(
									mainAxisAlignment: MainAxisAlignment.center,
									children: <Widget>[
										new Radio(
											onChanged: (String val) {
												setState(() => data.privacy = val);
											},
											activeColor: Theme
												.of(context)
												.accentColor,
											value: "secret",
											groupValue: data.privacy,
										),
										new Text(
											'Secret',
											style: new TextStyle(fontSize: 16.0),
										),
										new Radio(
											onChanged: (String val) {
												setState(() => data.privacy = val);
											},
											activeColor: Theme
												.of(context)
												.accentColor,
											value: "hidden",
											groupValue: data.privacy,
										),
										new Text(
											'Hidden',
											style: new TextStyle(fontSize: 16.0),
										),
										new Radio(
											onChanged: (String val) {
												setState(() => data.privacy = val);
											},
											activeColor: Theme
												.of(context)
												.accentColor,
											value: "public",
											groupValue: data.privacy,
										),
										new Text(
											'Public',
											style: new TextStyle(fontSize: 16.0),
										),
									],
								)
							),
							Container(
								margin: const EdgeInsets.only(top: 30),
								child: RaisedButton(
									color: Colors.lightBlueAccent,
									onPressed: () {
										// Validate will return true if the form is valid, or false if
										// the form is invalid.
										this.submit();
									},
									child: Text('Submit'),
								),
							),

						]
					)
				),
				inAsyncCall: _modal),
		);
	}
}