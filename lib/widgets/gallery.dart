import 'package:epicture_flutter/widgets/card.dart';
import 'package:flutter/material.dart';

class GalleryState extends State<Gallery> {
  ScrollController _scroll;
  List data;
  int page = 0;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  var callback;

  GalleryState(this.callback);

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
    return RefreshIndicator(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
                  return (new CardImgur(data[index]));
                },
        itemCount: data == null ? 0 : data.length,
      ),
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

      if (maxScroll - currentScroll <= delta) {
        this.callback(this.page + 1).then((tmp) {
          if (!this.mounted)
            return;
          setState(() {
            if (this.data == null) {
              this.data = tmp;
            } else {
              this.data = new List.from(this.data)
                ..addAll(tmp);
            }

            this.page += 1;
          });
        });
      }
    });
  }
}


class Gallery extends StatefulWidget {
  final callback;

  Gallery(this.callback, {Key key}): super(key:key);

  @override
  GalleryState createState() => new GalleryState(this.callback);
}