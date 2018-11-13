import 'package:cached_network_image/cached_network_image.dart';
import 'package:epicture_flutter/pages/imagepage.dart';
import 'package:epicture_flutter/widgets/card/CardImage.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:epicture_flutter/widgets/card.dart';
import 'package:flutter/material.dart';

class GalleryState extends State<Gallery> {
	ScrollController _scroll;
	List data;
	int page = 0;
	final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
	var callback;
	final bool grid;
	final int gridSize;
	bool requested = false;

	GalleryState(this.callback, this.grid, this.gridSize);

	refresh() {
		setState(() {
			this.data = null;

			this.callback(this.page).then((res) {
				if (!this.mounted) {
					return;
				}
				setState(() {
					this.page = 0;
					this.data = res;
				});
			});
		});
	}

	@override
	Widget build(BuildContext context) {
		var child;

		if (this.grid == false) {
			child = ListView.builder(
				controller: _scroll,
				physics: ScrollPhysics(),
				cacheExtent: 10.0,
				itemBuilder: (BuildContext context, int index) {
					return (new CardImgur(data[index]));
				},
				itemCount: data == null ? 0 : data.length,
			);
		} else {
			child = StaggeredGridView.countBuilder(
				controller: _scroll,
				crossAxisCount: 2,
				staggeredTileBuilder: (_) => StaggeredTile.fit(1),
				itemBuilder: (context, index) {
					var object = data[index];

					var uri = (object["is_album"] == false) ?
					object["link"] :
					object["images"][0]["link"];

					if (object["images"] != null && object["images"][0]["type"] == "video/mp4") {
						return new Container(color: Colors.white);
					}
					if (uri.toString().indexOf("mp4") != -1)
						return new Container(color: Colors.white);
					object["uri"] = uri;

					return (new Container(
						margin: EdgeInsets.all(2.5),
						color: Color.fromRGBO(55, 55, 55, 1.0),
						child: Column(
							children: [
								CardImage(url: object["uri"], image: object),
								Container(
									padding: EdgeInsets.all(5.0),
									child: Column(
										children: [
											Align(
												alignment: Alignment.centerLeft,
												child: Text(object["title"])
											),
											Align(
												alignment: Alignment.centerLeft,
												child: Row(
													children: [
														Icon(Icons.arrow_upward, size: 11, color: Color.fromRGBO(180, 180, 180, 1.0),),
														(object["score"] != null) ?
														Text(" " + object["score"].toString() + " Points", style: TextStyle(color: Color.fromRGBO(180, 180, 180, 1.0), fontSize: 10)) :
														Text(" " + object["points"].toString() + " Points", style: TextStyle(color: Color.fromRGBO(180, 180, 180, 1.0), fontSize: 10),)
													]
												)
											)
										]
									)
								)
							]
						)
					));
				},
				itemCount: data == null ? 0 : data.length,
			);
		}

		return RefreshIndicator(
			child: child,
			onRefresh: () async {
				setState(() {
					this.data = null;

					this.callback(this.page).then((res) {
						if (!this.mounted)
							return;
						setState(() {
							this.page = 0;
							this.data = res;
						});
					});
				});
				return this.data;
			},
			key: _refreshIndicatorKey,
		);
	}

	@override
	void initState() {
		super.initState();
		this.callback(0).then((res) {
			if (!this.mounted)
				return;
			setState(() {
				this.data = res;
			});
		});

		_scroll = new ScrollController();
		_scroll.addListener(() {
			double maxScroll = _scroll.position.maxScrollExtent;
			double currentScroll = _scroll.position.pixels;
			double delta = 200.0;

			if (maxScroll - currentScroll <= delta && requested == false) { // TODO Test with 3 page and delete previous / past
				requested = true;
				this.callback(this.page + 1).then((tmp) {
					if (!this.mounted) {
						requested = false;
						return;
					}
					setState(() {
						if (this.data == null) {
							this.data = tmp;
						} else {
							this.data = new List.from(this.data)
								..addAll(tmp);
						}

						this.page += 1;
						requested = false;
					});
				});
			}
		});
	}
}

class Gallery extends StatefulWidget {
	final callback;
	final bool grid;
	final int gridSize;

	Gallery(this.callback, {Key key, this.grid = false, this.gridSize = 2}) : super(key: key);

	@override
	GalleryState createState() => new GalleryState(this.callback, grid, gridSize);
}