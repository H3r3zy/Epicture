import 'package:epicture_flutter/imgur.dart';
import 'package:flutter/material.dart';
import 'package:epicture_flutter/widgets/card.dart';

class TagPageState extends State<TagPage> with SingleTickerProviderStateMixin {
  ScrollController _scroll;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  List data;
  String tag = "";
  int page = 0;

  TagPageState(this.tag);

  getTagSearch(int page) async {
    this.page = page;
    var images = await Imgur.tagSearch(tag: this.tag, page: this.page);
    images = images["items"];

    setState(() {
      if (data == null)
        data = images;
      else
        data = new List.from(data)..addAll(images);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text(this.tag),
              backgroundColor: Colors.black,
            )
          ];
        },
        body: RefreshIndicator(
          child: ListView.builder(
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (BuildContext context, int index) {
              return (new CardImgur(data[index]));
            },
            controller: _scroll,
          ),
          onRefresh: () {
            setState(() => this.data = null);
            return this.getTagSearch(0);
          },
          key: _refreshIndicatorKey,
        ),
      ),
      backgroundColor: Color.fromRGBO(25, 25, 25, 1.0),
    );
  }

  @override
  void initState() {
    super.initState();
    this.getTagSearch(0);

    _scroll = new ScrollController();
    _scroll.addListener(() {
      double maxScroll = _scroll.position.maxScrollExtent;
      double currentScroll = _scroll.position.pixels;
      double delta = 200.0;

      if (maxScroll - currentScroll <= delta) {
        this.getTagSearch(this.page + 1);
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }
}

class TagPage extends StatefulWidget {
  final String tag;

  TagPage(this.tag);

  @override
  TagPageState createState() => new TagPageState(this.tag);
}