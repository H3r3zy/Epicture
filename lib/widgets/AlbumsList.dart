import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:epicture_flutter/imgur.dart';
import 'package:epicture_flutter/globals.dart' as globals;

import 'package:epicture_flutter/pages/ManageAlbum.dart';
import 'package:epicture_flutter/pages/album.dart';
import 'package:epicture_flutter/pages/ImageAlbum.dart';

class albumData {
	final String id;
	final String title;
	int images_count;
	final String privacy;
	final int views;

	albumData(this.id, this.title, this.images_count, this.privacy, this.views);
}

class albumPage extends StatefulWidget {
	String image;

	albumPage(this.image);

	@override
	State<StatefulWidget> createState() {
		return albumPageState(image);
	}
}

class albumPageState extends State<albumPage> {
	List<albumData> _albums = [];
	ScrollController _scrollController = new ScrollController();
	bool isPerformingRequest = false;
	var index = 0;
	bool getData = false;
	String image;

	albumPageState(this.image);

	Future<List<albumData>> makeRequest() async {
		var response = await Imgur.getAlbumListFromUserByPage(index, globals.username);
		List<albumData> ret = new List<albumData>();

		index += 1;
		for (var album in response["data"]) {
			ret.add(new albumData(album["id"], album["title"], album["images_count"], album["privacy"], album["views"]));
		}
		return ret;
	}

	_getMoreData() async {
		if (!isPerformingRequest) {
			isPerformingRequest = true;
			getData = true;
			List<albumData> newEntries = await makeRequest();
			if (newEntries.isEmpty) {
				double edge = 50.0;
				double offsetFromBottom = _scrollController.position.maxScrollExtent - _scrollController.position.pixels;
				if (offsetFromBottom < edge) {
					_scrollController.animateTo(
						_scrollController.offset - (edge - offsetFromBottom),
						duration: new Duration(milliseconds: 500),
						curve: Curves.easeOut);
				}
			}
			_albums.addAll(newEntries);
			isPerformingRequest = false;
			setState(() {});
		}
	}

	Widget _buildProgressIndicator() {
		return new Padding(
			padding: const EdgeInsets.all(8.0),
			child: new Center(
				child: new Opacity(
					opacity: isPerformingRequest ? 1.0 : 0.0,
					child: new CircularProgressIndicator(),
				),
			),
		);
	}

	@override
	void dispose() {
		super.dispose();
		_scrollController.dispose();
	}

	@override
	void initState() {
		super.initState();
		if (getData == false)
			_getMoreData();
		_scrollController.addListener(() {
			if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
				_getMoreData();
			}
		});
	}

	updateDataAfterChange(page) async {
		await Navigator.push(
			context, MaterialPageRoute(
			builder: (context) => page)
		);
		_albums.clear();
		index = 0;
		await _getMoreData();
	}

	Widget albumPage(index) {
		return ListTile(
			title: new Text(
				"${_albums[index].title}",
				style: TextStyle(
					color: Colors.white
				),
			),
			trailing: InkWell(
				child: const Icon(Icons.settings, color: Colors.white),
				onTap: () {
					updateDataAfterChange(new ManageAlbumPage(_albums[index].id));
				},
			),
			// const Icon(Icons.settings),
			subtitle: new Text(
				"${_albums[index].privacy} - ${_albums[index].images_count} images - ${_albums[index].views} views",
				style: TextStyle(color: Colors.grey),
			),
			onTap: () {
				updateDataAfterChange(new album(_albums[index].id, _albums[index].title));
			},
		);
	}

	Widget imageAlbumManage(index) {
		return ListTile(
			title: new Text(
				"${_albums[index].title}",
				style: TextStyle(
					color: Colors.white
				),
			),
			trailing: InkWell(
				child: const Icon(Icons.remove_red_eye, color: Colors.white),
				onTap: () async {
					var res = await Navigator.push(
						context, MaterialPageRoute(
						builder: (context) => new imageAlbum(image, _albums[index].id))
					);
					if (res != null)
						_albums[index].images_count += ((res) ? 1 : -1);
				},
			),
			// const Icon(Icons.settings),
			subtitle: new Text(
				"${_albums[index].privacy} - ${_albums[index].images_count} images - ${_albums[index].views} views",
				style: TextStyle(color: Colors.grey),
			),
			onTap: () async {
				var res = await Navigator.push(
					context, MaterialPageRoute(
					builder: (context) => new imageAlbum(image, _albums[index].id))
				);
				if (res != null)
					_albums[index].images_count += ((res) ? 1 : -1);
			},
		);
	}

	@override
	Widget build(BuildContext context) {
		//display image selected from gallery
		return new Scaffold(
			appBar: new AppBar(
				title: new Text((image == null) ? 'Add a new Albums' : "Manage album"),
				actions: <Widget>[
					// action button
					IconButton(
						icon: const Icon(Icons.add),
						onPressed: () {
							updateDataAfterChange(new ManageAlbumPage(null));
						},
					),
				],
			),

			body: ModalProgressHUD(
				child: ListView.builder(
					itemCount: _albums.length,
					itemBuilder: (context, index) {
						if (index + 1 == _albums.length) {
							return _buildProgressIndicator();
						} else {
							return (image != null) ? imageAlbumManage(index) : albumPage(index);
						}
					},
					controller: _scrollController,
				),
				inAsyncCall: isPerformingRequest),
		);
	}
}
