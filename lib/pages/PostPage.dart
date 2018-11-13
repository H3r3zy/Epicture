import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:epicture_flutter/imgur.dart';

// Created by martin the 04/11/18 at 11:55

class _UploadData {
	String title = 'No title';
	String description = 'No description';
	String privacy = 'secret';
	File image;
}

class PostPageState extends State<PostPage> {
	final _formKey = GlobalKey<FormState>();
	var _data = new _UploadData();
	var _imageUpload = false;
	var _submit = false;

	void submit() async {
		// First validate form.
		if (this._formKey.currentState.validate() && this._data.image != null) {
			_formKey.currentState.save(); // Save our form now.
			setState(() {
				_submit = true;
			});
			await Imgur.uploadImage(_data.title, _data.description, _data.image, _data.privacy);
			Navigator.pop(context);
		}
	}

	imageSelectorGallery() async {
		this._data.image = await ImagePicker.pickImage(
			source: ImageSource.gallery,
			// maxHeight: 50.0,
			// maxWidth: 50.0,
		);
		setState(() {
			if (this._data.image != null)
				_imageUpload = true;
		});
	}

	//display image selected from camera
	imageSelectorCamera() async {
		this._data.image = await ImagePicker.pickImage(
			source: ImageSource.camera,
			//maxHeight: 50.0,
			//maxWidth: 50.0,
		);
		setState(() {
			if (this._data.image != null)
				_imageUpload = true;
		});
	}

	@override
	Widget build(BuildContext context) {
		//display image selected from gallery
		return new Scaffold(
			appBar: new AppBar(
				title: new Text('Upload Image'),
			),

			body: ModalProgressHUD(
				child: new Container(
					padding: new EdgeInsets.all(20.0),
					child: Form(
						key: _formKey,
						child: new ListView(
							padding: EdgeInsets.all(8.0),
							children: [
								Column(
									children: [
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
										)
									],
								),
								Column(
									children: [
										Container(
											padding: const EdgeInsets.only(top: 10),
											child: TextFormField(
												maxLines: null,
												decoration: InputDecoration(
													hintText: 'Enter your image\'s descriptions',
													fillColor: Colors.white,
													filled: true,
													border: OutlineInputBorder(
														borderRadius: BorderRadius.circular(5.0),
													),
												),
												validator: (value) {},
												onSaved: (String value) {
													this._data.description = value;
												}
											),
										)
									],
								),
								Container(
									padding: const EdgeInsets.only(top: 20),
									child: Column(
										children: [
											Row(
												mainAxisAlignment: MainAxisAlignment.spaceBetween,
												children: [
													Container(
														child: new RaisedButton(
															child: new Text('From Gallery'),
															onPressed: imageSelectorGallery,
														),
													),
													Container(
														child: new RaisedButton(
															child: new Text('Fom Camera'),
															onPressed: imageSelectorCamera,

														),
													),
												]
											),
											Text(
												(_imageUpload == true) ? "An image was uploaded" : "No image uploaded",
												style: TextStyle(
													color: (_imageUpload == true) ? Colors.green : Colors.red
												)
											)

										],
									),
								),
								Container(
									margin: const EdgeInsets.only(top: 10),
									child: Row(
										children: <Widget>[
											new Radio(
												onChanged: (String val) {
													setState(() => _data.privacy = val);
												},
												activeColor: Colors.grey,
												value: "secret",
												groupValue: _data.privacy,
											),
											new Text(
												'Secret',
												style: new TextStyle(fontSize: 16.0),
											),
											new Radio(
												onChanged: (String val) {
													setState(() => _data.privacy = val);
												},
												activeColor: Colors.grey,
												value: "hidden",
												groupValue: _data.privacy,
											),
											new Text(
												'Hidden',
												style: new TextStyle(fontSize: 16.0),
											),
											new Radio(
												onChanged: (String val) {
													setState(() => _data.privacy = val);
												},
												activeColor: Colors.grey,
												value: "public",
												groupValue: _data.privacy,
											),
											new Text(
												'Public',
												style: new TextStyle(fontSize: 16.0),
											),
										],
									)
								),
								Container(
									margin: const EdgeInsets.only(top: 20),
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

							],
						),
					),
				)
				, inAsyncCall: _submit),
		);
	}
}

class PostPage extends StatefulWidget {

	PostPage({Key key}) : super(key: key);

	@override
	PostPageState createState() => new PostPageState();
}