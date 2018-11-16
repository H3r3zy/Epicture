import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:epicture_flutter/imgur.dart';
import 'package:epicture_flutter/globals.dart' as globals;

import 'package:epicture_flutter/pages/ManageAlbum.dart';
import 'package:epicture_flutter/pages/album.dart';

class albumData {
	final String id;
	final String title;
	final int images_count;
	final String privacy;
	final int views;

	albumData(this.id, this.title, this.images_count, this.privacy, this.views);
}

class albumPage extends StatefulWidget {
	@override
	State<StatefulWidget> createState() {
		return albumPageState();
	}
}

class albumPageState extends State<albumPage> {
	List<albumData> _albums = [];
	ScrollController _scrollController = new ScrollController();
	bool isPerformingRequest = false;
	var index = 0;
	bool getData = false;

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
			setState(() {
				isPerformingRequest = true;
				getData = true;
			});
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
			setState(() {
				_albums.addAll(newEntries);
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
		_albums.clear();
		index = 0;
		_getMoreData();
	}

	@override
	Widget build(BuildContext context) {
		//display image selected from gallery
		return new Scaffold(
			appBar: new AppBar(
				title: new Text('Add a new Albums'),
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
					},
					controller: _scrollController,
				),
				inAsyncCall: isPerformingRequest),
		);
	}
}
