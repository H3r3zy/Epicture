import 'package:cached_network_image/cached_network_image.dart';
import 'package:epicture_flutter/imgur.dart';
import 'package:epicture_flutter/widgets/Avatar.dart';
import 'package:epicture_flutter/widgets/gallery.dart';
import 'package:epicture_flutter/widgets/profile/ProfileHeader.dart';
import 'package:flutter/material.dart';

// Created by sahel the 02/11/18 at 10:57

class UserPageState extends State<UserPage> with SingleTickerProviderStateMixin {
  final String username;
  var user;
  ScrollController scrollController;
  TabController tabController;
  final bool safeArea;

  UserPageState(this.username, this.safeArea);

  @override
  Widget build(BuildContext context) {
    if (this.user == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator()
        )
      );
    }

    return Scaffold(
      body: SafeArea(
        top: this.safeArea,
        child: NestedScrollView(
                controller: scrollController,
                headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
                  return [
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                      child: SliverAppBar(
                          forceElevated: false,
                          centerTitle: true,
                          pinned: true,
                          backgroundColor: Colors.transparent,
                      ),
                    )
                  ];
                },
                body: Container(
                  color: Color.fromRGBO(35, 35, 35, 1.0),
                  child: Column(
                      children: [
                        ProfileHeader(user: this.user),
                        TabBar(
                            tabs: [
                              Tab(text: "Posts"),
                              Tab(text: "Favorites")
                            ],
                            controller: tabController
                        ),
                        Expanded(
                            child: Container(
                              color: Color.fromRGBO(15, 15, 15, 1.0),
                              child: TabBarView(
                                  controller: tabController,
                                  children: [
                                    Gallery((page) async {
                                      return await Imgur.getImagesOfUser(page: page, username: this.user["url"]);
                                    }, grid: true),
                                    Gallery((page) async {
                                      return await Imgur.getFavorites(page: page, username: this.user["url"]);
                                    }, grid: true)
                                  ]
                              )
                            )
                        )
                      ]
                  )
                )
            ),
      )
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    scrollController = new ScrollController();
    tabController = TabController(length: 2, vsync: this);

    Imgur.getAccount(this.username).then((res) {
      setState(() {
        this.user = res;
      });
    });
  }
}

class UserPage extends StatefulWidget {
  final String username;
  final bool safeArea;

  UserPage({Key key, this.username, this.safeArea = true}) : super(key: key);

  @override
  UserPageState createState() => new UserPageState(this.username, this.safeArea);
}