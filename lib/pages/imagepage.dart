import 'package:cached_network_image/cached_network_image.dart';
import 'package:epicture_flutter/functions/mustBeConnected.dart';
import 'package:epicture_flutter/imgur.dart';
import 'package:epicture_flutter/widgets/CommentForm.dart';
import 'package:epicture_flutter/widgets/card/CardTags.dart';
import 'package:epicture_flutter/widgets/card/card.action.dart';
import 'package:epicture_flutter/widgets/comment.widget.dart';
import 'package:flutter/material.dart';

class ImagePageState extends State<ImagePage>
	with SingleTickerProviderStateMixin {
	var image;
	var _comments;
	bool comment = false;
	TabController controller;
	List<Widget> carousel = [];
	double maxRatio = 0.0;
	int maxHeight = 0;

	ImagePageState(this.image);

	handleArrow(int delta) {
		if (!controller.indexIsChanging)
			controller
				.animateTo((controller.index + delta).clamp(0, carousel.length - 1));
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Color.fromRGBO(35, 35, 35, 1.0),
			appBar: new AppBar(title: Text(image["title"] ?? "Unknown")),
			body: SingleChildScrollView(
				child: Column(
					children: [
						(carousel.length != 1 && controller != null)
							? Container(
							margin: const EdgeInsets.only(top: 16.0),
							child: SingleChildScrollView(
								scrollDirection: Axis.horizontal,
								child: Row(
									children: <Widget>[
										IconButton(
											icon: const Icon(Icons.chevron_left),
											color: Colors.white,
											onPressed: () {
												handleArrow(-1);
											},
											tooltip: 'Previous image'),
										TabPageSelector(controller: controller),
										IconButton(
											icon: const Icon(Icons.chevron_right),
											color: Colors.white,
											onPressed: () {
												handleArrow(1);
											},
											tooltip: 'Next image')
									], mainAxisAlignment: MainAxisAlignment.spaceBetween)))
							: null,
						(controller != null) ?
						(AspectRatio(
							aspectRatio: this.maxRatio,
							child: TabBarView(
								controller: controller,
								children: carousel,
							))) : null,
						CardAction(object: this.image),
						CardTags(object: this.image),
						Divider(color: Colors.white),
						Center(
							child: FlatButton(
								child: Text("Add Comment", style: TextStyle(color: Colors.white)),
								onPressed: () {
									mustBeConnected(context, () {
										setState(() {
											comment = true;
										});
									});
								},
							))
					].where((a) => a != null).toList()
						..add((comment)
							? (CommentForm(
							marginLeft: 0.0,
							imageId: image["id"],
							callback: (cmt) {
								setState(() {
									this.comment = false;
									if (cmt == null)
									  return;
									if (_comments == null) {
										this._comments = [cmt];
									} else {
										this._comments.insert(0, cmt);
										print(this._comments);
									}
								});
							},
						))
							: (Container()))
						..addAll(List.generate(
							(_comments != null) ? _comments.length : 0, (index) {
							return Comment(comment: _comments[index]);
						}))
				)
			));
	}

	@override
	void initState() {
		super.initState();

		Imgur.getComments(image["id"]).then((res) {
			setState(() {
        if (res is Map<String, String>) {
			    print("init");
          _comments = [];
        } else
  				_comments = res;
			});
		});

		if (this.image["is_album"] == true) {
			Imgur.getAlbumImages(this.image["id"]).then((images) {
				print(images);
				this.image["images"] = images;
				print(images.length);
				for (var img in images) {
					if (img["link"].toString().indexOf("mp4") != -1)
						continue;
					carousel.add(AspectRatio(
						aspectRatio: img["width"] / img["height"],
						child: CachedNetworkImage(
							imageUrl: img["link"],
							placeholder: Center(child: CircularProgressIndicator()),
						)));
					if (this.maxHeight < img["height"])
						this.maxHeight = img["height"];
					this.maxRatio = img["width"] / img["height"];
				}
				controller = new TabController(length: carousel.length, vsync: this);
			});
		} else {
			carousel.add(AspectRatio(
				aspectRatio: image["width"] / image["height"],
				child: CachedNetworkImage(
					imageUrl: image["link"],
					placeholder: Center(child: CircularProgressIndicator()),
				)));
			this.maxRatio = image["width"] / image["height"];
			controller = new TabController(length: carousel.length, vsync: this);
		}
	}
}

class ImagePage extends StatefulWidget {
	final image;

	ImagePage(this.image);

	@override
	ImagePageState createState() {
		return new ImagePageState(image);
	}
}
