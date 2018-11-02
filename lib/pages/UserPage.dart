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

  UserPageState(this.username);

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
                body: Column(
                  children: [
                    ProfileHeader(user: this.user),
                    TabBar(
                      tabs: [
                        Tab(text: "Posts"),
                        Tab(text: "Comments")
                      ],
                      controller: tabController
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                          children: [
                            Gallery((page) async {
                              return await Imgur.getImagesOfUser(page: page, username: this.user["url"]);
                            }),
                            Gallery((page) async {
                              return await Imgur.getImagesOfUser(page: page, username: this.user["url"]);
                            })
                          ]
                      )
                    )
                  ]
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

  UserPage({Key key, this.username}) : super(key: key);

  @override
  UserPageState createState() => new UserPageState(this.username);
}