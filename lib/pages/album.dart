import 'package:flutter/material.dart';
import 'package:epicture_flutter/imgur.dart';
import 'package:epicture_flutter/globals.dart' as globals;
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:epicture_flutter/widgets/gallery.dart';

class PictureAlbum {
	String id;
	String title;
	String picture;

	PictureAlbum(this.id, this.title, this.picture);
}

class album extends StatefulWidget {
	String id;
	String albumName;

	album(this.id, this.albumName);

	@override
	State<StatefulWidget> createState() {
		return albumState(id, albumName);
	}
}

class albumState extends State<album> {
	final String id;
	final String albumName;
	bool isPerformingRequest = false;

	albumState(this.id, this.albumName);

	@override
	Widget build(BuildContext context) {
		//display image selected from gallery
		return new Scaffold(
			appBar: new AppBar(
				title: new Text('$albumName'),
			),

			body: ModalProgressHUD(
				child: Gallery((page) async {
					var res = await Imgur.getAlbumImage(this.id);
					for (var img in res) {
						img["account_url"] = globals.username;
					}
					return res;
				}, grid: true),
				inAsyncCall: isPerformingRequest),
		);
	}
}
