import 'package:epicture_flutter/imgur.dart';
import 'package:epicture_flutter/widgets/gallery.dart';
import 'package:flutter/material.dart';

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tab;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            new Container(
              constraints: BoxConstraints(maxHeight: 40.0),
              child: new Material(
                color: Color.fromRGBO(16, 16, 16, 1.0),
                child: TabBar(
                  tabs: [
                    Tab(text: "Hot"),
                    Tab(text: "Top")
                  ],
                  controller: _tab,
                ),
              )
            )           ,
            new Expanded(
                child: TabBarView(
                  children: [
                    new Gallery((page) async {
                      return await Imgur.getImages(page: page, type: "hot");
                    }),
                    new Gallery((page) async {
                      return await Imgur.getImages(page: page, type: "top");
                    })
                  ],
                  controller: _tab,
                )
            )
          ]
        )
    );
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}