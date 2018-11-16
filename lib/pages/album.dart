import 'package:flutter/material.dart';
import 'package:epicture_flutter/imgur.dart';
import 'package:epicture_flutter/globals.dart' as globals;
import 'package:modal_progress_hud/modal_progress_hud.dart';

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

	albumState(this.id, this.albumName);

	List<PictureAlbum> _images = [];
	ScrollController _scrollController = new ScrollController();
	bool isPerformingRequest = false;
	var index = 0;
	bool getData = false;

	Future<List<PictureAlbum>> makeRequest() async {
		var response = await Imgur.getAlbumListFromUserByPage(index, globals.username);
		List<PictureAlbum> ret = new List<PictureAlbum>();
		index += 1;
		return ret;
	}

	_getMoreData() async {
		if (!isPerformingRequest) {
			setState(() {
				isPerformingRequest = true;
				getData = true;
			});
			List<PictureAlbum> newEntries = await makeRequest();
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
			setState(() {
				_images.addAll(newEntries);
				isPerformingRequest = false;
			});
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
		_scrollController.dispose();
		super.dispose();
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
		_images.clear();
		index = 0;
		_getMoreData();
	}

	@override
	Widget build(BuildContext context) {
		//display image selected from gallery
		return new Scaffold(
			appBar: new AppBar(
				title: new Text('$albumName'),
			),

			body: ModalProgressHUD(
				child: ListView.builder(
					itemCount: _images.length,
					itemBuilder: (context, index) {
						if (index + 1 == _images.length) {
							return _buildProgressIndicator();
						} else {
							return ListTile(
								title: new Text("${_images[index].title}"),
								trailing: InkWell(
									child: const Icon(Icons.settings),
									onTap: () {
									},
								),
								// const Icon(Icons.settings),
//								subtitle: new Text("${_albums[index].privacy} - ${_albums[index].images_count} images - ${_albums[index].views} views"),
								onTap: () {
								},
							);
						}
					},
					controller: _scrollController,
				),
				inAsyncCall: isPerformingRequest),
		);
	}
}
