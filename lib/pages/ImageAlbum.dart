import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:epicture_flutter/imgur.dart';
import 'package:epicture_flutter/globals.dart' as globals;

class albumData {
	String id;
	String title;
	int images_count;
	String privacy;
	int views;
	String deletehash = "";
	String errorMsg = "";
	bool error = false;
	bool isIn = false;

	albumData(this.id, this.title, this.images_count, this.privacy, this.views);
}

class imageAlbum extends StatefulWidget {
	String image;
	String album;

	imageAlbum(this.image, this.album);

	@override
	State<StatefulWidget> createState() {
		return imageAlbumState(image, album);
	}
}

class imageAlbumState extends State<imageAlbum> {
	bool isPerformingRequest = true;
	albumData _albums = albumData("", "", 0, "Hidden", 0);
	final String image;
	final String album;

	imageAlbumState(this.image, this.album);

	Future<albumData> makeRequest() async {
		var response = await Imgur.getAlbumData(album, globals.username);
		albumData ret = albumData("", "", 0, "Hidden", 0);
		if (response["error"] != null) {
			ret.errorMsg = response["error"];
			ret.error = true;
			return ret;
		}
		ret.id = album;
		ret.title = response["title"];
		ret.images_count = response["images_count"];
		ret.views = response["views"];
		ret.privacy = response["privacy"];
		ret.isIn = false;
		for (var img in response["images"]) {
			if (img["id"] == image) {
				ret.deletehash = response["deletehash"];
				ret.isIn = true;
				break;
			}
		}
		return ret;
	}

	_getMoreData() async {
		albumData newEntries = await makeRequest();
		_albums = newEntries;
		isPerformingRequest = false;
		setState(() {});
	}

	@override
	void initState() {
		super.initState();
		_getMoreData();
	}

	@override
	Widget build(BuildContext context) {
		//display image selected from gallery
		return new Scaffold(
			appBar: new AppBar(
				title: new Text("${_albums.title}"),
			),

			body: ModalProgressHUD(
				child: ListView(
					children: <Widget>[
						Container(
							margin: const EdgeInsets.only (top: 20),
						),
						Text(
							"Images: " + _albums.images_count.toString(),
							style: TextStyle(
								color: Colors.white,
								fontSize: 20
							),
						),
						Text(
							"Views: " + _albums.views.toString(),
							style: TextStyle(
								color: Colors.white,
								fontSize: 20
							),
						),
						Text(
							"Privacy: " + _albums.privacy,
							style: TextStyle(
								color: Colors.white,
								fontSize: 20
							),
						),
						Container(
							margin: const EdgeInsets.only (top: 20),
							child: new SizedBox(
								width: double.infinity,
								// height: double.infinity,
								child: new RaisedButton(
									padding: const EdgeInsets.all(8.0),
									textColor: Colors.white,
									color: (_albums.isIn == true) ? Colors.redAccent : Colors.lightBlueAccent,
									onPressed: () async {
										isPerformingRequest = true;

										var res;
										if (_albums.isIn == true)
											res = await Imgur.removeImageToAnAlbum(album, _albums.deletehash);
										else
											res = await Imgur.addImageToAnAlbum(album, image);
										if (res == true || (res["error"] != null && res["error"] == "You must own all the image ids to add them to album $album")) {
											Navigator.pop(context, !_albums.isIn);
										} else if (res["error"] != null) {
											_albums.errorMsg = res["error"];
											_albums.error = true;
										}

										isPerformingRequest = false;
										setState(() {});
									},
									child: new Text(
										(_albums.isIn == true) ? "Remove from this album" : "Add to this album",
										style: new TextStyle(
											fontSize: 25.0,
											color: Colors.white,
										),
									),
								),
							),
						),
						Container(
							padding: const EdgeInsets.only(top: 20),
							child: Text(
								(_albums.error == true) ? _albums.errorMsg : "",
								style: new TextStyle(
									fontSize: 18.0,
									color: Colors.red,
								),
							)
						)
					],
				),
				inAsyncCall: isPerformingRequest),
		);
	}
}
