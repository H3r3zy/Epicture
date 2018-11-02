import 'package:cached_network_image/cached_network_image.dart';
import 'package:epicture_flutter/imgur.dart';
import 'package:epicture_flutter/pages/UserPage.dart';
import 'package:flutter/material.dart';

// Created by sahel the 02/11/18 at 11:14

class AvatarState extends State<Avatar> {
  final String username;
  var avatar;
  final double size;

  AvatarState({this.username, this.avatar, this.size});

  @override
  Widget build(BuildContext context) {
    return (this.avatar != null) ? GestureDetector(
      child: Container(
          alignment: Alignment.topCenter,
          width: this.size,
          height: this.size,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: CachedNetworkImageProvider(this.avatar)
              )
          )
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => new UserPage(username: this.username)
        ));
        },
    ) : Container();
  }

  @override
  void initState() {
    super.initState();
    if (this.avatar != null)
      return;

    Imgur.getAvatarAccount(this.username).then((res) {
      if (!this.mounted)
        return;
      setState(() {
        this.avatar = res["avatar"];
      });
    });
  }
}

class Avatar extends StatefulWidget {
  final String username;
  final double size;
  final String url;

  Avatar({Key key, this.username, this.size = 32.0, this.url}) : super(key: key);

  @override
  AvatarState createState() => new AvatarState(username: this.username, size: this.size, avatar: this.url);
}