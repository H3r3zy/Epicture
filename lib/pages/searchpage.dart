import 'package:epicture_flutter/imgur.dart';
import 'package:epicture_flutter/tags.widget.dart';
import 'package:epicture_flutter/widgets/gallery.dart';
import 'package:flutter/material.dart';

class SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin {
  String _search;
  Gallery _child;
  final GlobalKey<GalleryState> _key = GlobalKey<GalleryState>();
  var _tags;
  var _tagsWidget;

  // TODO maybe made search with showSearch
  tagsCreator(context) {
    var res = <Widget>[];

    if (_tags == null)
      return res;

    for (var tag in _tags) {
      res.add(new TagsImgur(tag).view(context));
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    _child = new Gallery(
            (page) async {
              return await Imgur.search(search: this._search, page: page);
            },
        key: _key
    );

    _tagsWidget = new ListView(
        children: tagsCreator(context)
    );

    return new Column(
        children: [
          Container(
            color: Color.fromRGBO(35, 35, 35, 1.0),

            child: ListTile(
              leading: Icon(Icons.search, color: Colors.white),
                title: TextField(
                    decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(color: Colors.white)
                    ),
                    style: TextStyle(color: Colors.white, fontSize: 15),
                    cursorColor: Colors.white,
                    onSubmitted: (String text) {
                      setState(() {
                        this._search = text;
                        _key.currentState.refresh();
                      });
                    },
                  )
            ),
            width: MediaQuery.of(context).size.width * 0.75,
          ),
          Expanded(
              child: Builder(
                builder: (BuildContext context) {
                  return this._search == null || this._search == "" ? _tagsWidget : _child;
                },
              )

          )
        ]
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  getTags() async {
    var tags = await Imgur.getTags();
    if (!this.mounted)
      return;
    setState(() {
      this._tags = tags;
    });
  }

  @override
  void initState() {
    super.initState();

    this.getTags();
  }
}

class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => new SearchPageState();
}